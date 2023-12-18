//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�http://www.openedv.com/forum.php
//�Ա����̣�https://zhengdianyuanzi.tmall.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2023-2033
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           tb_flow_led
// Created by:          ����ԭ��
// Created date:        2023��1��31��11:12:36
// Version:             V1.0
// Descriptions:        LED����˸�����ļ�
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

`timescale 1ns / 1ns        //���浥λ/���澫��

module tb_flow_led();

//parameter define
parameter  CLK_PERIOD = 20; //ʱ������ 20ns

//reg define
reg           sys_clk;
reg           sys_rst_n;

//wire define
wire  [1:0]   led;

//�źų�ʼ��
initial begin
    sys_clk <= 1'b0;
    sys_rst_n <= 1'b0;
    #200
    sys_rst_n <= 1'b1;
end

//����ʱ��
always #(CLK_PERIOD/2) sys_clk = ~sys_clk;

//�����������
flow_led  u_flow_led(
    .sys_clk      (sys_clk),
    .sys_rst_n    (sys_rst_n),
    .led          (led)
    );

endmodule
