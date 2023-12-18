module AutoVendingFSM (
    input clk,                          //时钟信号,25kHz
    input rst_n,                        //复位信号
    
    //选择商品相关
    input select_flag,                  //选择信号
    output reg  selected_sta_flag,      //已选择状态标志
    //input reselect_flag,              //取消固定选择信号
    //output reg [2:0] selected_num,      //选择数量
    //投币有关
    input coin_sig,
    output reg coin_fn_flag,

    //支付有关
    output reg pay_st_flag,
    input nonenough_flag,               //钱不够信号
    output pay_sta_flag,

    //找零/退币有关
    input charge_flag,
    output reg charge_st_flag,          //开始找零信号

    //确定取消
    input sure_flag,cancel_flag,        //确定信号,取消信号

    output if_pay_flag,
    output if_coin_flag,
    output if_charge_flag,
    output coin_sta_flag
);
    
    localparam idle_state = 3'b000;         //空闲状态(未选状态)
    localparam selected_state = 3'b001;     //已选状态
    localparam pay_if_state = 3'b010;       //是否支付状态
    localparam pay_delay_state = 3'b011;    //支付延时状态

    localparam coin_if_state = 3'b100;      //是否投币状态
    localparam coin_delay_state = 3'b101;   //投币延时状态

    localparam charge_if_state = 3'b110;    //退币状态，随时可跳转
    localparam charge_delay_state = 3'b111; //退币及延时状态

    reg [2:0] currentstate , nextstate , laststate;
    reg [16:0]count;    //延时计数值，17位，12500，延迟0.5s
    reg count_fn_flag;
    

    //状态转换，当前状态，过去状态赋值
    always @(posedge clk ,negedge rst_n) begin
        if(!rst_n) begin
            currentstate <= idle_state;
        end
        else begin
            currentstate <= nextstate;
        end
    end
    always @(posedge clk ,negedge rst_n) begin
        if(!rst_n) begin
            laststate <= idle_state;
        end
        else if(currentstate == idle_state || currentstate == selected_state)begin
            laststate <= currentstate;
        end
        else begin
            laststate <= laststate;
        end
    end

    //确定下一状态组合电路
    always @(*) begin
        if(!rst_n) begin
            nextstate = idle_state;
        end
        else begin
            case (currentstate)
                idle_state: begin       //空闲状态（未选状态）
                    if (select_flag) nextstate = selected_state;   //在选择标志置1时切换到已选状态
                    else if(coin_sig) nextstate = coin_if_state;
                    else if(charge_flag) nextstate = charge_if_state;
                    else nextstate = idle_state;
                end
                selected_state: begin
                    if (cancel_flag) nextstate = idle_state;
                    else if(sure_flag) nextstate = pay_if_state;
                    else if(coin_sig) nextstate = coin_if_state;
                    else if(charge_flag) nextstate = charge_if_state;
                    else nextstate = selected_state;
                end
                pay_if_state: begin
                    if (cancel_flag) nextstate = selected_state;
                    else if(sure_flag) nextstate = pay_delay_state;
                    else nextstate = pay_if_state;
                end
                pay_delay_state: begin
                    if(count_fn_flag) begin
                        if (nonenough_flag) begin
                            nextstate = selected_state; 
                        end
                        else nextstate = charge_if_state;       
                    end
                    else nextstate = pay_delay_state;
                end
                //可随时切换到状态
                coin_if_state: begin
                    if (cancel_flag) nextstate = laststate;
                    else if(sure_flag) nextstate = coin_delay_state;
                    else nextstate = coin_if_state;
                end
                coin_delay_state: begin
                    if (cancel_flag) nextstate = laststate;
                    else if(count_fn_flag) nextstate = laststate;
                    else nextstate = coin_delay_state;
                end
                charge_if_state: begin
                    if (cancel_flag) nextstate = laststate;
                    else if(sure_flag) nextstate = charge_delay_state;
                    else nextstate = charge_if_state;
                end
                charge_delay_state: begin
                    if (cancel_flag) nextstate = selected_state;
                    else if(count_fn_flag) nextstate = laststate;
                    else nextstate = charge_delay_state;
                end
                default: begin
                    nextstate = idle_state;
                end
            endcase
        end
    end

    assign if_pay_flag = currentstate == pay_if_state;
    assign if_coin_flag = currentstate == coin_if_state;
    assign if_charge_flag = currentstate == charge_if_state;
    //选择状态
    always @(*) begin
        if (!rst_n) begin
            selected_sta_flag = 1'b0;
        end
        else if (currentstate == selected_state) begin
            selected_sta_flag = 1'b1;
        end
        else begin
            selected_sta_flag = 1'b0;
        end
    end
    //投币状态
    assign coin_sta_flag = (currentstate == coin_delay_state);
    always @(*) begin
        if (!rst_n) begin
            coin_fn_flag = 1'b0;
        end
        else if (currentstate == coin_delay_state && count_fn_flag) begin
            coin_fn_flag = 1'b1;
        end
        else begin
            coin_fn_flag = 1'b0;
        end
    end
    //支付状态
    assign pay_sta_flag = (currentstate == pay_delay_state);
    always @(*) begin
        if (!rst_n) begin
            pay_st_flag = 1'b0;
        end
        else if (currentstate == pay_delay_state && count_fn_flag) begin
            pay_st_flag = 1'b1;
        end
        else begin
            pay_st_flag = 1'b0;
        end
    end
    //找零/退币状态
    always @(*) begin
        if (!rst_n) begin
            charge_st_flag = 1'b0;
        end
        else if (currentstate == charge_delay_state && count_fn_flag) begin
            charge_st_flag = 1'b1;
        end
        else begin
            charge_st_flag = 1'b0;
        end
    end
/*  选择数量赋值，ver2.0再写
    // 
    // always @(posedge clk ,negedge rst_n) begin
    //     if(!rst_n) begin
    //         selected_num <= 2'b0;
    //     end
    //     else if(currentstate == selected_state) begin
    //         selected_num <= 2'b1;

    //     end
    // end
*/
    // parameter count_num = 16'd12499;
    parameter count_num = 16'd100;
    // parameter count_num = 2'b10;
    //支付，投币及退币延迟计数
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 17'b0;
            count_fn_flag <= 1'b0;
        end
        else if (count >= count_num) begin
            count <= 17'b0;
            count_fn_flag <= 1'b1;
        end
        else if(currentstate == pay_delay_state || currentstate == charge_delay_state || currentstate == coin_delay_state) begin
            count <= count + 1'b1;
        end
        else begin
            count <= 17'b0;
            count_fn_flag <= 1'b0;
        end
    end
endmodule