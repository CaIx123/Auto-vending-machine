module AutoVendingFSM (
    input clk,                          //ʱ���ź�,25kHz
    input rst_n,                        //��λ�ź�
    
    //ѡ����Ʒ���
    input select_flag,                  //ѡ���ź�
    output reg  selected_sta_flag,      //��ѡ��״̬��־
    //input reselect_flag,              //ȡ���̶�ѡ���ź�
    //output reg [2:0] selected_num,      //ѡ������
    //Ͷ���й�
    input coin_sig,
    output reg coin_fn_flag,

    //֧���й�
    output reg pay_st_flag,
    input nonenough_flag,               //Ǯ�����ź�
    output pay_sta_flag,

    //����/�˱��й�
    input charge_flag,
    output reg charge_st_flag,          //��ʼ�����ź�

    //ȷ��ȡ��
    input sure_flag,cancel_flag,        //ȷ���ź�,ȡ���ź�

    output if_pay_flag,
    output if_coin_flag,
    output if_charge_flag,
    output coin_sta_flag
);
    
    localparam idle_state = 3'b000;         //����״̬(δѡ״̬)
    localparam selected_state = 3'b001;     //��ѡ״̬
    localparam pay_if_state = 3'b010;       //�Ƿ�֧��״̬
    localparam pay_delay_state = 3'b011;    //֧����ʱ״̬

    localparam coin_if_state = 3'b100;      //�Ƿ�Ͷ��״̬
    localparam coin_delay_state = 3'b101;   //Ͷ����ʱ״̬

    localparam charge_if_state = 3'b110;    //�˱�״̬����ʱ����ת
    localparam charge_delay_state = 3'b111; //�˱Ҽ���ʱ״̬

    reg [2:0] currentstate , nextstate , laststate;
    reg [16:0]count;    //��ʱ����ֵ��17λ��12500���ӳ�0.5s
    reg count_fn_flag;
    

    //״̬ת������ǰ״̬����ȥ״̬��ֵ
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

    //ȷ����һ״̬��ϵ�·
    always @(*) begin
        if(!rst_n) begin
            nextstate = idle_state;
        end
        else begin
            case (currentstate)
                idle_state: begin       //����״̬��δѡ״̬��
                    if (select_flag) nextstate = selected_state;   //��ѡ���־��1ʱ�л�����ѡ״̬
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
                //����ʱ�л���״̬
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
    //ѡ��״̬
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
    //Ͷ��״̬
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
    //֧��״̬
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
    //����/�˱�״̬
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
/*  ѡ��������ֵ��ver2.0��д
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
    //֧����Ͷ�Ҽ��˱��ӳټ���
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