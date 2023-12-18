module  lcd_rgb_char(
    input               sys_clk   ,
    input               sys_rst_n ,
    input               nonenough_flag,
    input               coin_ov_flag,
    input   [3:0]       product_number,
    input               if_pay_flag,
    input               if_coin_flag,
    input               if_charge_flag,
    input   [10:0]      coin_val_sum,
	//RGB LCD接口 
    output              lcd_hs    , //LCD 行同步信号
    output              lcd_vs    , //LCD 场同步信号
    output              lcd_de    , //LCD 数据输入使能
    inout      [23:0]   lcd_rgb   , //LCD RGB颜色数据
    output              lcd_bl    , //LCD 背光控制信号
    output              lcd_clk   , //LCD 采样时钟
    output              lcd_rst_n  //LCD复位
);

//wire define
wire  [10:0]  pixel_xpos_w ;
wire  [10:0]  pixel_ypos_w ;
wire  [23:0]  pixel_data_w ;
wire  [23:0]  lcd_rgb_o    ;
wire          lcd_pclk     ;

//*****************************************************
//**                    main code
//*****************************************************
//RGB565数据输出
assign lcd_rgb = lcd_de ? lcd_rgb_o : {24{1'bz}};

//分频模块，根据不同的LCD ID输出相应的频率的驱动时钟
clk_div  u_clk_div(
    .clk          (sys_clk  ),
    .rst_n        (sys_rst_n),
    .lcd_pclk     (lcd_pclk )
);


//lcd显示模块
lcd_display  u_lcd_display(          
    .lcd_pclk       (lcd_pclk    ),
    .rst_n      (sys_rst_n),
    // .data           ({bcd_data_x,bcd_data_y}),
    .nonenough_flag (nonenough_flag),
    .coin_ov_flag   (coin_ov_flag),
    .product_number (product_number),
    .coin_val_sum   (coin_val_sum),
    .if_pay_flag    (if_pay_flag),
    .if_coin_flag   (if_coin_flag),
    .if_charge_flag (if_charge_flag),

    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w)
);

//lcd驱动模块
lcd_driver  u_lcd_driver(
    .lcd_pclk       (lcd_pclk    ),
    .rst_n          (sys_rst_n   ),

    .lcd_hs         (lcd_hs      ),
    .lcd_vs         (lcd_vs      ),
    .lcd_de         (lcd_de      ),
    .lcd_bl         (lcd_bl      ),
    .lcd_clk        (lcd_clk     ),
    .lcd_rgb        (lcd_rgb_o   ),
    .lcd_rst        (lcd_rst_n   ),
    .data_req       (),
    .h_disp         (),
    .v_disp         (),
    .pixel_data     (pixel_data_w),
    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w)
); 

endmodule
