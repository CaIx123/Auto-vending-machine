module binary2bcd(
    input                       sys_clk,
    input                       sys_rst_n,
    input           [9:0]       data,           //0~999 10位
    
    output  reg     [11:0]       bcd_data        //数字的位数
);
//parameter define
parameter   CNT_SHIFT_NUM = 5'd10;  //由data的位宽决定
//reg define
reg [4:0]       cnt_shift;         //移位判断计数器
reg [21:0]      data_shift;        //移位判断数据寄存器，由data和bcddata的位宽之和决定。
reg             shift_flag;        //移位判断标志信号

//*****************************************************
//**                    main code                      
//*****************************************************

//cnt_shift计数
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

//data_shift 计数器为0时赋初值，计数器为1~CNT_SHIFT_NUM时进行移位操作
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        data_shift <= 32'd0;
    else if(cnt_shift == 5'd0)
        data_shift <= {12'b0,data};
    else if((cnt_shift <= CNT_SHIFT_NUM) && (!shift_flag))begin
        data_shift[13:10] <= (data_shift[13:10] > 4) ? (data_shift[13:10] + 2'd3):(data_shift[13:10]);
        data_shift[17:14] <= (data_shift[17:14] > 4) ? (data_shift[17:14] + 2'd3):(data_shift[17:14]);
        data_shift[21:18] <= (data_shift[21:18] > 4) ? (data_shift[21:18] + 2'd3):(data_shift[21:18]);
        // data_shift[31:28] <= (data_shift[31:28] > 4) ? (data_shift[31:28] + 2'd3):(data_shift[31:28]);
        end
    else if((cnt_shift <= CNT_SHIFT_NUM) && (shift_flag))
        data_shift <= data_shift << 1;
    else
        data_shift <= data_shift;
end

//shift_flag 移位判断标志信号，用于控制移位判断的先后顺序
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        shift_flag <= 1'b0;
    else
        shift_flag <= ~shift_flag;
end

//当计数器等于CNT_SHIFT_NUM时，移位判断操作完成，整体输出
always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        bcd_data <= 12'd0;
    else if(cnt_shift == CNT_SHIFT_NUM + 5'b1)
        bcd_data <= data_shift[21:10];
    else
        bcd_data <= bcd_data;
end

endmodule
