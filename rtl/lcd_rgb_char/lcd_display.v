module lcd_display(
    input               lcd_pclk,     //ʱ��
    input               rst_n,        //��λ���͵�ƽ��Ч
    input               nonenough_flag,
    input               coin_ov_flag,
    input       [3:0]   product_number,
    input       [10:0]  coin_val_sum,
    input               if_pay_flag,
    input               if_coin_flag,
    input               if_charge_flag,

    input       [10:0]  pixel_xpos,   //���ص������
    input       [10:0]  pixel_ypos,   //���ص�������    
    output reg  [23:0]  pixel_data    //���ص�����,
);                                   
                                     
//parameter define      
//��ƷͼƬ���             
localparam PIC_WIDTH1   = 11'd90;           //ͼƬ���
localparam PIC_HEIGHT1  = 11'd110;          //ͼƬ�߶�
localparam PIC_X_START_1_1 = 11'd25;        //ͼƬ��ʼ�������
localparam PIC_Y_START_1_1 = 11'd25;        //ͼƬ��ʼ��������
localparam PIC_X_START_1_2 = 11'd215;       //ͼƬ��ʼ�������
localparam PIC_Y_START_1_2 = 11'd25;        //ͼƬ��ʼ��������
localparam PIC_X_START_1_3 = 11'd405;       //ͼƬ��ʼ�������
localparam PIC_Y_START_1_3 = 11'd25;        //ͼƬ��ʼ��������
localparam PIC_X_START_1_4 = 11'd595;       //ͼƬ��ʼ�������
localparam PIC_Y_START_1_4 = 11'd25;        //ͼƬ��ʼ��������
localparam PIC_X_START_2_1 = 11'd25;        //ͼƬ��ʼ�������
localparam PIC_Y_START_2_1 = 11'd145;       //ͼƬ��ʼ��������
localparam PIC_X_START_2_2 = 11'd215;       //ͼƬ��ʼ�������
localparam PIC_Y_START_2_2 = 11'd145;       //ͼƬ��ʼ��������
localparam PIC_X_START_2_3 = 11'd405;       //ͼƬ��ʼ�������
localparam PIC_Y_START_2_3 = 11'd145;       //ͼƬ��ʼ��������
localparam PIC_X_START_2_4 = 11'd595;       //ͼƬ��ʼ�������
localparam PIC_Y_START_2_4 = 11'd145;       //ͼƬ��ʼ��������
localparam PIC_X_START_3_1 = 11'd25;        //ͼƬ��ʼ�������
localparam PIC_Y_START_3_1 = 11'd265;       //ͼƬ��ʼ��������
localparam PIC_X_START_3_2 = 11'd215;       //ͼƬ��ʼ�������
localparam PIC_Y_START_3_2 = 11'd265;       //ͼƬ��ʼ��������
localparam PIC_X_START_3_3 = 11'd405;       //ͼƬ��ʼ�������
localparam PIC_Y_START_3_3 = 11'd265;       //ͼƬ��ʼ��������
localparam PIC_X_START_3_4 = 11'd595;       //ͼƬ��ʼ�������
localparam PIC_Y_START_3_4 = 11'd265;       //ͼƬ��ʼ��������
//�۸�����
localparam PIC_WIDTH4   = 11'd60;           //ͼƬ���
localparam PIC_HEIGHT4  = 11'd30;          //ͼƬ�߶�
localparam WORD_X_bias = 11'd90;        //ͼƬ��ʼ�������
localparam WORD_Y_bias = 11'd40;        //ͼƬ��ʼ��������
//ѡ������
localparam PIC_WIDTH5   = 11'd40;           //ͼƬ���
localparam PIC_HEIGHT5  = 11'd40;          //ͼƬ�߶�
localparam CHOI_X_bias = 11'd140;        //ͼƬ��ʼ�������
localparam CHOI_Y_bias = 11'd70;        //ͼƬ��ʼ��������
//��Ʒ���
localparam PIC_WIDTH2   = 11'd120;           //ͼƬ���
localparam PIC_HEIGHT2  = 11'd60;          //ͼƬ�߶�
localparam PIC_WIDTH3   = 11'd160;           //ͼƬ���
localparam PIC_HEIGHT3  = 11'd60;          //ͼƬ�߶�
localparam PIC_X_START_BUTT1 = 11'd20;       //ͼƬ��ʼ�������
localparam PIC_Y_START_BUTT1 = 11'd390;       //ͼƬ��ʼ��������
localparam PIC_X_START_BUTT2 = 11'd150;       //ͼƬ��ʼ�������
localparam PIC_Y_START_BUTT2 = 11'd390;       //ͼƬ��ʼ��������
localparam PIC_X_START_BUTT3 = 11'd280;       //ͼƬ��ʼ�������
localparam PIC_Y_START_BUTT3 = 11'd390;       //ͼƬ��ʼ��������
localparam PIC_X_START_BUTT4 = 11'd410;       //ͼƬ��ʼ�������
localparam PIC_Y_START_BUTT4 = 11'd390;       //ͼƬ��ʼ��������
                       
//�߿򣬱������
localparam PICT_WIDTH   = 11'd180;           //ͼƬ���
localparam PICT_HEIGH   = 11'd110;          //ͼƬ�߶�
localparam FRAM_WIDTH  = 4'd15;
//��ɫ
localparam FRAM_COLOR  = 24'hFFF100; //�߿���ɫ������ɫ        
localparam BACK_COLOR  = 24'hC8C8C8; //����ɫ����ɫ
localparam PICT_COLOR  = 24'hFFFFFF; //ͼƬ��ɫ����ɫ
localparam CHAR_COLOR  = 24'h000000; //�ַ���ɫ����ɫ
localparam CHAR_COLOR_RED  = 24'hFF0000; //�ַ���ɫ����ɫ
//��Ļ����
localparam SCREEN_WIDTH = 10'd800;
localparam SCREEN_HEIGH = 9'd480;

//�ַ����
localparam CHAR_X_START1 = 11'd590;     //�ַ���ʼ������� ��ʣ�ࡱ
localparam CHAR_Y_START1 = 11'd390;    //�ַ���ʼ��������
localparam CHAR_X_START2 = 11'd590+144;     //�ַ���ʼ������� ��Ԫ��
localparam CHAR_Y_START2 = 11'd390;    //�ַ���ʼ��������
localparam CHAR_X_START3 = 11'd590;     //�ַ���ʼ������� �����㡱
localparam CHAR_Y_START3 = 11'd430;    //�ַ���ʼ��������
localparam CHAR_X_START4 = 11'd690;     //�ַ���ʼ������� �����ޡ�
localparam CHAR_Y_START4 = 11'd430;    //�ַ���ʼ��������
localparam CHAR_X_START5 = 11'd320;     //�ַ���ʼ������� ���Ƿ�ȷ��?��
localparam CHAR_Y_START5 = 11'd210;    //�ַ���ʼ��������
localparam CHAR_WIDTH2  = 11'd64;     //�ַ����,2���ַ�:32*2
localparam CHAR_WIDTH4  = 11'd128;     //�ַ����,4���ַ�:32*4
localparam CHAR_WIDTH5  = 11'd160;     //�ַ����,4���ַ�:32*4
localparam CHAR_HEIGHT  = 11'd32;     //�ַ��߶�
localparam CHAR_WIDTH1  = 11'd32;     //�ַ����,1���ַ�:32*1
//������
localparam NUM_POS_X  = 11'd654;    //�ַ�������ʼ�������
localparam NUM_POS_Y  = 11'd390;    //�ַ�������ʼ��������
localparam NUM_WIDTH  = 11'd80;    //�ַ�������
localparam NUM_HEIGHT = 11'd32;     //�ַ�����߶�
//reg define
reg   [63:0]  CN1[31:0];  //�ַ����飬��ʣ�ࡱ
reg   [31:0]  CN2[31:0];  //�ַ����飬��Ԫ��
reg   [63:0]  CN3[31:0];  //�ַ����飬�����㡱
reg   [63:0]  CN4[31:0];  //�ַ����飬�����ޡ�
reg   [127+32:0]  CN5[31:0];  //�ַ����飬���Ƿ�Ͷ�ң���
reg   [127+32:0]  CN6[31:0];  //�ַ����飬���Ƿ�֧������
reg   [127+32:0]  CN7[31:0];  //�ַ����飬���Ƿ��˱ң���
reg   [17:0]  rom_addr  ;  //ROM��ַ
reg   [17:0]  rom_addrb ;  //ROM��ַ

//wire define   
wire  [10:0]  x_cnt1;       //�����������
wire  [10:0]  y_cnt1;       //�����������
wire  [10:0]  x_cnt2;       //�����������
wire  [10:0]  y_cnt2;       //�����������
wire  [10:0]  x_cnt3;       //�����������
wire  [10:0]  y_cnt3;       //�����������
wire  [10:0]  x_cnt4;       //�����������
wire  [10:0]  y_cnt4;       //�����������
wire  [10:0]  x_cnt5;       //�����������
wire  [10:0]  y_cnt5;       //�����������
wire          rom_rd_en ;  //ROM��ʹ���ź�
wire  [23:0]  rom_rd_data ;//ROM����
wire  [23:0]  rom_rd_datab ;//ROM����
wire  [9:0]   coin_val_int ;
wire  [11:0]   coin_val_int_bcd ;

reg    [511:0]  char  [10:0] ;                //�ַ�����
wire   [3:0]              data1    ;  // X�������λ��
wire   [3:0]              data2    ;  // X������ʮλ��
wire   [3:0]              data3    ;  // X�������λ��

//*****************************************************
//**                    main code
//*****************************************************
assign  x_cnt1 = pixel_xpos + 1'b1  - CHAR_X_START1;    //���ص�������ַ�������ʼ��ˮƽ����
assign  y_cnt1 = pixel_ypos - CHAR_Y_START1;            //���ص�������ַ�������ʼ�㴹ֱ����
assign  x_cnt2 = pixel_xpos + 1'b1  - CHAR_X_START2;    //���ص�������ַ�������ʼ��ˮƽ����
assign  y_cnt2 = pixel_ypos - CHAR_Y_START2;            //���ص�������ַ�������ʼ�㴹ֱ����
assign  x_cnt3 = pixel_xpos + 1'b1  - CHAR_X_START3;    //���ص�������ַ�������ʼ��ˮƽ����
assign  y_cnt3 = pixel_ypos - CHAR_Y_START3;            //���ص�������ַ�������ʼ�㴹ֱ����
assign  x_cnt4 = pixel_xpos + 1'b1  - CHAR_X_START4;    //���ص�������ַ�������ʼ��ˮƽ����
assign  y_cnt4 = pixel_ypos - CHAR_Y_START4;            //���ص�������ַ�������ʼ�㴹ֱ����
assign  x_cnt5 = pixel_xpos + 1'b1  - CHAR_X_START5; //���ص�������ַ�������ʼ��ˮƽ����
assign  y_cnt5 = pixel_ypos - CHAR_Y_START5;         //���ص�������ַ�������ʼ�㴹ֱ����
assign  rom_rd_en = 1'b1;                  //��ʹ�����ߣ���һֱ��ROM����

assign data1 = coin_val_int_bcd[3:0] ;
assign data2 = coin_val_int_bcd[7:4] ;
assign data3 = coin_val_int_bcd[11:8] ;
assign  coin_val_int = coin_val_sum >> 1;

//���ַ����鸳ֵ�����ڴ洢��ģ����
always @(posedge lcd_pclk) begin
    char[0]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h03,8'hC0,8'h06,8'h20,
                  8'h0C,8'h30,8'h18,8'h18,8'h18,8'h18,8'h18,8'h08,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,
                  8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h18,8'h08,8'h18,8'h18,
                  8'h18,8'h18,8'h0C,8'h30,8'h06,8'h20,8'h03,8'hC0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "0"
    char[1]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h80,8'h01,8'h80,
                  8'h1F,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,
                  8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,8'h01,8'h80,
                  8'h01,8'h80,8'h01,8'h80,8'h03,8'hC0,8'h1F,8'hF8,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "1"
    char[2]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h07,8'hE0,8'h08,8'h38,
                  8'h10,8'h18,8'h20,8'h0C,8'h20,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h00,8'h0C,8'h00,8'h18,8'h00,8'h18,
                  8'h00,8'h30,8'h00,8'h60,8'h00,8'hC0,8'h01,8'h80,8'h03,8'h00,8'h02,8'h00,8'h04,8'h04,8'h08,8'h04,
                  8'h10,8'h04,8'h20,8'h0C,8'h3F,8'hF8,8'h3F,8'hF8,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "2"
    char[3]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h07,8'hC0,8'h18,8'h60,
                  8'h30,8'h30,8'h30,8'h18,8'h30,8'h18,8'h30,8'h18,8'h00,8'h18,8'h00,8'h18,8'h00,8'h30,8'h00,8'h60,
                  8'h03,8'hC0,8'h00,8'h70,8'h00,8'h18,8'h00,8'h08,8'h00,8'h0C,8'h00,8'h0C,8'h30,8'h0C,8'h30,8'h0C,
                  8'h30,8'h08,8'h30,8'h18,8'h18,8'h30,8'h07,8'hC0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "3"
    char[4]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h60,8'h00,8'h60,
                  8'h00,8'hE0,8'h00,8'hE0,8'h01,8'h60,8'h01,8'h60,8'h02,8'h60,8'h04,8'h60,8'h04,8'h60,8'h08,8'h60,
                  8'h08,8'h60,8'h10,8'h60,8'h30,8'h60,8'h20,8'h60,8'h40,8'h60,8'h7F,8'hFC,8'h00,8'h60,8'h00,8'h60,
                  8'h00,8'h60,8'h00,8'h60,8'h00,8'h60,8'h03,8'hFC,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "4"
    char[5]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h0F,8'hFC,8'h0F,8'hFC,
                  8'h10,8'h00,8'h10,8'h00,8'h10,8'h00,8'h10,8'h00,8'h10,8'h00,8'h10,8'h00,8'h13,8'hE0,8'h14,8'h30,
                  8'h18,8'h18,8'h10,8'h08,8'h00,8'h0C,8'h00,8'h0C,8'h00,8'h0C,8'h00,8'h0C,8'h30,8'h0C,8'h30,8'h0C,
                  8'h20,8'h18,8'h20,8'h18,8'h18,8'h30,8'h07,8'hC0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "5"
    char[6]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h01,8'hE0,8'h06,8'h18,
                  8'h0C,8'h18,8'h08,8'h18,8'h18,8'h00,8'h10,8'h00,8'h10,8'h00,8'h30,8'h00,8'h33,8'hE0,8'h36,8'h30,
                  8'h38,8'h18,8'h38,8'h08,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h18,8'h0C,
                  8'h18,8'h08,8'h0C,8'h18,8'h0E,8'h30,8'h03,8'hE0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "6"
    char[7]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h1F,8'hFC,8'h1F,8'hFC,
                  8'h10,8'h08,8'h30,8'h10,8'h20,8'h10,8'h20,8'h20,8'h00,8'h20,8'h00,8'h40,8'h00,8'h40,8'h00,8'h40,
                  8'h00,8'h80,8'h00,8'h80,8'h01,8'h00,8'h01,8'h00,8'h01,8'h00,8'h01,8'h00,8'h03,8'h00,8'h03,8'h00,
                  8'h03,8'h00,8'h03,8'h00,8'h03,8'h00,8'h03,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "7"
    char[8]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h07,8'hE0,8'h0C,8'h30,
                  8'h18,8'h18,8'h30,8'h0C,8'h30,8'h0C,8'h30,8'h0C,8'h38,8'h0C,8'h38,8'h08,8'h1E,8'h18,8'h0F,8'h20,
                  8'h07,8'hC0,8'h18,8'hF0,8'h30,8'h78,8'h30,8'h38,8'h60,8'h1C,8'h60,8'h0C,8'h60,8'h0C,8'h60,8'h0C,
                  8'h60,8'h0C,8'h30,8'h18,8'h18,8'h30,8'h07,8'hC0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "8"
    char[9]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h07,8'hC0,8'h18,8'h20,
                  8'h30,8'h10,8'h30,8'h18,8'h60,8'h08,8'h60,8'h0C,8'h60,8'h0C,8'h60,8'h0C,8'h60,8'h0C,8'h60,8'h0C,
                  8'h70,8'h1C,8'h30,8'h2C,8'h18,8'h6C,8'h0F,8'h8C,8'h00,8'h0C,8'h00,8'h18,8'h00,8'h18,8'h00,8'h10,
                  8'h30,8'h30,8'h30,8'h60,8'h30,8'hC0,8'h0F,8'h80,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00} ; // "9"
    char[10]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                  8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                  8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                  8'h3C,8'h00,8'h7E,8'h00,8'h7E,8'h00,8'h3C,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}; // "X"
end
//���ַ����鸳ֵ�����֡�ʣ�ࡱ��ÿ�����ִ�СΪ32*32
always @(posedge lcd_pclk) begin
    CN1[0 ]  <= 64'h0000000000000000;
    CN1[1 ]  <= 64'h0000000000000000;
    CN1[2 ]  <= 64'h0001000000000010;
    CN1[3 ]  <= 64'h0003C0000003C018;
    CN1[4 ]  <= 64'h0003800000FF8018;
    CN1[5 ]  <= 64'h000780001F300018;
    CN1[6 ]  <= 64'h0006400000300018;
    CN1[7 ]  <= 64'h000C200000303318;
    CN1[8 ]  <= 64'h001810003FFFFB18;
    CN1[9 ]  <= 64'h00380C0000300318;
    CN1[10]  <= 64'h0070060000300318;
    CN1[11]  <= 64'h0060030001330318;
    CN1[12]  <= 64'h008005C001331318;
    CN1[13]  <= 64'h03FFFFF801333B18;
    CN1[14]  <= 64'h0601807C3F33C318;
    CN1[15]  <= 64'h0801801001331318;
    CN1[16]  <= 64'h3001800001331318;
    CN1[17]  <= 64'h000180C003331318;
    CN1[18]  <= 64'h07FFFFE00D331B18;
    CN1[19]  <= 64'h000180007131F318;
    CN1[20]  <= 64'h0001800020700318;
    CN1[21]  <= 64'h0021900000FC0318;
    CN1[22]  <= 64'h0071880000F30318;
    CN1[23]  <= 64'h00E1860001B1C318;
    CN1[24]  <= 64'h01C183800330E018;
    CN1[25]  <= 64'h038181C006306018;
    CN1[26]  <= 64'h060180E00C302018;
    CN1[27]  <= 64'h0C01807018300018;
    CN1[28]  <= 64'h181F8030203001F8;
    CN1[29]  <= 64'h2007000000300070;
    CN1[30]  <= 64'h0002000000300020;
    CN1[31]  <= 64'h0000000000000000;
end
//���ַ����鸳ֵ�����֡�Ԫ����ÿ�����ִ�СΪ32*32
always @(posedge lcd_pclk) begin
    CN2[0 ]  <= 32'h00000000;
    CN2[1 ]  <= 32'h00000000;
    CN2[2 ]  <= 32'h00000000;
    CN2[3 ]  <= 32'h00000080;
    CN2[4 ]  <= 32'h03FFFFC0;
    CN2[5 ]  <= 32'h00000000;
    CN2[6 ]  <= 32'h00000000;
    CN2[7 ]  <= 32'h00000000;
    CN2[8 ]  <= 32'h00000000;
    CN2[9 ]  <= 32'h00000000;
    CN2[10]  <= 32'h00000000;
    CN2[11]  <= 32'h00000030;
    CN2[12]  <= 32'h1FFFFFF8;
    CN2[13]  <= 32'h000C3000;
    CN2[14]  <= 32'h00083000;
    CN2[15]  <= 32'h00183000;
    CN2[16]  <= 32'h00183000;
    CN2[17]  <= 32'h00183000;
    CN2[18]  <= 32'h00183000;
    CN2[19]  <= 32'h00183000;
    CN2[20]  <= 32'h00303008;
    CN2[21]  <= 32'h00303008;
    CN2[22]  <= 32'h00303008;
    CN2[23]  <= 32'h00603008;
    CN2[24]  <= 32'h00603008;
    CN2[25]  <= 32'h00C03008;
    CN2[26]  <= 32'h0180301C;
    CN2[27]  <= 32'h03003FFC;
    CN2[28]  <= 32'h06001FF8;
    CN2[29]  <= 32'h18000000;
    CN2[30]  <= 32'h20000000;
    CN2[31]  <= 32'h00000000;
end
//���ַ����鸳ֵ�����֡����㡱��ÿ�����ִ�СΪ32*32
always @(posedge lcd_pclk) begin
    CN3[0 ]  <= 64'h0000000000000000;
    CN3[1 ]  <= 64'h0000000000000000;
    CN3[2 ]  <= 64'h0000001000000100;
    CN3[3 ]  <= 64'h0000003800FFFF80;
    CN3[4 ]  <= 64'h3FFFFFFC00C00100;
    CN3[5 ]  <= 64'h0000C00000C00100;
    CN3[6 ]  <= 64'h0001C00000C00100;
    CN3[7 ]  <= 64'h0001800000C00100;
    CN3[8 ]  <= 64'h0003800000C00100;
    CN3[9 ]  <= 64'h0003000000C00100;
    CN3[10]  <= 64'h0007800000C00100;
    CN3[11]  <= 64'h0007C00000C00100;
    CN3[12]  <= 64'h000D800000FFFF00;
    CN3[13]  <= 64'h001D8C0000C18100;
    CN3[14]  <= 64'h0019820000018000;
    CN3[15]  <= 64'h0031818000018000;
    CN3[16]  <= 64'h006180C000018000;
    CN3[17]  <= 64'h00C1806000818000;
    CN3[18]  <= 64'h0181807001C180C0;
    CN3[19]  <= 64'h0301803801C1FFE0;
    CN3[20]  <= 64'h0601801801818000;
    CN3[21]  <= 64'h0C01801801818000;
    CN3[22]  <= 64'h1001800803818000;
    CN3[23]  <= 64'h2001800003418000;
    CN3[24]  <= 64'h0001800006218000;
    CN3[25]  <= 64'h0001800006118000;
    CN3[26]  <= 64'h00018000040D8000;
    CN3[27]  <= 64'h000180000807F006;
    CN3[28]  <= 64'h000180001001FFF8;
    CN3[29]  <= 64'h0001800010001FF0;
    CN3[30]  <= 64'h0001000020000000;
    CN3[31]  <= 64'h0000000000000000;
end
//���ַ����鸳ֵ�����֡����ޡ���ÿ�����ִ�СΪ32*32
always @(posedge lcd_pclk) begin
    CN4[0 ]  <= 64'h0000000000000000;
    CN4[1 ]  <= 64'h0000000000000000;
    CN4[2 ]  <= 64'h0002000000000000;
    CN4[3 ]  <= 64'h0003800010220040;
    CN4[4 ]  <= 64'h000300000FF3FFE0;
    CN4[5 ]  <= 64'h0003000008630040;
    CN4[6 ]  <= 64'h0003000008630040;
    CN4[7 ]  <= 64'h0003000008430040;
    CN4[8 ]  <= 64'h0003000008430040;
    CN4[9 ]  <= 64'h0003000008C30040;
    CN4[10]  <= 64'h000300000883FFC0;
    CN4[11]  <= 64'h0003000008830040;
    CN4[12]  <= 64'h000300C008830040;
    CN4[13]  <= 64'h0003FFE008830040;
    CN4[14]  <= 64'h0003000008430040;
    CN4[15]  <= 64'h000300000843FFC0;
    CN4[16]  <= 64'h0003000008232040;
    CN4[17]  <= 64'h0003000008331020;
    CN4[18]  <= 64'h0003000008331070;
    CN4[19]  <= 64'h0003000008331060;
    CN4[20]  <= 64'h0003000008331980;
    CN4[21]  <= 64'h0003000008330B00;
    CN4[22]  <= 64'h0003000009F30C00;
    CN4[23]  <= 64'h0003000008E30600;
    CN4[24]  <= 64'h0003000008830700;
    CN4[25]  <= 64'h0003000008031B80;
    CN4[26]  <= 64'h00030000080321C0;
    CN4[27]  <= 64'h000300180803C0F8;
    CN4[28]  <= 64'h3FFFFFFC08038078;
    CN4[29]  <= 64'h0000000008010010;
    CN4[30]  <= 64'h0000000008000000;
    CN4[31]  <= 64'h0000000000000000;
end
//���ַ����鸳ֵ�����֡��Ƿ�Ͷ��?����ÿ�����ִ�СΪ32*32
always @(posedge lcd_pclk) begin
    CN5[0 ]  <= 160'h0000000000000000000000000000000000000000;
    CN5[1 ]  <= 160'h0000000000000000000000000000000000000000;
    CN5[2 ]  <= 160'h0000000000000000030000000000000000000000;
    CN5[3 ]  <= 160'h01FFFF80000000000300FF80000000F000000000;
    CN5[4 ]  <= 160'h01FFFF801FFFFFF80300FF800003FFF000000000;
    CN5[5 ]  <= 160'h018001801FFFFFF80300C1801FFFFFF800F80000;
    CN5[6 ]  <= 160'h018001800001C0000300C1801FFF800003FC0000;
    CN5[7 ]  <= 160'h01FFFF80000380000300C18000018000039E0000;
    CN5[8 ]  <= 160'h01FFFF80000780000301C1800001800007060000;
    CN5[9 ]  <= 160'h01FFFF80000F88003FF1C1800001800006060000;
    CN5[10]  <= 160'h01800180003F8E003FF181F80001800006070000;
    CN5[11]  <= 160'h01800180007B9F80030381F80001800000060000;
    CN5[12]  <= 160'h01FFFF8001F387E0030700180FFFFFF000060000;
    CN5[13]  <= 160'h01FFFF8007E381F8030300000FFFFFF0000E0000;
    CN5[14]  <= 160'h000000001F8380FC030000000E018070001C0000;
    CN5[15]  <= 160'h000000003E03803C0317FFE00E01807000380000;
    CN5[16]  <= 160'h000000001803800803F7FFE00E01807000700000;
    CN5[17]  <= 160'h3FFFFFFC0003800007F180E00E01807000600000;
    CN5[18]  <= 160'h3FFFFFFC03FFFFC07F80C0C00E01807000600000;
    CN5[19]  <= 160'h0001800003FFFFC03F00C0C00E01807000E00000;
    CN5[20]  <= 160'h00C1800003FFFFC02300C1C00E01807000C00000;
    CN5[21]  <= 160'h00C18000038001C00300E3800E01807000C00000;
    CN5[22]  <= 160'h01C1FFE0038001C0030063000E01807000000000;
    CN5[23]  <= 160'h01C1FFE0038001C0030077000E01807000000000;
    CN5[24]  <= 160'h03E18000038001C003003E000E01807000E00000;
    CN5[25]  <= 160'h03F18000038001C003003C000E0187F000E00000;
    CN5[26]  <= 160'h073D800003FFFFC003007F000E0183E000E00000;
    CN5[27]  <= 160'h0F1F800203FFFFC00301F7E00001838000E00000;
    CN5[28]  <= 160'h1E07FFFC03FFFFC01F0FC1FE0001800000000000;
    CN5[29]  <= 160'h3C01FFFC038001C01F1F007C0001800000000000;
    CN5[30]  <= 160'h18000000038001C01C0C000C0001800000000000;
    CN5[31]  <= 160'h0000000000000000000000000000000000000000;
end

//���ַ����鸳ֵ�����֡��Ƿ�֧��?����ÿ�����ִ�СΪ32*32
always @(posedge lcd_pclk) begin
    CN6[0 ]  <= 160'h0000000000000000000000000000000000000000;
    CN6[1 ]  <= 160'h0000000000000000000000000000000000000000;
    CN6[2 ]  <= 160'h0000000000000000000000000040000000000000;
    CN6[3 ]  <= 160'h01FFFF800000000000018000007001C000000000;
    CN6[4 ]  <= 160'h01FFFF801FFFFFF80001800000E0018000000000;
    CN6[5 ]  <= 160'h018001801FFFFFF80001800000E0018000F80000;
    CN6[6 ]  <= 160'h018001800001C0000001800001C0018003FC0000;
    CN6[7 ]  <= 160'h01FFFF80000380001FFFFFF801C00180039E0000;
    CN6[8 ]  <= 160'h01FFFF80000780001FFFFFF80180018007060000;
    CN6[9 ]  <= 160'h01FFFF80000F8800000180000380018006060000;
    CN6[10]  <= 160'h01800180003F8E0000018000079FFFFC06070000;
    CN6[11]  <= 160'h01800180007B9F8000018000079FFFFC00060000;
    CN6[12]  <= 160'h01FFFF8001F387E0000180000F80018000060000;
    CN6[13]  <= 160'h01FFFF8007E381F8000180000D800180000E0000;
    CN6[14]  <= 160'h000000001F8380FC03FFFF801D800180001C0000;
    CN6[15]  <= 160'h000000003E03803C03FFFF003981018000380000;
    CN6[16]  <= 160'h0000000018038008006007003183818000700000;
    CN6[17]  <= 160'h3FFFFFFC00038000007006000181C18000600000;
    CN6[18]  <= 160'h3FFFFFFC03FFFFC000300E000181C18000600000;
    CN6[19]  <= 160'h0001800003FFFFC000180C000180E18000E00000;
    CN6[20]  <= 160'h00C1800003FFFFC0001C1C000180E18000C00000;
    CN6[21]  <= 160'h00C18000038001C0000E38000180818000C00000;
    CN6[22]  <= 160'h01C1FFE0038001C0000E70000180018000000000;
    CN6[23]  <= 160'h01C1FFE0038001C00007E0000180018000000000;
    CN6[24]  <= 160'h03E18000038001C00003C0000180018000E00000;
    CN6[25]  <= 160'h03F18000038001C00007F0000180018000E00000;
    CN6[26]  <= 160'h073D800003FFFFC0001E7C000180018000E00000;
    CN6[27]  <= 160'h0F1F800203FFFFC001F81FC00180018000E00000;
    CN6[28]  <= 160'h1E07FFFC03FFFFC01FE007F801801F8000000000;
    CN6[29]  <= 160'h3C01FFFC038001C01F8000F801801F8000000000;
    CN6[30]  <= 160'h18000000038001C00800000001800E0000000000;
    CN6[31]  <= 160'h0000000000000000000000000000000000000000;
end

//���ַ����鸳ֵ�����֡��Ƿ��˱�?����ÿ�����ִ�СΪ32*32
always @(posedge lcd_pclk) begin
    CN7[0 ]  <= 160'h0000000000000000000000000000000000000000;
    CN7[1 ]  <= 160'h0000000000000000000000000000000000000000;
    CN7[2 ]  <= 160'h0000000000000000000FFFE00000000000000000;
    CN7[3 ]  <= 160'h01FFFF80000000000E0FFFE0000000F000000000;
    CN7[4 ]  <= 160'h01FFFF801FFFFFF80E0FFFE00003FFF000000000;
    CN7[5 ]  <= 160'h018001801FFFFFF8070E00601FFFFFF800F80000;
    CN7[6 ]  <= 160'h018001800001C000070E00601FFF800003FC0000;
    CN7[7 ]  <= 160'h01FFFF8000038000070FFFE000018000039E0000;
    CN7[8 ]  <= 160'h01FFFF8000078000038FFFE00001800007060000;
    CN7[9 ]  <= 160'h01FFFF80000F8800000FFFE00001800006060000;
    CN7[10]  <= 160'h01800180003F8E00000E00600001800006070000;
    CN7[11]  <= 160'h01800180007B9F80000E00600001800000060000;
    CN7[12]  <= 160'h01FFFF8001F387E0000FFFE00FFFFFF000060000;
    CN7[13]  <= 160'h01FFFF8007E381F83F0FFFE00FFFFFF0000E0000;
    CN7[14]  <= 160'h000000001F8380FC3F0FFFE00E018070001C0000;
    CN7[15]  <= 160'h000000003E03803C3F0E00200E01807000380000;
    CN7[16]  <= 160'h0000000018038008070E20700E01807000700000;
    CN7[17]  <= 160'h3FFFFFFC00038000070EF0F00E01807000600000;
    CN7[18]  <= 160'h3FFFFFFC03FFFFC0070E7DE00E01807000600000;
    CN7[19]  <= 160'h0001800003FFFFC0070E1F800E01807000E00000;
    CN7[20]  <= 160'h00C1800003FFFFC0070E0F800E01807000C00000;
    CN7[21]  <= 160'h00C18000038001C0070E23C00E01807000C00000;
    CN7[22]  <= 160'h01C1FFE0038001C0070EE1E00E01807000000000;
    CN7[23]  <= 160'h01C1FFE0038001C0070FE0F80E01807000000000;
    CN7[24]  <= 160'h03E18000038001C0071F80780E01807000E00000;
    CN7[25]  <= 160'h03F18000038001C0070E00100E0187F000E00000;
    CN7[26]  <= 160'h073D800003FFFFC00FC800000E0183E000E00000;
    CN7[27]  <= 160'h0F1F800203FFFFC01FF8000E0001838000E00000;
    CN7[28]  <= 160'h1E07FFFC03FFFFC07C7FFFFC0001800000000000;
    CN7[29]  <= 160'h3C01FFFC038001C0301FFFFC0001800000000000;
    CN7[30]  <= 160'h18000000038001C000003F800001800000000000;
    CN7[31]  <= 160'h0000000000000000000000000000000000000000;
end


//ΪLCD��ͬ��ʾ�������ͼƬ���ַ��ͱ���ɫ
always @(posedge lcd_pclk or negedge rst_n) begin
    if (!rst_n)
        pixel_data <= BACK_COLOR;
    else begin
      if(    //�߿�
              (pixel_xpos < FRAM_WIDTH) || (pixel_xpos >= SCREEN_WIDTH - FRAM_WIDTH) || 
              (pixel_ypos < FRAM_WIDTH) || (pixel_ypos >= SCREEN_HEIGH - FRAM_WIDTH))
              pixel_data <= FRAM_COLOR ;
      
      else if(    //"ʣ��"
        (pixel_xpos >= CHAR_X_START1 - 1'b1) && (pixel_xpos < CHAR_X_START1 + CHAR_WIDTH2 - 1'b1)
          && (pixel_ypos >= CHAR_Y_START1) && (pixel_ypos < CHAR_Y_START1 + CHAR_HEIGHT)
          ) begin
          if(CN1[y_cnt1][CHAR_WIDTH1 -1'b1 - x_cnt1])
              pixel_data <= CHAR_COLOR;    //��ʾ�ַ�
          else
              pixel_data <= BACK_COLOR;    //��ʾ�ַ�����ı���ɫ
      end

      else if(    //"Ԫ"
        (pixel_xpos >= CHAR_X_START2 - 1'b1) && (pixel_xpos < CHAR_X_START2 + CHAR_WIDTH1 - 1'b1)
          && (pixel_ypos >= CHAR_Y_START2) && (pixel_ypos < CHAR_Y_START2 + CHAR_HEIGHT)
          ) begin
          if(CN2[y_cnt2][CHAR_WIDTH1 -1'b1 - x_cnt2])
              pixel_data <= CHAR_COLOR;    //��ʾ�ַ�
          else
              pixel_data <= BACK_COLOR;    //��ʾ�ַ�����ı���ɫ
      end

      else if(    //"����"
        nonenough_flag && (pixel_xpos >= CHAR_X_START3 - 1'b1) && (pixel_xpos < CHAR_X_START3 + CHAR_WIDTH2 - 1'b1)
          && (pixel_ypos >= CHAR_Y_START3) && (pixel_ypos < CHAR_Y_START3 + CHAR_HEIGHT)
          ) begin
          if(CN3[y_cnt3][CHAR_WIDTH2 -1'b1 - x_cnt3])
              pixel_data <= CHAR_COLOR_RED;    //��ʾ�ַ�
          else
              pixel_data <= BACK_COLOR;    //��ʾ�ַ�����ı���ɫ
      end

      else if(    //"����"
        coin_ov_flag && (pixel_xpos >= CHAR_X_START4 - 1'b1) && (pixel_xpos < CHAR_X_START4 + CHAR_WIDTH2 - 1'b1)
          && (pixel_ypos >= CHAR_Y_START4) && (pixel_ypos < CHAR_Y_START4 + CHAR_HEIGHT)
          ) begin
          if(CN4[y_cnt4][CHAR_WIDTH2 -1'b1 - x_cnt4])
              pixel_data <= CHAR_COLOR_RED;    //��ʾ�ַ�
          else
              pixel_data <= BACK_COLOR;    //��ʾ�ַ�����ı���ɫ
      end
      //ʣ����
      else if(data3 && (pixel_xpos >= NUM_POS_X - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*1 - 1'b1)   //��λ
          && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
          if(char[data3][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1)) % 16) - 1'b1])
              pixel_data <= CHAR_COLOR;
          else
              pixel_data <= BACK_COLOR;
      end    
      else if( !(data2 == 4'd0 && data3 == 4'd0) && (pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*1 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*2 -1'b1)  //ʮλ
          && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
          if(char[data2][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1)) % 16) - 1'b1])
              pixel_data <= CHAR_COLOR;         //��ʾ�ַ�Ϊ��ɫ
          else
              pixel_data <= BACK_COLOR;          //��ʾ�ַ����򱳾�Ϊ��ɫ
      end
      else if((pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*2 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*3 - 1'b1) //��λ
          && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
          if(char[data1][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1))%16) - 1'b1])
              pixel_data <= CHAR_COLOR;
          else
              pixel_data <= BACK_COLOR;
      end
      else if(coin_val_sum[0] && (pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*3 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*4 - 1'b1) //С����
          && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
          if(char[10][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1)) % 16) - 1'b1])
              pixel_data <= CHAR_COLOR;
          else
              pixel_data <= BACK_COLOR;
      end
      else if(coin_val_sum[0] && (pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*4 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*5 - 1'b1) //��ëλ
          && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
          if(char[5][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1))%16) - 1'b1])
              pixel_data <= CHAR_COLOR;
          else
              pixel_data <= BACK_COLOR;
      end 

      else if(      //��Ʒ
              ((pixel_xpos >= PIC_X_START_1_1 - 1'b1) && (pixel_xpos < PIC_X_START_1_1 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_1) && (pixel_ypos < PIC_Y_START_1_1 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_1_2 - 1'b1) && (pixel_xpos < PIC_X_START_1_2 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_2) && (pixel_ypos < PIC_Y_START_1_2 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_1_3 - 1'b1) && (pixel_xpos < PIC_X_START_1_3 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_3) && (pixel_ypos < PIC_Y_START_1_3 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_1_4 - 1'b1) && (pixel_xpos < PIC_X_START_1_4 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_4) && (pixel_ypos < PIC_Y_START_1_4 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_2_1 - 1'b1) && (pixel_xpos < PIC_X_START_2_1 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_1) && (pixel_ypos < PIC_Y_START_2_1 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_2_2 - 1'b1) && (pixel_xpos < PIC_X_START_2_2 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_2) && (pixel_ypos < PIC_Y_START_2_2 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_2_3 - 1'b1) && (pixel_xpos < PIC_X_START_2_3 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_3) && (pixel_ypos < PIC_Y_START_2_3 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_2_4 - 1'b1) && (pixel_xpos < PIC_X_START_2_4 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_4) && (pixel_ypos < PIC_Y_START_2_4 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_3_1 - 1'b1) && (pixel_xpos < PIC_X_START_3_1 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_1) && (pixel_ypos < PIC_Y_START_3_1 + PIC_HEIGHT1)) ||
            
              ((pixel_xpos >= PIC_X_START_3_2 - 1'b1) && (pixel_xpos < PIC_X_START_3_2 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_2) && (pixel_ypos < PIC_Y_START_3_2 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_3_3 - 1'b1) && (pixel_xpos < PIC_X_START_3_3 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_3) && (pixel_ypos < PIC_Y_START_3_3 + PIC_HEIGHT1)) ||

              ((pixel_xpos >= PIC_X_START_3_4 - 1'b1) && (pixel_xpos < PIC_X_START_3_4 + PIC_WIDTH1 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_4) && (pixel_ypos < PIC_Y_START_3_4 + PIC_HEIGHT1)) 
            )
          pixel_data <= rom_rd_data ;  //��ʾͼƬ
      
      else if(      //����
              ((pixel_xpos >= PIC_X_START_BUTT1 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT1 + PIC_WIDTH2 - 1'b1) //BUTT1
            && (pixel_ypos >= PIC_Y_START_BUTT1) && (pixel_ypos < PIC_Y_START_BUTT1 + PIC_HEIGHT2)) ||

              ((pixel_xpos >= PIC_X_START_BUTT2 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT2 + PIC_WIDTH2 - 1'b1) //BUTT2
            && (pixel_ypos >= PIC_Y_START_BUTT2) && (pixel_ypos < PIC_Y_START_BUTT2 + PIC_HEIGHT2)) ||

              ((pixel_xpos >= PIC_X_START_BUTT3 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT3 + PIC_WIDTH2 - 1'b1) //BUTT3
            && (pixel_ypos >= PIC_Y_START_BUTT3) && (pixel_ypos < PIC_Y_START_BUTT3 + PIC_HEIGHT2)) ||

              ((pixel_xpos >= PIC_X_START_BUTT4 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT4+ PIC_WIDTH3 - 1'b1) //BUTT4
            && (pixel_ypos >= PIC_Y_START_BUTT4) && (pixel_ypos < PIC_Y_START_BUTT4 + PIC_HEIGHT3))
            )
            pixel_data <= rom_rd_data ;  //��ʾͼƬ

      else if(      //�۸�
              ((pixel_xpos >= PIC_X_START_1_1 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_1 + WORD_X_bias + PIC_WIDTH4 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_1 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_1 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_1_2 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_2 + WORD_X_bias + PIC_WIDTH4 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_2 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_2 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_1_3 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_3 + WORD_X_bias + PIC_WIDTH4 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_3 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_3 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_1_4 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_4 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_4 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_4 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_2_1 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_1 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_1 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_1 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_2_2 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_2 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_2 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_2 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_2_3 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_3 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_3 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_3 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_2_4 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_4 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_4 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_4 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_3_1 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_1 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_1 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_1 + WORD_Y_bias + PIC_HEIGHT4)) ||
            
              ((pixel_xpos >= PIC_X_START_3_2 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_2 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_2 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_2 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_3_3 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_3 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_3 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_3 + WORD_Y_bias + PIC_HEIGHT4)) ||

              ((pixel_xpos >= PIC_X_START_3_4 + WORD_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_4 + PIC_WIDTH4 + WORD_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_4 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_4 + WORD_Y_bias + PIC_HEIGHT4))
          ) 
          pixel_data <= rom_rd_datab ;  //��ʾͼƬ
        //��Ʒ

      else if(      //ͼƬ��϶
              ((pixel_xpos >= 11'd15 + 11'd570) && (pixel_xpos < 11'd25 + 11'd570)) || 
              ((pixel_xpos >= 11'd15 + 11'd190) && (pixel_xpos < 11'd25 + 11'd190)) || 
              ((pixel_xpos >= 11'd15 + 11'd380) && (pixel_xpos < 11'd25 + 11'd380)) || 
              ((pixel_ypos >= 11'd15 + 11'd120) && (pixel_ypos < 11'd25 + 11'd120)) || 
              ((pixel_ypos >= 11'd15 + 11'd240) && (pixel_ypos < 11'd25 + 11'd240))
              )
              pixel_data <= BACK_COLOR ;
      
      else if(      //ͼƬ����
              (pixel_xpos >= 11'd25) && (pixel_xpos < 11'd775) && 
              (pixel_ypos >= 11'd25) && (pixel_ypos < 11'd375))
              pixel_data <= PICT_COLOR ;

      else
          pixel_data <= BACK_COLOR;        //��Ļ����ɫ

      //��������-��Ʒѡ��   
      if(product_number) begin//��Ʒѡ��
        if(((pixel_xpos >= PIC_X_START_1_1 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_1 + CHOI_X_bias + PIC_WIDTH5 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_1 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_1_1 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd1)) ||

              ((pixel_xpos >= PIC_X_START_1_2 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_2 + CHOI_X_bias + PIC_WIDTH5 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_2 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_1_2 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd2)) ||

              ((pixel_xpos >= PIC_X_START_1_3 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_3 + CHOI_X_bias + PIC_WIDTH5 - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_3 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_1_3 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd3)) ||

              ((pixel_xpos >= PIC_X_START_1_4 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_1_4 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_1_4 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_1_4 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd4)) ||

              ((pixel_xpos >= PIC_X_START_2_1 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_1 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_1 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_2_1 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd5)) ||

              ((pixel_xpos >= PIC_X_START_2_2 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_2 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_2 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_2_2 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd6)) ||

              ((pixel_xpos >= PIC_X_START_2_3 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_3 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_3 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_2_3 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd7)) ||

              ((pixel_xpos >= PIC_X_START_2_4 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_2_4 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_2_4 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_2_4 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd8)) ||

              ((pixel_xpos >= PIC_X_START_3_1 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_1 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_1 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_3_1 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd9)) ||
            
              ((pixel_xpos >= PIC_X_START_3_2 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_2 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_2 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_3_2 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd10)) ||

              ((pixel_xpos >= PIC_X_START_3_3 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_3 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_3 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_3_3 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd11)) ||

              ((pixel_xpos >= PIC_X_START_3_4 + CHOI_X_bias - 1'b1) && (pixel_xpos < PIC_X_START_3_4 + PIC_WIDTH5 + CHOI_X_bias - 1'b1) 
            && (pixel_ypos >= PIC_Y_START_3_4 + CHOI_Y_bias) && (pixel_ypos < PIC_Y_START_3_4 + CHOI_Y_bias + PIC_HEIGHT5)
            && (product_number == 4'd12))
          ) 
          pixel_data <= CHAR_COLOR_RED ;  //��ʾͼƬ
      end
      //��������-����
      if(    //"�Ƿ�Ͷ�ң�"
        if_coin_flag && (pixel_xpos >= CHAR_X_START5 - 1'b1) && (pixel_xpos < CHAR_X_START5 + CHAR_WIDTH5 - 1'b1)
          && (pixel_ypos >= CHAR_Y_START5) && (pixel_ypos < CHAR_Y_START5 + CHAR_HEIGHT)
          ) begin
          if(CN5[y_cnt5][CHAR_WIDTH5 -1'b1 - x_cnt5])
              pixel_data <= CHAR_COLOR;    //��ʾ�ַ�
      end
      else if(    //"�Ƿ�֧��?"
        if_pay_flag && (pixel_xpos >= CHAR_X_START5 - 1'b1) && (pixel_xpos < CHAR_X_START5 + CHAR_WIDTH5 - 1'b1)
          && (pixel_ypos >= CHAR_Y_START5) && (pixel_ypos < CHAR_Y_START5 + CHAR_HEIGHT)
          ) begin
          if(CN6[y_cnt5][CHAR_WIDTH5 -1'b1 - x_cnt5])
              pixel_data <= CHAR_COLOR;    //��ʾ�ַ�
      end
      else if(    //"�Ƿ��˱�?"
        if_charge_flag && (pixel_xpos >= CHAR_X_START5 - 1'b1) && (pixel_xpos < CHAR_X_START5 + CHAR_WIDTH5 - 1'b1)
          && (pixel_ypos >= CHAR_Y_START5) && (pixel_ypos < CHAR_Y_START5 + CHAR_HEIGHT)
          ) begin
          if(CN7[y_cnt5][CHAR_WIDTH5 -1'b1 - x_cnt5])
              pixel_data <= CHAR_COLOR;    //��ʾ�ַ�
      end
  end
end

//���ݵ�ǰɨ���ĺ�������ΪROM��ַ��ֵ--AͼƬ
always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        rom_addr <= 18'd0;
    //����������λ��ͼƬ��ʾ����ʱ,�ۼ�ROM��ַ    
    else if(
        ((pixel_ypos >= PIC_Y_START_1_1) && (pixel_ypos < PIC_Y_START_1_1 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_1_1 - 2'd2) && (pixel_xpos < PIC_X_START_1_1 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_1_2) && (pixel_ypos < PIC_Y_START_1_2 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_1_2 - 2'd2) && (pixel_xpos < PIC_X_START_1_2 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_1_3) && (pixel_ypos < PIC_Y_START_1_3 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_1_3 - 2'd2) && (pixel_xpos < PIC_X_START_1_3 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_1_4) && (pixel_ypos < PIC_Y_START_1_4 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_1_4 - 2'd2) && (pixel_xpos < PIC_X_START_1_4 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_1) && (pixel_ypos < PIC_Y_START_2_1 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_2_1 - 2'd2) && (pixel_xpos < PIC_X_START_2_1 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_2) && (pixel_ypos < PIC_Y_START_2_2 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_2_2 - 2'd2) && (pixel_xpos < PIC_X_START_2_2 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_3) && (pixel_ypos < PIC_Y_START_2_3 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_2_3 - 2'd2) && (pixel_xpos < PIC_X_START_2_3 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_4) && (pixel_ypos < PIC_Y_START_2_4 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_2_4 - 2'd2) && (pixel_xpos < PIC_X_START_2_4 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_1) && (pixel_ypos < PIC_Y_START_3_1 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_3_1 - 2'd2) && (pixel_xpos < PIC_X_START_3_1 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_2) && (pixel_ypos < PIC_Y_START_3_2 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_3_2 - 2'd2) && (pixel_xpos < PIC_X_START_3_2 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_3) && (pixel_ypos < PIC_Y_START_3_3 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_3_3 - 2'd2) && (pixel_xpos < PIC_X_START_3_3 + PIC_WIDTH1 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_4) && (pixel_ypos < PIC_Y_START_3_4 + PIC_HEIGHT1) 
        && (pixel_xpos >= PIC_X_START_3_4 - 2'd2) && (pixel_xpos < PIC_X_START_3_4 + PIC_WIDTH1 - 2'd2)) || //BUTT1

        ((pixel_ypos >= PIC_Y_START_BUTT1) && (pixel_ypos < PIC_Y_START_BUTT1 + PIC_HEIGHT2)  
        && (pixel_xpos >= PIC_X_START_BUTT1 - 2'd2) && (pixel_xpos < PIC_X_START_BUTT1 + PIC_WIDTH2 - 2'd2)) || //BUTT2

        ((pixel_ypos >= PIC_Y_START_BUTT2) && (pixel_ypos < PIC_Y_START_BUTT2 + PIC_HEIGHT2) 
        && (pixel_xpos >= PIC_X_START_BUTT2 - 2'd2) && (pixel_xpos < PIC_X_START_BUTT2 + PIC_WIDTH2 - 2'd2)) || //BUTT3

        ((pixel_ypos >= PIC_Y_START_BUTT3) && (pixel_ypos < PIC_Y_START_BUTT3 + PIC_HEIGHT2) 
        && (pixel_xpos >= PIC_X_START_BUTT3 - 2'd2) && (pixel_xpos < PIC_X_START_BUTT3 + PIC_WIDTH2 - 2'd2)) || //BUTT4

        ((pixel_ypos >= PIC_Y_START_BUTT4) && (pixel_ypos < PIC_Y_START_BUTT4 + PIC_HEIGHT3) 
        && (pixel_xpos >= PIC_X_START_BUTT4 - 2'd2) && (pixel_xpos < PIC_X_START_BUTT4 + PIC_WIDTH3 - 2'd2))
        ) 
        rom_addr <= rom_addr + 1'b1;
    //����������λ��ͼƬ�������һ�����ص�ʱ,ROM��ַ����    
    else if((pixel_ypos >= PIC_Y_START_BUTT4 + PIC_HEIGHT3))
        rom_addr <= 18'd0;
end

//���ݵ�ǰɨ���ĺ�������ΪROM��ַ��ֵ--B����
always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        rom_addrb <= 18'd150000;
    //����������λ��ͼƬ��ʾ����ʱ,�ۼ�ROM��ַ    
    else if(
        ((pixel_ypos >= PIC_Y_START_1_1 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_1 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_1_1 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_1_1 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_1_2 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_2 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_1_2 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_1_2 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_1_3 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_3 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_1_3 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_1_3 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_1_4 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_1_4 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_1_4 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_1_4 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_1 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_1 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_2_1 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_2_1 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_2 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_2 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_2_2 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_2_2 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_3 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_3 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_2_3 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_2_3 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_2_4 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_2_4 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_2_4 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_2_4 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_1 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_1 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_3_1 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_3_1 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_2 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_2 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_3_2 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_3_2 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_3 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_3 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_3_3 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_3_3 + WORD_X_bias + PIC_WIDTH4 - 2'd2)) ||

        ((pixel_ypos >= PIC_Y_START_3_4 + WORD_Y_bias) && (pixel_ypos < PIC_Y_START_3_4 + WORD_Y_bias + PIC_HEIGHT4) 
        && (pixel_xpos >= PIC_X_START_3_4 + WORD_X_bias - 2'd2) && (pixel_xpos < PIC_X_START_3_4 + WORD_X_bias + PIC_WIDTH4 - 2'd2))
        ) 
        rom_addrb <= rom_addrb + 1'b1;
    //����������λ��ͼƬ�������һ�����ص�ʱ,ROM��ַ����    
    else if((pixel_ypos >= PIC_Y_START_3_4 + WORD_Y_bias + PIC_HEIGHT4))
        rom_addrb <= 18'd150000;
end

//ROM���洢ͼƬ
//24'd0~24'd150000-1Ϊǰ��ͼƬ
//24'd150000~24'd171600-1Ϊ�۸�
blk_mem_gen_0  u_blk_mem_gen_0 (
  .clka  (lcd_pclk),    // input wire clka
  .ena   (rom_rd_en),   // input wire ena
  .addra (rom_addr),    // input wire [17 : 0] addra
  .douta (rom_rd_data),  // output wire [23 : 0] douta
  .clkb  (lcd_pclk),    // input wire clkb
  .enb   (rom_rd_en),      // input wire enb
  .addrb (rom_addrb),  // input wire [17 : 0] addrb
  .doutb (rom_rd_datab)  // output wire [23 : 0] doutb
);

binary2bcd u_binary2bcd(
    .sys_clk         (lcd_pclk),
    .sys_rst_n       (rst_n),
    .data            (coin_val_int),
    .bcd_data        (coin_val_int_bcd)    
);

endmodule 