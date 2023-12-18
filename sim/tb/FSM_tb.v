`timescale 1ns/100ps
module FSM_tb();
    reg sys_clk;
    reg [31:0]data;     //���������������,��16λΪX����16λΪy
    reg touch_valid;    //������־��0��δ��⵽������1����⵽������
    reg rst_n;
    wire [3:0]product_number;
    wire [9:0]coin_val_sum;
    initial begin
        sys_clk = 1'b0;
        rst_n = 1'b0;
        touch_valid = 1'b0;
        data = 1'b0;
        #5 rst_n = 1'b1;
        #10
        data = 32'h0064_0064;   //��Ʒ1
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h01C2_0190;   //Ͷ��5ë
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //ȷ����
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h01C2_01A9;   //Ͷ��5Ԫ
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //ȷ����
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //ȷ����
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //ȷ����
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //ȷ����
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100;

    end

    always #10 sys_clk = ~sys_clk;      //���50MHzʱ��

    FSM_top u_FSM_top(
        .clk(sys_clk),
        .rst_n(rst_n),
        .touch_valid(touch_valid),              //�����������
        .data(data),                            //��������
        .product_number(product_number),        //��Ʒ���
        .coin_val_sum(coin_val_sum)             //ʣ����
    );
endmodule