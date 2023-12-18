//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�http://www.openedv.com/forum.php
//�Ա����̣�https://zhengdianyuanzi.tmall.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2023-2033
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           top_lcd_touch
// Created by:          ����ԭ��
// Created date:        2023��5��24��14:17:02
// Version:             V1.0
// Descriptions:        LCD������ʵ�鶥��ģ��
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//
module top_lcd_touch(
    //ʱ�Ӻ͸�λ�ӿ�
    input            sys_clk    ,  //ϵͳʱ���ź�
    input            sys_rst_n  ,  //ϵͳ��λ�ź�
    //TOUCH �ӿ�                  
    inout            touch_sda  ,  //TOUCH IIC����
    output           touch_scl  ,  //TOUCH IICʱ��
    inout            touch_int  ,  //TOUCH INT�ź�
    output           touch_rst_n,  //TOUCH ��λ�ź�
    //RGB LCD�ӿ�                 
    output           lcd_de     ,  //LCD ����ʹ���ź�
    output           lcd_hs     ,  //LCD ��ͬ���ź�
    output           lcd_vs     ,  //LCD ��ͬ���ź�
    output           lcd_bl     ,  //LCD ��������ź�
    output           lcd_clk    ,  //LCD ����ʱ��
    output           lcd_rst_n  ,  //LCD ��λ
    inout    [23:0]  lcd_rgb       //LCD RGB��ɫ����
);

//wire define
//wire  [15:0]  lcd_id     ;      //LCD��ID
wire  [31:0]  data       ;      //����������


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
    
    .data           (data       )
);
      
//����LCD��ʾģ��
lcd_rgb_char  u_lcd_rgb_char
(
   .sys_clk         (sys_clk  ),
   .sys_rst_n       (sys_rst_n),
   .data            (data     ),
   //RGB LCD�ӿ� 
   .lcd_hs          (lcd_hs   ),
   .lcd_vs          (lcd_vs   ),
   .lcd_de          (lcd_de   ),
   .lcd_rgb         (lcd_rgb  ),
   .lcd_bl          (lcd_bl   ),
   .lcd_rst_n       (lcd_rst_n),
   .lcd_clk         (lcd_clk  )
);

endmodule 