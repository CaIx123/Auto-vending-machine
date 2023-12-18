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
	//RGB LCD�ӿ� 
    output              lcd_hs    , //LCD ��ͬ���ź�
    output              lcd_vs    , //LCD ��ͬ���ź�
    output              lcd_de    , //LCD ��������ʹ��
    inout      [23:0]   lcd_rgb   , //LCD RGB��ɫ����
    output              lcd_bl    , //LCD ��������ź�
    output              lcd_clk   , //LCD ����ʱ��
    output              lcd_rst_n  //LCD��λ
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
//RGB565�������
assign lcd_rgb = lcd_de ? lcd_rgb_o : {24{1'bz}};

//��Ƶģ�飬���ݲ�ͬ��LCD ID�����Ӧ��Ƶ�ʵ�����ʱ��
clk_div  u_clk_div(
    .clk          (sys_clk  ),
    .rst_n        (sys_rst_n),
    .lcd_pclk     (lcd_pclk )
);


//lcd��ʾģ��
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

//lcd����ģ��
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
