`timescale 1ns/100ps
module FSM_tb();
    reg sys_clk;
    reg [31:0]data;     //触摸点的坐标数据,高16位为X，低16位为y
    reg touch_valid;    //触摸标志（0：未检测到触摸，1：检测到触摸）
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
        data = 32'h0064_0064;   //商品1
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h01C2_0190;   //投币5毛
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //确定键
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h01C2_01A9;   //投币5元
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //确定键
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //确定键
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //确定键
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100

        data = 32'h0064_0190;   //确定键
        touch_valid = 1'b1;
        #100 touch_valid = 1'b0;
        #100;

    end

    always #10 sys_clk = ~sys_clk;      //输出50MHz时钟

    FSM_top u_FSM_top(
        .clk(sys_clk),
        .rst_n(rst_n),
        .touch_valid(touch_valid),              //触摸检测脉冲
        .data(data),                            //坐标数据
        .product_number(product_number),        //商品序号
        .coin_val_sum(coin_val_sum)             //剩余金额
    );
endmodule