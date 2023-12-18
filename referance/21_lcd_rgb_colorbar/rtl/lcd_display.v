//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                               
//----------------------------------------------------------------------------------------
// File name:           lcd_display
// Last modified Date:  2019/8/07 10:41:06
// Last Version:        V1.0
// Descriptions:        LCD��ʾģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/8/07 10:41:06
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module lcd_display(
    input                lcd_pclk,    //ʱ��
    input                rst_n,       //��λ���͵�ƽ��Ч
    input        [10:0]  pixel_xpos,  //��ǰ���ص������
    input        [10:0]  pixel_ypos,  //��ǰ���ص�������  
    input        [10:0]  h_disp,      //LCD��ˮƽ�ֱ���
    input        [10:0]  v_disp,      //LCD����ֱ�ֱ���       
    output  reg  [23:0]  pixel_data   //��������
    );

//parameter define  
parameter WHITE = 24'hFFFFFF;  //��ɫ
parameter BLACK = 24'h000000;  //��ɫ
parameter RED   = 24'hFF0000;  //��ɫ
parameter GREEN = 24'h00FF00;  //��ɫ
parameter BLUE  = 24'h0000FF;  //��ɫ

//*****************************************************
//**                    main code
//*****************************************************

//���ݵ�ǰ���ص�����ָ����ǰ���ص���ɫ���ݣ�����Ļ����ʾ����
always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        pixel_data <= BLACK;
    else begin
        if((pixel_xpos >= 11'd0) && (pixel_xpos < h_disp/5*1))
            pixel_data <= WHITE;
        else if((pixel_xpos >= h_disp/5*1) && (pixel_xpos < h_disp/5*2))    
            pixel_data <= BLACK;
        else if((pixel_xpos >= h_disp/5*2) && (pixel_xpos < h_disp/5*3))    
            pixel_data <= RED;   
        else if((pixel_xpos >= h_disp/5*3) && (pixel_xpos < h_disp/5*4))    
            pixel_data <= GREEN;                
        else
            pixel_data <= BLUE; 
    end    
end
  
endmodule
