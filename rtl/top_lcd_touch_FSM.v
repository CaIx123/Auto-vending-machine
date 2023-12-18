module top_lcd_touch_FSM(
    //ʱ�Ӻ͸�λ�ӿ�
    input            sys_clk    ,  //ϵͳʱ���ź�
    input            sys_rst_n  ,  //ϵͳ��λ�ź�
    //TOUCH �ӿ�                  
    inout            touch_sda  ,  //TOUCH IIC����
    output           touch_scl  ,  //TOUCH IICʱ��
    inout            touch_int  ,  //TOUCH INT�ź�
    output           touch_rst_n,  //TOUCH ��λ�ź�
    // output           touch_puse ,  //�����ɹ�����
    //RGB LCD�ӿ�                 
    output           lcd_de     ,  //LCD ����ʹ���ź�
    output           lcd_hs     ,  //LCD ��ͬ���ź�
    output           lcd_vs     ,  //LCD ��ͬ���ź�
    output           lcd_bl     ,  //LCD ��������ź�
    output           lcd_clk    ,  //LCD ����ʱ��
    output           lcd_rst_n  ,  //LCD ��λ
    inout    [23:0]  lcd_rgb    ,  //LCD RGB��ɫ����
    output    led
);

//wire define
wire    [31:0]  data            ;       //����������
wire    touch_valid             ;       //�����ɹ��ź�
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

//������������ģ��    
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
      
//����LCD��ʾģ��
lcd_rgb_char  u_lcd_rgb_char
(
    .sys_clk        (sys_clk        ),
    .sys_rst_n      (sys_rst_n      ),
//    .data            (data     ),
    .product_number (product_number),         //��Ʒ���
    .coin_val_sum   (coin_val_sum)  ,           //ʣ����
    .nonenough_flag (nonenough_flag),
    .coin_ov_flag   (coin_ov_flag)  ,
    .if_pay_flag    (if_pay_flag),
    .if_coin_flag   (if_coin_flag),
    .if_charge_flag (if_charge_flag),

   //RGB LCD�ӿ� 
    .lcd_hs         (lcd_hs         ),
    .lcd_vs         (lcd_vs         ),
    .lcd_de         (lcd_de         ),
    .lcd_rgb        (lcd_rgb        ),
    .lcd_bl         (lcd_bl         ),
    .lcd_rst_n      (lcd_rst_n      ),
    .lcd_clk        (lcd_clk        )
);

//�Զ��ۻ���ģ��
FSM_top u_FSM_top
(
    .clk            (sys_clk)       ,
    .rst_n          (sys_rst_n)     ,
    .touch_valid    (touch_valid)   ,  //�����������
    .data           (data)          ,                  //��������
    .product_number (product_number),         //��Ʒ���
    .coin_val_sum   (coin_val_sum)  ,           //ʣ����
    .nonenough_flag (nonenough_flag),
    .coin_ov_flag   (coin_ov_flag),
    .if_pay_flag    (if_pay_flag),
    .if_coin_flag   (if_coin_flag),
    .if_charge_flag (if_charge_flag)
);

endmodule 