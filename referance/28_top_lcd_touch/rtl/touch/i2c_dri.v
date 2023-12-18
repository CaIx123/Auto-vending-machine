//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�http://www.openedv.com/forum.php
//�Ա����̣�https://zhengdianyuanzi.tmall.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2023-2033
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           i2c_dri
// Created by:          ����ԭ��
// Created date:        2023��5��24��14:17:02
// Version:             V1.0
// Descriptions:        I2C����ģ��,֧��������д
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//
module i2c_dri
  #(
    parameter   CLK_FREQ   = 26'd50_000_000, //i2c_driģ�������ʱ��Ƶ��(CLK_FREQ)
    parameter   I2C_FREQ   = 18'd250_000   , //I2C��SCLʱ��Ƶ��
    parameter   WIDTH      =  4'd8           //һ�ζ�д�Ĵ����ĸ�����λ��
   )(
    input               clk           ,  //i2c_driģ�������ʱ��(CLK_FREQ)
    input               rst_n         ,  //��λ�ź�
    //i2c interface                   
    input        [6:0]  slave_addr    ,  //������ַ
    input               i2c_exec      ,  //I2C����ִ���ź�
    input               i2c_rh_wl     ,  //I2C��д�����ź�
    input        [15:0] i2c_addr      ,  //I2C�����ڵ�ַ
    input        [7:0]  i2c_data_w    ,  //I2CҪд������
    input               bit_ctrl      ,  //�ֵ�ַλ����(0:8b,1:16b)
    input   [WIDTH-1:0] reg_num       ,  //һ�ζ�д�Ĵ����ĸ���
    output  reg  [7:0]  i2c_data_r    ,  //I2C����������
    output  reg         i2c_done      ,  //I2C�������
    output  reg         once_byte_done,  //һ�ֽ����ݶ�/д�������
    output  reg         scl           ,  //I2C��SCLʱ���ź�
    output  reg         ack           ,  //Ӧ���־
    inout               sda           ,  //I2C��SDA�ź�  hong
    //user interface                  
    output  reg         dri_clk          //����I2C����������ʱ��
     );

//localparam define
localparam  st_idle     = 8'b0000_0001; //����״̬
localparam  st_sladdr   = 8'b0000_0010; //����������ַ(slave address)
localparam  st_addr16   = 8'b0000_0100; //����16λ�ֵ�ַ
localparam  st_addr8    = 8'b0000_1000; //����8λ�ֵ�ַ
localparam  st_data_wr  = 8'b0001_0000; //д����(8 bit)
localparam  st_addr_rd  = 8'b0010_0000; //����������ַ��
localparam  st_data_rd  = 8'b0100_0000; //������(8 bit)
localparam  st_stop     = 8'b1000_0000; //����I2C����

//reg define
reg                      sda_dir     ; //I2C����(SDA)�������
reg                      sda_out     ; //SDA����ź�
reg                      st_done     ; //״̬����
reg                      wr_flag     ; //д��־

reg    [ 6:0]            cnt         ; //����
reg    [ 7:0]            cur_state   ; //״̬����ǰ״̬
reg    [ 7:0]            next_state  ; //״̬����һ״̬
reg    [15:0]            addr_t      ; //��ַ
reg    [ 7:0]            data_r      ; //��ȡ������
reg    [ 7:0]            data_wr_t   ; //I2C��д�����ݵ���ʱ�Ĵ�
reg    [ 9:0]            clk_cnt     ; //��Ƶʱ�Ӽ���
reg    [WIDTH-1'b1:0]    reg_cnt     ; //һ�ζ�д�Ĵ����ĸ����ļ�����

//wire define
wire                     sda_in      ; //SDA��������
wire   [8:0]             clk_divide  ; //ģ������ʱ�ӵķ�Ƶϵ��
wire                     reg_done    ; //���Ĵ�����ɣ�0����������1�����Ĵ�����ɣ�

//*****************************************************
//**                    main code  
//*****************************************************
//SDA����
assign  sda        = sda_dir ?  sda_out : 1'bz;        //SDA������������
assign  sda_in     = sda ;
assign  clk_divide = (CLK_FREQ/I2C_FREQ) >> 2'd2;

//��������������յ�һ�ζ�д�Ĵ����ĸ�����ȣ�������д�Ĵ������
assign  reg_done   = reg_cnt == reg_num ? 1'b1 : 1'b0; 

//����I2C��SCL���ı�Ƶ�ʵ�����ʱ����������i2c�Ĳ���
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        dri_clk <=  1'b1;
        clk_cnt <= 10'd0;
    end
    else if(clk_cnt == clk_divide - 1'd1) begin
        clk_cnt <= 10'd0;
        dri_clk <= ~dri_clk;
    end
    else
        clk_cnt <= clk_cnt + 1'b1;
end

//������д�Ĵ����ĸ�������
always @(posedge dri_clk or negedge rst_n) begin
    if(!rst_n)
        reg_cnt <= 8'd0;
    else if(once_byte_done)
        reg_cnt <= reg_cnt + 1'd1;
    else if(i2c_done)
        reg_cnt <=8 'd0;
end

//(����ʽ״̬��)ͬ��ʱ������״̬ת��
always @(posedge dri_clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cur_state <= st_idle;
    else
        cur_state <= next_state;
end

//����߼��ж�״̬ת������
always @( * ) begin
    case(cur_state)
        st_idle: begin                            //����״̬
           if(i2c_exec) begin
               next_state = st_sladdr;
           end
           else
               next_state = st_idle;
        end
        st_sladdr: begin
            if(st_done) begin
                if(!ack) begin
                    if(bit_ctrl)                  //�ж���16λ����8λ�ֵ�ַ
                        next_state = st_addr16;
                    else
                        next_state = st_addr8 ;
                end
                else 
                    next_state = st_stop;    
            end
            else
                next_state = st_sladdr;
        end
        st_addr16: begin                          //д16λ�ֵ�ַ
            if(st_done) begin
                if(!ack) 
                    next_state = st_addr8;
                else 
                    next_state = st_stop;   
            end
            else
                next_state = st_addr16;
        end
        st_addr8: begin                           //8λ�ֵ�ַ
            if(st_done) begin
                if(!ack) begin
                    if(wr_flag==1'b0)             //��д�ж�
                        next_state = st_data_wr;
                    else
                        next_state = st_addr_rd;
                end
                else 
                    next_state = st_stop;   
            end
            else
                next_state = st_addr8;
        end
        st_data_wr: begin                          //д����(8 bit)
            if(st_done) begin
                if(reg_done)
                    next_state = st_stop;
                else
                    next_state = st_data_wr;
            end
            else
                next_state = st_data_wr;
        end
        st_addr_rd: begin                          //д��ַ�Խ��ж�����
            if(st_done) begin
                if(!ack)
                    next_state = st_data_rd;
                else
                    next_state = st_stop;
            end
            else
                next_state = st_addr_rd;
        end
        st_data_rd: begin                          //��ȡ����(8 bit)
            if(st_done) begin
                if(reg_done)
                    next_state = st_stop;
                else
                    next_state = st_data_rd;
            end
            else
                next_state = st_data_rd;
        end
        st_stop: begin                             //����I2C����
            if(st_done)
                next_state = st_idle;
            else
                next_state = st_stop ;
        end
        default: next_state= st_idle;
    endcase
end

//ʱ���·����״̬���
always @(posedge dri_clk or negedge rst_n) begin
    //��λ��ʼ��
    if(rst_n == 1'b0) begin
        scl             <= 1'b1;
        sda_out         <= 1'b1;
        sda_dir         <= 1'b1;
        i2c_done        <= 1'b0;
        ack             <= 1'b0;
        cnt             <= 1'b0;
        st_done         <= 1'b0;
        once_byte_done  <= 1'b0;
        data_r          <= 1'b0;
        i2c_data_r      <= 1'b0;
        wr_flag         <= 1'b0;
        addr_t          <= 1'b0;
        data_wr_t       <= 1'b0;
    end
    else begin
        st_done        <= 1'b0 ;
        once_byte_done <= 1'b0;
        cnt            <= cnt +1'b1 ;
        case(cur_state)
             st_idle: begin                          //����״̬
                scl     <= 1'b1;
                sda_out <= 1'b1;
                sda_dir <= 1'b1;
                i2c_done<= 1'b0;
                cnt     <= 7'b0;
                if(i2c_exec) begin
                    wr_flag   <= i2c_rh_wl ;
                    addr_t    <= i2c_addr  ;
                    data_wr_t <= i2c_data_w;
                end
            end
            st_sladdr: begin                         //д��ַ(������ַ���ֵ�ַ)
                case(cnt)
                    7'd1 : begin
                        sda_dir <= 1'b1 ;
                        sda_out <= 1'b0;             //��ʼI2C
                    end
                    7'd3 : scl <= 1'b0;
                    7'd4 : sda_out <= slave_addr[6]; //����������ַ
                    7'd5 : scl <= 1'b1;
                    7'd7 : scl <= 1'b0;
                    7'd8 : sda_out <= slave_addr[5];
                    7'd9 : scl <= 1'b1;
                    7'd11: scl <= 1'b0;
                    7'd12: sda_out <= slave_addr[4];
                    7'd13: scl <= 1'b1;
                    7'd15: scl <= 1'b0;
                    7'd16: sda_out <= slave_addr[3];
                    7'd17: scl <= 1'b1;
                    7'd19: scl <= 1'b0;
                    7'd20: sda_out <= slave_addr[2];
                    7'd21: scl <= 1'b1;
                    7'd23: scl <= 1'b0;
                    7'd24: sda_out <= slave_addr[1];
                    7'd25: scl <= 1'b1;
                    7'd27: scl <= 1'b0;
                    7'd28: sda_out <= slave_addr[0];
                    7'd29: scl <= 1'b1;
                    7'd31: scl <= 1'b0;
                    7'd32: sda_out <= 1'b0;              //0:д
                    7'd33: scl <= 1'b1;
                    7'd35: scl <= 1'b0;
                    7'd36: begin
                        sda_dir <= 1'b0;                 //�ӻ�Ӧ��
                        sda_out <= 1'b1;
                    end
                    7'd37: begin 
                        scl <= 1'b1; 
                        ack <= sda_in;
                    end
                    7'd42: st_done <= 1'b1;
                    7'd43: begin //7'd39
                        scl <= 1'b0;
                        cnt <= 1'b0;
                    end
                    default :  ;
                endcase
            end
            st_addr16: begin
                case(cnt)
                    7'd0 : begin
                        sda_dir <= 1'b1 ;
                        sda_out <= addr_t[15];           //�����ֵ�ַ
                    end
                    7'd1 : scl <= 1'b1;
                    7'd3 : scl <= 1'b0;
                    7'd4 : sda_out <= addr_t[14];
                    7'd5 : scl <= 1'b1;
                    7'd7 : scl <= 1'b0;
                    7'd8 : sda_out <= addr_t[13];
                    7'd9 : scl <= 1'b1;
                    7'd11: scl <= 1'b0;
                    7'd12: sda_out <= addr_t[12];
                    7'd13: scl <= 1'b1;
                    7'd15: scl <= 1'b0;
                    7'd16: sda_out <= addr_t[11];
                    7'd17: scl <= 1'b1;
                    7'd19: scl <= 1'b0;
                    7'd20: sda_out <= addr_t[10];
                    7'd21: scl <= 1'b1;
                    7'd23: scl <= 1'b0;
                    7'd24: sda_out <= addr_t[9];
                    7'd25: scl <= 1'b1;
                    7'd27: scl <= 1'b0;
                    7'd28: sda_out <= addr_t[8];
                    7'd29: scl <= 1'b1;
                    7'd31: scl <= 1'b0;
                    7'd32: begin
                        sda_dir <= 1'b0;                 //�ӻ�Ӧ��
                        sda_out <= 1'b1;
                    end
                    7'd33:  begin 
                        scl <= 1'b1; 
                        ack <= sda_in;
                    end
                    7'd38: st_done <= 1'b1;
                    7'd39: begin //7'd35
                        scl <= 1'b0;
                        cnt <= 1'b0;
                    end
                    default :  ;
                endcase
            end
            st_addr8: begin
                case(cnt)
                    7'd0: begin
                       sda_dir <= 1'b1 ;
                       sda_out <= addr_t[7];            //�ֵ�ַ
                    end
                    7'd1 : scl <= 1'b1;
                    7'd3 : scl <= 1'b0;
                    7'd4 : sda_out <= addr_t[6];
                    7'd5 : scl <= 1'b1;
                    7'd7 : scl <= 1'b0;
                    7'd8 : sda_out <= addr_t[5];
                    7'd9 : scl <= 1'b1;
                    7'd11: scl <= 1'b0;
                    7'd12: sda_out <= addr_t[4];
                    7'd13: scl <= 1'b1;
                    7'd15: scl <= 1'b0;
                    7'd16: sda_out <= addr_t[3];
                    7'd17: scl <= 1'b1;
                    7'd19: scl <= 1'b0;
                    7'd20: sda_out <= addr_t[2];
                    7'd21: scl <= 1'b1;
                    7'd23: scl <= 1'b0;
                    7'd24: sda_out <= addr_t[1];
                    7'd25: scl <= 1'b1;
                    7'd27: scl <= 1'b0;
                    7'd28: sda_out <= addr_t[0];
                    7'd29: scl <= 1'b1;
                    7'd31: scl <= 1'b0;
                    7'd32: begin
                        sda_dir <= 1'b0;                //�ӻ�Ӧ��
                        sda_out <= 1'b1;
                    end
                    7'd33:  begin 
                        scl <= 1'b1; 
                        ack <= sda_in;
                    end
                    7'd38: st_done <= 1'b1;
                    7'd39: begin //7'd35
                        scl <= 1'b0;
                        cnt <= 1'b0;
                    end
                    default :  ;
                endcase
            end
            st_data_wr: begin                            //д����(8 bit)
                case(cnt)
                    7'd0: begin
                        sda_out <= i2c_data_w[7];        //I2Cд8λ����
                        data_wr_t <= i2c_data_w;
                        sda_dir <= 1'b1;
                    end
                    7'd1 : scl <= 1'b1;
                    7'd3 : scl <= 1'b0;
                    7'd4 : sda_out <= data_wr_t[6];
                    7'd5 : scl <= 1'b1;
                    7'd7 : scl <= 1'b0;
                    7'd8 : sda_out <= data_wr_t[5];
                    7'd9 : scl <= 1'b1;
                    7'd11: scl <= 1'b0;
                    7'd12: sda_out <= data_wr_t[4];
                    7'd13: scl <= 1'b1;
                    7'd15: scl <= 1'b0;
                    7'd16: sda_out <= data_wr_t[3];
                    7'd17: scl <= 1'b1;
                    7'd19: scl <= 1'b0;
                    7'd20: sda_out <= data_wr_t[2];
                    7'd21: scl <= 1'b1;
                    7'd23: scl <= 1'b0;
                    7'd24: sda_out <= data_wr_t[1];
                    7'd25: scl <= 1'b1;
                    7'd27: scl <= 1'b0;
                    7'd28: sda_out <= data_wr_t[0];
                    7'd29: scl <= 1'b1;
                    7'd31: scl <= 1'b0;
                    7'd32: begin
                        sda_dir        <= 1'b0;          //�ӻ�Ӧ��
                        sda_out        <= 1'b1;
                        once_byte_done <= 1'b1;
                    end
                    7'd33:  begin 
                        scl <= 1'b1; 
                        ack <= sda_in;
                    end
                    7'd38: st_done <= 1'b1;
                    7'd39: begin //7'd35
                        scl  <= 1'b0;
                        cnt  <= 1'b0;
                    end
                    default  :  ;
                endcase
            end
            st_addr_rd: begin                           //д��ַ�Խ��ж�����
                case(cnt)
                    7'd0 : begin
                        sda_dir <= 1'b1;
                        sda_out <= 1'b1;
                    end
                    7'd1 : scl <= 1'b1;
                    7'd2 : sda_out <= 1'b0;             //���¿�ʼ
                    7'd3 : scl <= 1'b0;
                    7'd4 : sda_out <= slave_addr[6];    //����������ַ
                    7'd5 : scl <= 1'b1;
                    7'd7 : scl <= 1'b0;
                    7'd8 : sda_out <= slave_addr[5];
                    7'd9 : scl <= 1'b1;
                    7'd11: scl <= 1'b0;
                    7'd12: sda_out <= slave_addr[4];
                    7'd13: scl <= 1'b1;
                    7'd15: scl <= 1'b0;
                    7'd16: sda_out <= slave_addr[3];
                    7'd17: scl <= 1'b1;
                    7'd19: scl <= 1'b0;
                    7'd20: sda_out <= slave_addr[2];
                    7'd21: scl <= 1'b1;
                    7'd23: scl <= 1'b0;
                    7'd24: sda_out <= slave_addr[1];
                    7'd25: scl <= 1'b1;
                    7'd27: scl <= 1'b0;
                    7'd28: sda_out <= slave_addr[0];
                    7'd29: scl <= 1'b1;
                    7'd31: scl <= 1'b0;
                    7'd32: sda_out <= 1'b1;             //1:��
                    7'd33: scl <= 1'b1;
                    7'd35: scl <= 1'b0;
                    7'd36: begin
                        sda_dir <= 1'b0;                //�ӻ�Ӧ��
                        sda_out <= 1'b1;
                    end
                    7'd37:  begin 
                        scl <= 1'b1; 
                        ack <= sda_in;
                    end
                    7'd42: st_done <= 1'b1;
                    7'd43: begin //7'd39
                        scl <= 1'b0;
                        cnt <= 1'b0;
                    end
                    default : ;
                endcase
            end
            st_data_rd: begin                          //��ȡ����(8 bit)
                case(cnt)
                    7'd0: sda_dir <= 1'b0;
                    7'd1: begin
                        data_r[7] <= sda_in;
                        scl       <= 1'b1;
                    end
                    7'd3: scl  <= 1'b0;
                    7'd5: begin
                        data_r[6] <= sda_in ;
                        scl       <= 1'b1   ;
                    end
                    7'd7: scl  <= 1'b0;
                    7'd9: begin
                        data_r[5] <= sda_in;
                        scl       <= 1'b1  ;
                    end
                    7'd11: scl  <= 1'b0;
                    7'd13: begin
                        data_r[4] <= sda_in;
                        scl       <= 1'b1  ;
                    end
                    7'd15: scl  <= 1'b0;
                    7'd17: begin
                        data_r[3] <= sda_in;
                        scl       <= 1'b1  ;
                    end
                    7'd19: scl  <= 1'b0;
                    7'd21: begin
                        data_r[2] <= sda_in;
                        scl       <= 1'b1  ;
                    end
                    7'd23: scl  <= 1'b0;
                    7'd25: begin
                        data_r[1] <= sda_in;
                        scl       <= 1'b1  ;
                    end
                    7'd27: scl  <= 1'b0;
                    7'd29: begin
                        data_r[0] <= sda_in;
                        scl       <= 1'b1  ;
                    end
                    7'd31: scl  <= 1'b0;
                    7'd32: begin
                        if(reg_cnt == reg_num - 1'b1) begin
                            sda_dir <= 1'b1;          //��Ӧ��
                            sda_out <= 1'b1;
                        end
                        else begin
                            sda_dir <= 1'b1;          //Ӧ��
                            sda_out <= 1'b0;
                        end
                    end
                    7'd33: begin
                        scl             <= 1'b1;
                        once_byte_done  <= 1'b1;
                        i2c_data_r      <= data_r;
                    end
                    7'd38: st_done <= 1'b1;
                    7'd39: begin  //7'd35
                        scl <= 1'b0;
                        cnt <= 1'b0;    
                    end
                    default  :  ;
                endcase
            end
            st_stop: begin                            //����I2C����
                case(cnt)
                    7'd0: begin
                        sda_dir <= 1'b1;              //����I2C
                        sda_out <= 1'b0;
                    end
                    7'd1 : scl     <= 1'b1;
                    7'd3 : sda_out <= 1'b1;
                    7'd5: st_done <= 1'b1;
                    7'd6: begin
                        cnt      <= 1'b0;
                        i2c_done <= 1'b1;             //���ϲ�ģ�鴫��I2C�����ź�
                    end
                    default  : ;
                endcase
            end
        endcase
    end
end

endmodule