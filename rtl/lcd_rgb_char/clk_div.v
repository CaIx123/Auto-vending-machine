module clk_div(         //时钟2分频
    input               clk,          //50Mhz
    input               rst_n,
    output  reg         lcd_pclk
    );

//*****************************************************
//**                    main code
//*****************************************************

//时钟2分频 输出25MHz时钟 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        lcd_pclk <= 1'b0;
    else
        lcd_pclk <= ~lcd_pclk;
end

endmodule
