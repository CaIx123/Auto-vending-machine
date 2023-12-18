//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�http://www.openedv.com/forum.php
//�Ա����̣�https://zhengdianyuanzi.tmall.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2023-2033
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           binary2bcd
// Created by:          ����ԭ��
// Created date:        2023��2��3��14:17:02
// Version:             V1.0
// Descriptions:        binary2bcd
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module binary2bcd(
    input   wire             sys_clk,
    input   wire             sys_rst_n,
    input   wire    [15:0]   data,
    
    output  reg     [15:0]   bcd_data       //���ֵ�λ��
);
//parameter define
parameter   CNT_SHIFT_NUM = 5'd16;  //��data��λ�����
//reg define
reg [4:0]       cnt_shift;         //��λ�жϼ�����
reg [31:0]      data_shift;        //��λ�ж����ݼĴ�������data��bcddata��λ��֮�;�����
reg             shift_flag;        //��λ�жϱ�־�ź�

//*****************************************************
//**                    main code                      
//*****************************************************

//cnt_shift����
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        cnt_shift <= 5'd0;
    else if((cnt_shift == CNT_SHIFT_NUM + 5'd1) && (shift_flag))
        cnt_shift <= 5'd0;
    else if(shift_flag)
        cnt_shift <= cnt_shift + 5'b1;
    else
        cnt_shift <= cnt_shift;
end

//data_shift ������Ϊ0ʱ����ֵ��������Ϊ1~CNT_SHIFT_NUMʱ������λ����
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        data_shift <= 32'd0;
    else if(cnt_shift == 5'd0)
        data_shift <= {16'b0,data};
    else if((cnt_shift <= CNT_SHIFT_NUM) && (!shift_flag))begin
        data_shift[19:16] <= (data_shift[19:16] > 4) ? (data_shift[19:16] + 2'd3):(data_shift[19:16]);
        data_shift[23:20] <= (data_shift[23:20] > 4) ? (data_shift[23:20] + 2'd3):(data_shift[23:20]);
        data_shift[27:24] <= (data_shift[27:24] > 4) ? (data_shift[27:24] + 2'd3):(data_shift[27:24]);
        data_shift[31:28] <= (data_shift[31:28] > 4) ? (data_shift[31:28] + 2'd3):(data_shift[31:28]);
        end
    else if((cnt_shift <= CNT_SHIFT_NUM) && (shift_flag))
        data_shift <= data_shift << 1;
    else
        data_shift <= data_shift;
end

//shift_flag ��λ�жϱ�־�źţ����ڿ�����λ�жϵ��Ⱥ�˳��
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        shift_flag <= 1'b0;
    else
        shift_flag <= ~shift_flag;
end

//������������CNT_SHIFT_NUMʱ����λ�жϲ�����ɣ��������
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        bcd_data <= 16'd0;
    else if(cnt_shift == CNT_SHIFT_NUM + 5'b1)
        bcd_data <= data_shift[31:16];
    else
        bcd_data <= bcd_data;
end

endmodule
