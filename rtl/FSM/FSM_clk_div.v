module FSM_clk_div(         //时钟分频
    input               clk,          //50Mhz
    input               rst_n,
    output  reg         FSM_clk
    );

    // localparam FSM_clk_arr = 10'd1000;
    // reg [9:0] FSM_cnt;
    localparam FSM_clk_arr = 20'd125000;
    reg [19:0] FSM_cnt;

    //时钟2000分频 输出25KHz时钟 改为200Hz时钟，防止建立时间违例
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            FSM_cnt <= 1'b0;
            FSM_clk <= 1'b0;
        end
        else if (FSM_cnt >= FSM_clk_arr) begin
            FSM_cnt <= 1'b0;
            FSM_clk <= ~FSM_clk;
        end
        else begin
            FSM_cnt <= FSM_cnt+1;
        end
    end


endmodule
