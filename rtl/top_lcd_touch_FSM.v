module top_lcd_touch_FSM(
    //时钟和复位接口
    input            sys_clk    ,  //系统时钟信号
    input            sys_rst_n  ,  //系统复位信号
    //TOUCH 接口                  
    inout            touch_sda  ,  //TOUCH IIC数据
    output           touch_scl  ,  //TOUCH IIC时钟
    inout            touch_int  ,  //TOUCH INT信号
    output           touch_rst_n,  //TOUCH 复位信号
    // output           touch_puse ,  //触摸成功脉冲
    //RGB LCD接口                 
    output           lcd_de     ,  //LCD 数据使能信号
    output           lcd_hs     ,  //LCD 行同步信号
    output           lcd_vs     ,  //LCD 场同步信号
    output           lcd_bl     ,  //LCD 背光控制信号
    output           lcd_clk    ,  //LCD 像素时钟
    output           lcd_rst_n  ,  //LCD 复位
    inout    [23:0]  lcd_rgb    ,  //LCD RGB颜色数据
    output    led
);

//wire define
wire    [31:0]  data            ;       //触摸点坐标
wire    touch_valid             ;       //触摸成功信号
wire    [3:0] product_number    ;
wire    [10:0] coin_val_sum     ; 
wire    nonenough_flag          ;
wire    coin_ov_flag            ;
wire    if_pay_flag            ;
wire    if_coin_flag            ;
wire    if_charge_flag            ;
assign  led = touch_valid       ;
//*****************************************************
//**                    main code
//*****************************************************                                       

//触摸驱动顶层模块    
touch_top  u_touch_top(
    .clk            (sys_clk    ),
    .rst_n          (sys_rst_n  ),

    .touch_rst_n    (touch_rst_n),
    .touch_int      (touch_int  ),
    .touch_scl      (touch_scl  ),
    .touch_sda      (touch_sda  ),

    .touch_valid     (touch_valid ),
    .data           (data       )
);
      
//例化LCD显示模块
lcd_rgb_char  u_lcd_rgb_char
(
    .sys_clk        (sys_clk        ),
    .sys_rst_n      (sys_rst_n      ),
//    .data            (data     ),
    .product_number (product_number),         //商品序号
    .coin_val_sum   (coin_val_sum)  ,           //剩余金额
    .nonenough_flag (nonenough_flag),
    .coin_ov_flag   (coin_ov_flag)  ,
    .if_pay_flag    (if_pay_flag),
    .if_coin_flag   (if_coin_flag),
    .if_charge_flag (if_charge_flag),

   //RGB LCD接口 
    .lcd_hs         (lcd_hs         ),
    .lcd_vs         (lcd_vs         ),
    .lcd_de         (lcd_de         ),
    .lcd_rgb        (lcd_rgb        ),
    .lcd_bl         (lcd_bl         ),
    .lcd_rst_n      (lcd_rst_n      ),
    .lcd_clk        (lcd_clk        )
);

//自动售货机模块
FSM_top u_FSM_top
(
    .clk            (sys_clk)       ,
    .rst_n          (sys_rst_n)     ,
    .touch_valid    (touch_valid)   ,  //触摸检测脉冲
    .data           (data)          ,                  //坐标数据
    .product_number (product_number),         //商品序号
    .coin_val_sum   (coin_val_sum)  ,           //剩余金额
    .nonenough_flag (nonenough_flag),
    .coin_ov_flag   (coin_ov_flag),
    .if_pay_flag    (if_pay_flag),
    .if_coin_flag   (if_coin_flag),
    .if_charge_flag (if_charge_flag)
);

endmodule 