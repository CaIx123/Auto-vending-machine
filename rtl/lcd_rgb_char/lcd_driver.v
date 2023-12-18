module lcd_driver(
    input                lcd_pclk,    //ʱ��
    input                rst_n,       //��λ���͵�ƽ��Ч
    input        [23:0]  pixel_data,  //��������
    output  reg  [10:0]  pixel_xpos,  //��ǰ���ص������
    output  reg  [10:0]  pixel_ypos,  //��ǰ���ص�������   
    output  reg  [10:0]  h_disp,      //LCD��ˮƽ�ֱ���
    output  reg  [10:0]  v_disp,      //LCD����ֱ�ֱ��� 
	output  reg          data_req,    //���������ź�
    //RGB LCD�ӿ�
    output  reg          lcd_de,      //LCD ����ʹ���ź�
    output               lcd_hs,      //LCD ��ͬ���ź�
    output               lcd_vs,      //LCD ��ͬ���ź�
    output               lcd_bl,      //LCD ��������ź�
    output               lcd_clk,     //LCD ����ʱ��
    output               lcd_rst,     //LCD��λ
    output       [23:0]  lcd_rgb      //LCD RGB888��ɫ����
    );

//parameter define  
// 4.3' 800*480   
parameter  H_SYNC_4384   =  11'd128;    //��ͬ��
parameter  H_BACK_4384   =  11'd88;     //����ʾ����
parameter  H_DISP_4384   =  11'd800;    //����Ч����
parameter  H_FRONT_4384  =  11'd40;     //����ʾǰ��
parameter  H_TOTAL_4384  =  11'd1056;   //��ɨ������
   
parameter  V_SYNC_4384   =  11'd2;      //��ͬ��
parameter  V_BACK_4384   =  11'd33;     //����ʾ����
parameter  V_DISP_4384   =  11'd480;    //����Ч����
parameter  V_FRONT_4384  =  11'd10;     //����ʾǰ��
parameter  V_TOTAL_4384  =  11'd525;    //��ɨ������    

//reg define
reg  [10:0] h_sync ;
reg  [10:0] h_back ;
reg  [10:0] h_total;
reg  [10:0] v_sync ;
reg  [10:0] v_back ;
reg  [10:0] v_total;
reg  [10:0] h_cnt  ;
reg  [10:0] v_cnt  ;

//*****************************************************
//**                    main code
//*****************************************************

//RGB LCD ����DEģʽʱ���г�ͬ���ź���Ҫ����
assign  lcd_hs = 1'b1;        //LCD��ͬ���ź�
assign  lcd_vs = 1'b1;        //LCD��ͬ���ź�

assign  lcd_bl = 1'b1;        //LCD��������ź�  
assign  lcd_clk = lcd_pclk;   //LCD����ʱ��
assign  lcd_rst= 1'b1;        //LCD��λ

//RGB888�������
assign lcd_rgb = lcd_de ? pixel_data : 24'd0;

//���ص�x����
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        pixel_xpos <= 11'd0;
    else if(data_req)
        pixel_xpos <= h_cnt + 2'd2 - h_sync - h_back ;
    else 
        pixel_xpos <= 11'd0;
end
   
//���ص�y����   
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        pixel_ypos <= 11'd0;
    else if(v_cnt >= (v_sync + v_back)&&v_cnt < (v_sync + v_back + v_disp))
        pixel_ypos <= v_cnt + 1'b1 - (v_sync + v_back) ;
    else 
        pixel_ypos <= 11'd0;
end

//�г�ʱ�����
always @(*) begin
    h_sync  = H_SYNC_4384; 
    h_back  = H_BACK_4384; 
    h_disp  = H_DISP_4384; 
    h_total = H_TOTAL_4384;
    v_sync  = V_SYNC_4384; 
    v_back  = V_BACK_4384; 
    v_disp  = V_DISP_4384; 
    v_total = V_TOTAL_4384;             
end
	
//����ʹ���ź�		
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)	
		lcd_de <= 1'b0;
	else
		lcd_de <= data_req;
end
				  
//�������ص���ɫ��������  
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)	
		data_req<=1'b0;
	else if((h_cnt >= h_sync + h_back - 2'd2) && (h_cnt < h_sync + h_back + h_disp - 2'd2)
             && (v_cnt >= v_sync + v_back) && (v_cnt < v_sync + v_back + v_disp))
		data_req <= 1'b1;
	else
		data_req <= 1'b0;
end
				  
//�м�����������ʱ�Ӽ���
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n) 
        h_cnt <= 11'd0;
    else begin
        if(h_cnt == h_total - 1'b1)
            h_cnt <= 11'd0;
        else
            h_cnt <= h_cnt + 1'b1;           
    end
end

//�����������м���
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n) 
        v_cnt <= 11'd0;
    else begin
        if(h_cnt == h_total - 1'b1) begin
            if(v_cnt == v_total - 1'b1)
                v_cnt <= 11'd0;
            else
                v_cnt <= v_cnt + 1'b1;    
        end
    end    
end

endmodule