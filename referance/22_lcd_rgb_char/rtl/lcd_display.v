module lcd_display(
    input             lcd_pclk,     //时钟
    input             rst_n,        //复位，低电平有效

    input      [10:0] coin_val_sum,

    input      [10:0] pixel_xpos,   //像素点横坐标
    input      [10:0] pixel_ypos,   //像素点纵坐标    
    output reg [23:0] pixel_data    //像素点数据,
);                                   
                                     
//parameter define      
//商品图片相关             
localparam PIC_WIDTH1   = 11'd90;           //图片宽度
localparam PIC_HEIGHT1  = 11'd110;          //图片高度
localparam PIC_X_START_1_1 = 11'd25;        //图片起始点横坐标
localparam PIC_Y_START_1_1 = 11'd25;        //图片起始点纵坐标
localparam PIC_X_START_1_2 = 11'd215;       //图片起始点横坐标
localparam PIC_Y_START_1_2 = 11'd25;        //图片起始点纵坐标
localparam PIC_X_START_1_3 = 11'd405;       //图片起始点横坐标
localparam PIC_Y_START_1_3 = 11'd25;        //图片起始点纵坐标
localparam PIC_X_START_1_4 = 11'd595;       //图片起始点横坐标
localparam PIC_Y_START_1_4 = 11'd25;        //图片起始点纵坐标
localparam PIC_X_START_2_1 = 11'd25;        //图片起始点横坐标
localparam PIC_Y_START_2_1 = 11'd145;       //图片起始点纵坐标
localparam PIC_X_START_2_2 = 11'd215;       //图片起始点横坐标
localparam PIC_Y_START_2_2 = 11'd145;       //图片起始点纵坐标
localparam PIC_X_START_2_3 = 11'd405;       //图片起始点横坐标
localparam PIC_Y_START_2_3 = 11'd145;       //图片起始点纵坐标
localparam PIC_X_START_2_4 = 11'd595;       //图片起始点横坐标
localparam PIC_Y_START_2_4 = 11'd145;       //图片起始点纵坐标
localparam PIC_X_START_3_1 = 11'd25;        //图片起始点横坐标
localparam PIC_Y_START_3_1 = 11'd265;       //图片起始点纵坐标
localparam PIC_X_START_3_2 = 11'd215;       //图片起始点横坐标
localparam PIC_Y_START_3_2 = 11'd265;       //图片起始点纵坐标
localparam PIC_X_START_3_3 = 11'd405;       //图片起始点横坐标
localparam PIC_Y_START_3_3 = 11'd265;       //图片起始点纵坐标
localparam PIC_X_START_3_4 = 11'd595;       //图片起始点横坐标
localparam PIC_Y_START_3_4 = 11'd265;       //图片起始点纵坐标
//价格坐标
localparam PIC_WIDTH4   = 11'd60;           //图片宽度
localparam PIC_HEIGHT4  = 11'd30;          //图片高度
localparam WORD_X_bias = 11'd90;        //图片起始点横坐标
localparam WORD_Y_bias = 11'd55;        //图片起始点纵坐标

//商品相关
localparam PIC_WIDTH2   = 11'd120;           //图片宽度
localparam PIC_HEIGHT2  = 11'd60;          //图片高度
localparam PIC_WIDTH3   = 11'd160;           //图片宽度
localparam PIC_HEIGHT3  = 11'd60;          //图片高度
localparam PIC_X_START_BUTT1 = 11'd20;       //图片起始点横坐标
localparam PIC_Y_START_BUTT1 = 11'd390;       //图片起始点纵坐标
localparam PIC_X_START_BUTT2 = 11'd150;       //图片起始点横坐标
localparam PIC_Y_START_BUTT2 = 11'd390;       //图片起始点纵坐标
localparam PIC_X_START_BUTT3 = 11'd280;       //图片起始点横坐标
localparam PIC_Y_START_BUTT3 = 11'd390;       //图片起始点纵坐标
localparam PIC_X_START_BUTT4 = 11'd410;       //图片起始点横坐标
localparam PIC_Y_START_BUTT4 = 11'd390;       //图片起始点纵坐标
                       
//边框，背景相关
localparam PICT_WIDTH   = 11'd180;           //图片宽度
localparam PICT_HEIGH   = 11'd110;          //图片高度
localparam FRAM_WIDTH  = 4'd15;
//颜色
localparam FRAM_COLOR  = 24'hFFF100; //边框颜色，亮黄色        
localparam BACK_COLOR  = 24'hC8C8C8; //背景色，灰色
localparam PICT_COLOR  = 24'hFFFFFF; //图片底色，白色
localparam CHAR_COLOR  = 24'h000000; //字符颜色，黑色
localparam CHAR_COLOR_RED  = 24'hFF0000; //字符颜色，红色
//屏幕长宽
localparam SCREEN_WIDTH = 10'd800;
localparam SCREEN_HEIGH = 9'd480;

//字符相关
localparam CHAR_X_START1 = 11'd590;     //字符起始点横坐标 “剩余”
localparam CHAR_Y_START1 = 11'd390;    //字符起始点纵坐标
localparam CHAR_X_START2 = 11'd590+144;     //字符起始点横坐标 “元”
localparam CHAR_Y_START2 = 11'd390;    //字符起始点纵坐标
localparam CHAR_X_START3 = 11'd590;     //字符起始点横坐标 “不足”
localparam CHAR_Y_START3 = 11'd430;    //字符起始点纵坐标
localparam CHAR_X_START4 = 11'd690;     //字符起始点横坐标 “上限”
localparam CHAR_Y_START4 = 11'd430;    //字符起始点纵坐标
localparam CHAR_X_START5 = 11'd336;     //字符起始点横坐标 “是否确定”
localparam CHAR_Y_START5 = 11'd250;    //字符起始点纵坐标
localparam CHAR_WIDTH2  = 11'd64;     //字符宽度,2个字符:32*2
localparam CHAR_WIDTH4  = 11'd128;     //字符宽度,4个字符:32*4
localparam CHAR_HEIGHT  = 11'd32;     //字符高度
localparam CHAR_WIDTH1  = 11'd32;     //字符宽度,1个字符:32*1
//余额相关
localparam NUM_POS_X  = 11'd654;    //字符区域起始点横坐标
localparam NUM_POS_Y  = 11'd390;    //字符区域起始点纵坐标
localparam NUM_WIDTH  = 11'd80;    //字符区域宽度
localparam NUM_HEIGHT = 11'd32;     //字符区域高度
//reg define
reg   [63:0]  CN1[31:0];  //字符数组，“剩余”
reg   [31:0]  CN2[31:0];  //字符数组，“元”
reg   [63:0]  CN3[31:0];  //字符数组，“不足”
reg   [63:0]  CN4[31:0];  //字符数组，“上限”
reg   [127:0]  CN5[31:0];  //字符数组，“是否确定”
reg   [17:0]  rom_addr  ;  //ROM地址
reg   [17:0]  rom_addrb ;  //ROM地址

//wire define   
wire  [10:0]  x_cnt1;       //横坐标计数器
wire  [10:0]  y_cnt1;       //纵坐标计数器
wire  [10:0]  x_cnt2;       //横坐标计数器
wire  [10:0]  y_cnt2;       //纵坐标计数器
wire  [10:0]  x_cnt3;       //横坐标计数器
wire  [10:0]  y_cnt3;       //纵坐标计数器
wire  [10:0]  x_cnt4;       //横坐标计数器
wire  [10:0]  y_cnt4;       //纵坐标计数器
wire  [10:0]  x_cnt5;       //横坐标计数器
wire  [10:0]  y_cnt5;       //纵坐标计数器
wire          rom_rd_en ;  //ROM读使能信号
wire  [23:0]  rom_rd_data ;//ROM数据
wire  [23:0]  rom_rd_datab ;//ROM数据
wire  [9:0]   coin_val_int ;
wire  [11:0]   coin_val_int_bcd ;

reg    [511:0]  char  [10:0] ;                //字符数组
wire   [3:0]              data1    ;  // X轴坐标个位数
wire   [3:0]              data2    ;  // X轴坐标十位数
wire   [3:0]              data3    ;  // X轴坐标百位数

//*****************************************************
//**                    main code
//*****************************************************
assign  x_cnt1 = pixel_xpos + 1'b1  - CHAR_X_START1;    //像素点相对于字符区域起始点水平坐标
assign  y_cnt1 = pixel_ypos - CHAR_Y_START1;            //像素点相对于字符区域起始点垂直坐标
assign  x_cnt2 = pixel_xpos + 1'b1  - CHAR_X_START2;    //像素点相对于字符区域起始点水平坐标
assign  y_cnt2 = pixel_ypos - CHAR_Y_START2;            //像素点相对于字符区域起始点垂直坐标
assign  x_cnt3 = pixel_xpos + 1'b1  - CHAR_X_START3;    //像素点相对于字符区域起始点水平坐标
assign  y_cnt3 = pixel_ypos - CHAR_Y_START3;            //像素点相对于字符区域起始点垂直坐标
assign  x_cnt4 = pixel_xpos + 1'b1  - CHAR_X_START4;    //像素点相对于字符区域起始点水平坐标
assign  y_cnt4 = pixel_ypos - CHAR_Y_START4;            //像素点相对于字符区域起始点垂直坐标
assign  x_cnt5 = pixel_xpos + 1'b1  - CHAR_X_START5; //像素点相对于字符区域起始点水平坐标
assign  y_cnt5 = pixel_ypos - CHAR_Y_START5;         //像素点相对于字符区域起始点垂直坐标
assign  rom_rd_en = 1'b1;                  //读使能拉高，即一直读ROM数据

assign data1 = coin_val_int_bcd[3:0] ;
assign data2 = coin_val_int_bcd[7:4] ;
assign data3 = coin_val_int_bcd[11:8] ;
assign  coin_val_int = coin_val_sum >> 1;

//给字符数组赋值，用于存储字模数据
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
    char[10]  <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h7C,8'h3E,8'h18,8'h08,
                  8'h18,8'h10,8'h0C,8'h10,8'h0C,8'h20,8'h06,8'h20,8'h06,8'h40,8'h03,8'h40,8'h03,8'h80,8'h01,8'h80,
                  8'h01,8'h80,8'h01,8'h80,8'h01,8'hC0,8'h02,8'hC0,8'h02,8'h60,8'h04,8'h60,8'h04,8'h70,8'h08,8'h30,
                  8'h08,8'h30,8'h18,8'h18,8'h10,8'h1C,8'h7C,8'h3E,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}; // "X"
end
//给字符数组赋值，汉字“剩余”，每个汉字大小为32*32
always @(posedge lcd_pclk) begin
    CN1[0 ]  <= 64'h0000000000000000;
    CN1[1 ]  <= 64'h0000000000000000;
    CN1[2 ]  <= 64'h0000001000010000;
    CN1[3 ]  <= 64'h0003C0180003C000;
    CN1[4 ]  <= 64'h00FF801800038000;
    CN1[5 ]  <= 64'h1F30001800078000;
    CN1[6 ]  <= 64'h0030001800064000;
    CN1[7 ]  <= 64'h00303318000C2000;
    CN1[8 ]  <= 64'h3FFFFB1800181000;
    CN1[9 ]  <= 64'h0030031800380C00;
    CN1[10]  <= 64'h0030031800700600;
    CN1[11]  <= 64'h0133031800600300;
    CN1[12]  <= 64'h01331318008005C0;
    CN1[13]  <= 64'h01333B1803FFFFF8;
    CN1[14]  <= 64'h3F33C3180601807C;
    CN1[15]  <= 64'h0133131808018010;
    CN1[16]  <= 64'h0133131830018000;
    CN1[17]  <= 64'h03331318000180C0;
    CN1[18]  <= 64'h0D331B1807FFFFE0;
    CN1[19]  <= 64'h7131F31800018000;
    CN1[20]  <= 64'h2070031800018000;
    CN1[21]  <= 64'h00FC031800219000;
    CN1[22]  <= 64'h00F3031800718800;
    CN1[23]  <= 64'h01B1C31800E18600;
    CN1[24]  <= 64'h0330E01801C18380;
    CN1[25]  <= 64'h06306018038181C0;
    CN1[26]  <= 64'h0C302018060180E0;
    CN1[27]  <= 64'h183000180C018070;
    CN1[28]  <= 64'h203001F8181F8030;
    CN1[29]  <= 64'h0030007020070000;
    CN1[30]  <= 64'h0030002000020000;
    CN1[31]  <= 64'h0000000000000000;
end
//给字符数组赋值，汉字“元”，每个汉字大小为32*32
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
//给字符数组赋值，汉字“不足”，每个汉字大小为32*32
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
//给字符数组赋值，汉字“上限”，每个汉字大小为32*32
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
//给字符数组赋值，汉字“是否确定”，每个汉字大小为32*32
always @(posedge lcd_pclk) begin
    CN5[0 ]  <= 128'h00000000000000000000000000000000;
    CN5[1 ]  <= 128'h00000000000000000000000000000000;
    CN5[2 ]  <= 128'h00E00700000000200000200000020000;
    CN5[3 ]  <= 128'h00FFFF80000000300000380000010000;
    CN5[4 ]  <= 128'h00E007001FFFFFF80000700000018000;
    CN5[5 ]  <= 128'h00E00700000180000008608000018000;
    CN5[6 ]  <= 128'h00E00700000300003FFCFFC000008010;
    CN5[7 ]  <= 128'h00FFFF00000780000100C1C007FFFFF8;
    CN5[8 ]  <= 128'h00E00700000F80000301810004000038;
    CN5[9 ]  <= 128'h00E00700000D9000030102000C000060;
    CN5[10]  <= 128'h00E0070000198E00020302101C000040;
    CN5[11]  <= 128'h00E00700007181C00605FFF808000040;
    CN5[12]  <= 128'h00FFFF0000C180F006098618000000C0;
    CN5[13]  <= 128'h00E0070001818038040186180FFFFFE0;
    CN5[14]  <= 128'h00E00630060180180FF9861800018000;
    CN5[15]  <= 128'h000000780C0180080C31861800018000;
    CN5[16]  <= 128'h3FFFFFFC300180001C31FFF800018000;
    CN5[17]  <= 128'h1801C000008200801431861800C18000;
    CN5[18]  <= 128'h00E1C00000FFFFC02431861800C18000;
    CN5[19]  <= 128'h00F1C04000C001802431861800C18180;
    CN5[20]  <= 128'h01E1C0E000C00180443186180181FFC0;
    CN5[21]  <= 128'h01E1FFF000C001800431FFF801818000;
    CN5[22]  <= 128'h01C1C00000C001800431861801C18000;
    CN5[23]  <= 128'h03E1C00000C0018007F1061801C18000;
    CN5[24]  <= 128'h03F1C00000C001800433061803218000;
    CN5[25]  <= 128'h07BDC00000C001800423061803118000;
    CN5[26]  <= 128'h071FC00000C0018004020618060D8000;
    CN5[27]  <= 128'h0E0FE00000FFFF800406061804078000;
    CN5[28]  <= 128'h1C03FFFE00C00180000C07F80801FFF8;
    CN5[29]  <= 128'h3800FFF800C001800008043010003FF0;
    CN5[30]  <= 128'h00000000000000000000000000020000;
    CN5[31]  <= 128'h00000000000000000000000000000000;
end

//为LCD不同显示区域绘制图片、字符和背景色
always @(posedge lcd_pclk or negedge rst_n) begin
    if (!rst_n)
        pixel_data <= BACK_COLOR;
    else if(    //边框
            (pixel_xpos < FRAM_WIDTH) || (pixel_xpos >= SCREEN_WIDTH - FRAM_WIDTH) || 
            (pixel_ypos < FRAM_WIDTH) || (pixel_ypos >= SCREEN_HEIGH - FRAM_WIDTH))
            pixel_data <= FRAM_COLOR ;
    
    else if(    //"剩余"
      (pixel_xpos >= CHAR_X_START1 - 1'b1) && (pixel_xpos < CHAR_X_START1 + CHAR_WIDTH2 - 1'b1)
         && (pixel_ypos >= CHAR_Y_START1) && (pixel_ypos < CHAR_Y_START1 + CHAR_HEIGHT)
         ) begin
        if(CN1[y_cnt1][CHAR_WIDTH1 -1'b1 - x_cnt1])
            pixel_data <= CHAR_COLOR;    //显示字符
        else
            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
    end

    else if(    //"元"
      (pixel_xpos >= CHAR_X_START2 - 1'b1) && (pixel_xpos < CHAR_X_START2 + CHAR_WIDTH1 - 1'b1)
         && (pixel_ypos >= CHAR_Y_START2) && (pixel_ypos < CHAR_Y_START2 + CHAR_HEIGHT)
         ) begin
        if(CN2[y_cnt2][CHAR_WIDTH1 -1'b1 - x_cnt2])
            pixel_data <= CHAR_COLOR;    //显示字符
        else
            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
    end

    else if(    //"不足"
      (pixel_xpos >= CHAR_X_START3 - 1'b1) && (pixel_xpos < CHAR_X_START3 + CHAR_WIDTH2 - 1'b1)
         && (pixel_ypos >= CHAR_Y_START3) && (pixel_ypos < CHAR_Y_START3 + CHAR_HEIGHT)
         ) begin
        if(CN3[y_cnt3][CHAR_WIDTH2 -1'b1 - x_cnt3])
            pixel_data <= CHAR_COLOR_RED;    //显示字符
        else
            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
    end

    else if(    //"上限"
      (pixel_xpos >= CHAR_X_START4 - 1'b1) && (pixel_xpos < CHAR_X_START4 + CHAR_WIDTH2 - 1'b1)
         && (pixel_ypos >= CHAR_Y_START4) && (pixel_ypos < CHAR_Y_START4 + CHAR_HEIGHT)
         ) begin
        if(CN4[y_cnt4][CHAR_WIDTH2 -1'b1 - x_cnt4])
            pixel_data <= CHAR_COLOR_RED;    //显示字符
        else
            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
    end

    else if(    //"是否确定"
      (pixel_xpos >= CHAR_X_START5 - 1'b1) && (pixel_xpos < CHAR_X_START5 + CHAR_WIDTH4 - 1'b1)
         && (pixel_ypos >= CHAR_Y_START5) && (pixel_ypos < CHAR_Y_START5 + CHAR_HEIGHT)
         ) begin
        if(CN5[y_cnt5][CHAR_WIDTH4 -1'b1 - x_cnt5])
            pixel_data <= CHAR_COLOR;    //显示字符
        else
            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
    end
    //剩余金额
    else if((pixel_xpos >= NUM_POS_X - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*1 - 1'b1)   //百位
         && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
        if(char[data3][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1)) % 16) - 1'b1])
            pixel_data <= CHAR_COLOR;
        else
            pixel_data <= BACK_COLOR;
    end    
    else if((pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*1 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*2 -1'b1)  //十位
         && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
        if(char[data2][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1)) % 16) - 1'b1])
            pixel_data <= CHAR_COLOR;         //显示字符为黑色
        else
            pixel_data <= BACK_COLOR;          //显示字符区域背景为白色
    end
    else if((pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*2 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*3 - 1'b1) //个位
         && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
        if(char[data1][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1))%16) - 1'b1])
            pixel_data <= CHAR_COLOR;
        else
            pixel_data <= BACK_COLOR;
    end
    else if(coin_val_sum[0] && (pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*3 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*4 - 1'b1) //小数点
         && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
        if(char[10][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1)) % 16) - 1'b1])
            pixel_data <= CHAR_COLOR;
        else
            pixel_data <= BACK_COLOR;
    end
    else if(coin_val_sum[0] && (pixel_xpos >= NUM_POS_X + NUM_WIDTH/5*4 - 1'b1) && (pixel_xpos < NUM_POS_X + NUM_WIDTH/5*5 - 1'b1) //五毛位
         && (pixel_ypos >= NUM_POS_Y) && (pixel_ypos < NUM_POS_Y + NUM_HEIGHT)) begin
        if(char[5][(NUM_HEIGHT + NUM_POS_Y - pixel_ypos) * 16 - ((pixel_xpos - (NUM_POS_X -1'b1))%16) - 1'b1])
            pixel_data <= CHAR_COLOR;
        else
            pixel_data <= BACK_COLOR;
    end 

    else if(      //商品
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
        pixel_data <= rom_rd_data ;  //显示图片
    
    else if(      //按键
            ((pixel_xpos >= PIC_X_START_BUTT1 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT1 + PIC_WIDTH2 - 1'b1) //BUTT1
          && (pixel_ypos >= PIC_Y_START_BUTT1) && (pixel_ypos < PIC_Y_START_BUTT1 + PIC_HEIGHT2)) ||

            ((pixel_xpos >= PIC_X_START_BUTT2 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT2 + PIC_WIDTH2 - 1'b1) //BUTT2
          && (pixel_ypos >= PIC_Y_START_BUTT2) && (pixel_ypos < PIC_Y_START_BUTT2 + PIC_HEIGHT2)) ||

            ((pixel_xpos >= PIC_X_START_BUTT3 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT3 + PIC_WIDTH2 - 1'b1) //BUTT3
          && (pixel_ypos >= PIC_Y_START_BUTT3) && (pixel_ypos < PIC_Y_START_BUTT3 + PIC_HEIGHT2)) ||

            ((pixel_xpos >= PIC_X_START_BUTT4 - 1'b1) && (pixel_xpos < PIC_X_START_BUTT4+ PIC_WIDTH3 - 1'b1) //BUTT4
          && (pixel_ypos >= PIC_Y_START_BUTT4) && (pixel_ypos < PIC_Y_START_BUTT4 + PIC_HEIGHT3))
          )
          pixel_data <= rom_rd_data ;  //显示图片

    else if(      //价格
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
        pixel_data <= rom_rd_datab ;  //显示图片

    else if(      //图片间隙
            ((pixel_xpos >= 11'd15 + 11'd570) && (pixel_xpos < 11'd25 + 11'd570)) || 
            ((pixel_xpos >= 11'd15 + 11'd190) && (pixel_xpos < 11'd25 + 11'd190)) || 
            ((pixel_xpos >= 11'd15 + 11'd380) && (pixel_xpos < 11'd25 + 11'd380)) || 
            ((pixel_ypos >= 11'd15 + 11'd120) && (pixel_ypos < 11'd25 + 11'd120)) || 
            ((pixel_ypos >= 11'd15 + 11'd240) && (pixel_ypos < 11'd25 + 11'd240))
            )
            pixel_data <= BACK_COLOR ;
    
    else if(      //图片背景
            (pixel_xpos >= 11'd25) && (pixel_xpos < 11'd775) && 
            (pixel_ypos >= 11'd25) && (pixel_ypos < 11'd375))
            pixel_data <= PICT_COLOR ;

    else
        pixel_data <= BACK_COLOR;        //屏幕背景色
end

//根据当前扫描点的横纵坐标为ROM地址赋值--A图片
always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        rom_addr <= 18'd0;
    //当横纵坐标位于图片显示区域时,累加ROM地址    
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
    //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
    else if((pixel_ypos >= PIC_Y_START_BUTT4 + PIC_HEIGHT3))
        rom_addr <= 18'd0;
end

//根据当前扫描点的横纵坐标为ROM地址赋值--B文字
always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        rom_addrb <= 18'd150000;
    //当横纵坐标位于图片显示区域时,累加ROM地址    
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
    //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
    else if((pixel_ypos >= PIC_Y_START_3_4 + WORD_Y_bias + PIC_HEIGHT4))
        rom_addrb <= 18'd150000;
end

//ROM：存储图片
//24'd0~24'd150000-1为前面图片
//24'd150000~24'd171600-1为价格
blk_mem_gen_0  blk_mem_gen_0 (
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