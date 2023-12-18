module binary2bcd(
    input                       sys_clk,
    input                       sys_rst_n,
    input           [9:0]       data,           //0~999 10λ
    
    output  reg     [11:0]       bcd_data        //���ֵ�λ��
);
//parameter define
parameter   CNT_SHIFT_NUM = 5'd10;  //��data��λ�����
//reg define
reg [4:0]       cnt_shift;         //��λ�жϼ�����
reg [21:0]      data_shift;        //��λ�ж����ݼĴ�������data��bcddata��λ��֮�;�����
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
        bcd_data <= 12'd0;
    else if(cnt_shift == CNT_SHIFT_NUM + 5'b1)
        bcd_data <= data_shift[21:10];
    else
        bcd_data <= bcd_data;
end

endmodule
