module clk_div(         //ʱ��2��Ƶ
    input               clk,          //50Mhz
    input               rst_n,
    output  reg         lcd_pclk
    );

//*****************************************************
//**                    main code
//*****************************************************

//ʱ��2��Ƶ ���25MHzʱ�� 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        lcd_pclk <= 1'b0;
    else
        lcd_pclk <= ~lcd_pclk;
end

endmodule
