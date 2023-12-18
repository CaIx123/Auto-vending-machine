//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�http://www.openedv.com/forum.php
//�Ա����̣�https://zhengdianyuanzi.tmall.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2023-2033
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           lcd_rgb_char
// Created by:          ����ԭ��
// Created date:        2023��5��24��14:17:02
// Version:             V1.0
// Descriptions:        RGB LCD����ģ��
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//
module  lcd_rgb_char(
    input              sys_clk   ,
    input              sys_rst_n ,
	
	input      [31:0]  data      ,//���������ź�
	//RGB LCD�ӿ� 
    output             lcd_hs    , //LCD ��ͬ���ź�
    output             lcd_vs    , //LCD ��ͬ���ź�
    output             lcd_de    , //LCD ��������ʹ��
    inout      [23:0]  lcd_rgb   , //LCD RGB��ɫ����
    output             lcd_bl    , //LCD ��������ź�
    output             lcd_clk   , //LCD ����ʱ��
    output             lcd_rst_n,  //LCD��λ
    output     [15:0]  lcd_id
);

//wire define
wire  [10:0]  pixel_xpos_w ;
wire  [10:0]  pixel_ypos_w ;
wire  [23:0]  pixel_data_w ;
wire  [23:0]  lcd_rgb_o    ;
wire          lcd_pclk     ;
wire  [15:0]  bcd_data_x ;
wire  [15:0]  bcd_data_y ;

//*****************************************************
//**                    main code
//*****************************************************

//RGB565�������
assign lcd_rgb = lcd_de ? lcd_rgb_o : {24{1'bz}};

//��rgb lcd ID ģ��
rd_id    u_rd_id(
    .clk          (sys_clk  ),
    .rst_n        (sys_rst_n),

    .lcd_rgb      (lcd_rgb  ),
    .lcd_id       (lcd_id   )
);

//��Ƶģ�飬���ݲ�ͬ��LCD ID�����Ӧ��Ƶ�ʵ�����ʱ��
clk_div  u_clk_div(
    .clk          (sys_clk  ),
    .rst_n        (sys_rst_n),

    .lcd_id       (lcd_id   ),
    .lcd_pclk     (lcd_pclk )
);

    
//������תBCD��X��
binary2bcd u_binary2bcd_x(
    .sys_clk         (sys_clk),
    .sys_rst_n       (sys_rst_n),
    .data            (data[31:16]),

    .bcd_data        (bcd_data_x)    
);

//������תBCD��Y��
binary2bcd u_binary2bcd_y(
    .sys_clk         (sys_clk),
    .sys_rst_n       (sys_rst_n),
    .data            (data[15:0]),

    .bcd_data        (bcd_data_y)    
); 

//lcd��ʾģ��
lcd_display  u_lcd_display(          
    .lcd_pclk       (lcd_pclk    ),
    .sys_rst_n      (sys_rst_n   ),
    .data           ({bcd_data_x,bcd_data_y}),
    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w)
);

//lcd����ģ��
lcd_driver  u_lcd_driver(
    .lcd_pclk       (lcd_pclk    ),
    .rst_n          (sys_rst_n   ),

    .lcd_id         (lcd_id      ),

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
