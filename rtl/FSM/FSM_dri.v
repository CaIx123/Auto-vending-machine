module FSM_dri (
    input rst_n,
    input clk,

    //��������
    input [31:0] data,              //��������,��16λΪX����16λΪy 20~780;
    input touch_valid,              //�����ɹ���־
    // output reg [4:0] touch_data,   //��������  0~11Ϊ��Ʒ 12Ϊȷ�� 13Ϊȡ�� 14~17ΪͶ�ҽ�� 18Ϊ�˱�

    //ȷ����ȡ���ź�
    output cancel_flag,sure_flag,
    //Ͷ���й�
    input coin_fn_flag,             //Ͷ������ź�
    output coin_sig,            //Ͷ���ź�

    //֧���й�
    input pay_st_flag,
    output nonenough_flag,            //Ǯ�����ź�
    input pay_sta_flag,

    //�˱�/�����й�
    output charge_flag,
    input charge_st_flag,            //��ʼ�����ź�
    // output charge_fn_flag,            //��������ź�
    output reg [10:0] coin_val_sum,   //��Ͷ��� ��ֵΪ0~2000 ��Ӧ0~1000r

    //ѡ����Ʒ�й�
    input selected_sta_flag,        //������ѡ��״̬�ź�
    output reg select_flag,         //ѡ���ź�
    output reg [3:0]product_number,  //ѡ����Ʒ���1~12

    output coin_ov_flag,
    input coin_sta_flag
);
    reg [4:0] coin_val;     //1:0.5r 2:1r 10:5r 20:10r
    reg [4:0] touch_data;
    wire [10:0] coin_add;
    wire touch_puse;              //�����ɹ����壬����Ϊһ��ʱ�����ڣ�
    //��ô������ݣ�480*800
    always @(data or rst_n) begin
        if(!rst_n) begin
            touch_data = 5'd0;
        end
        else if (data[31:16] >= 20 && data[31:16] < 210 && data[15:0] >= 20 && data[15:0] < 140) begin  //1:��Ʒ1
            touch_data = 5'd1;
        end
        else if (data[31:16] >= 210 && data[31:16] < 400 && data[15:0] >= 20 && data[15:0] < 140) begin  //2:��Ʒ2
            touch_data = 5'd2;
        end
        else if (data[31:16] >= 400 && data[31:16] < 590 && data[15:0] >= 20 && data[15:0] < 140) begin  //3:��Ʒ3
            touch_data = 5'd3;
        end
        else if (data[31:16] >= 590 && data[31:16] < 780 && data[15:0] >= 20 && data[15:0] < 140) begin  //4:��Ʒ4
            touch_data = 5'd4;
        end
        else if (data[31:16] >= 20 && data[31:16] < 210 && data[15:0] >= 140 && data[15:0] < 260) begin  //5:��Ʒ5
            touch_data = 5'd5;
        end
        else if (data[31:16] >= 210 && data[31:16] < 400 && data[15:0] >= 140 && data[15:0] < 260) begin  //6:��Ʒ6
            touch_data = 5'd6;
        end
        else if (data[31:16] >= 400 && data[31:16] < 590 && data[15:0] >= 140 && data[15:0] < 260) begin  //7:��Ʒ7
            touch_data = 5'd7;
        end
        else if (data[31:16] >= 590 && data[31:16] < 780 && data[15:0] >= 140 && data[15:0] < 260) begin  //8:��Ʒ8
            touch_data = 5'd8;
        end
        else if (data[31:16] >= 20 && data[31:16] < 210 && data[15:0] >= 260 && data[15:0] < 380) begin  //9:��Ʒ9
            touch_data = 5'd9;
        end
        else if (data[31:16] >= 210 && data[31:16] < 400 && data[15:0] >= 260 && data[15:0] < 380) begin  //10:��Ʒ10
            touch_data = 5'd10;
        end
        else if (data[31:16] >= 400 && data[31:16] < 590 && data[15:0] >= 260 && data[15:0] < 380) begin  //11:��Ʒ11
            touch_data = 5'd11;
        end
        else if (data[31:16] >= 590 && data[31:16] < 780 && data[15:0] >= 260 && data[15:0] < 380) begin  //12:��Ʒ12
            touch_data = 5'd12;
        end
        else if (data[31:16] >= 20 && data[31:16] < 140 && data[15:0] >= 390 && data[15:0] < 450) begin //13:ȷ��
            touch_data = 5'd13;
        end
        else if (data[31:16] >= 150 && data[31:16] < 270 && data[15:0] >= 390 && data[15:0] < 450) begin //14:ȡ��
            touch_data = 5'd14;
        end
        else if (data[31:16] >= 410 && data[31:16] < 450 && data[15:0] >= 390 && data[15:0] < 450) begin //15:0.5r
            touch_data = 5'd15;
        end
        else if (data[31:16] >= 450 && data[31:16] < 490 && data[15:0] >= 390 && data[15:0] < 450) begin //16:1r
            touch_data = 5'd16;
        end
        else if (data[31:16] >= 490 && data[31:16] < 530 && data[15:0] >= 390 && data[15:0] < 450) begin //17:5r
            touch_data = 5'd17;
        end
        else if (data[31:16] >= 530 && data[31:16] < 570 && data[15:0] >= 390 && data[15:0] < 450) begin //18:10r
            touch_data = 5'd18;
        end
        else if (data[31:16] >= 280 && data[31:16] < 400 && data[15:0] >= 390 && data[15:0] < 450) begin //19:�˱�
            touch_data = 5'd19;
        end
        else begin
            touch_data = 5'd0;
        end
    end
    //������������
    reg posedge_detect_reg0;
    reg posedge_detect_reg1;
    assign touch_puse = posedge_detect_reg0 && (!posedge_detect_reg1);
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            posedge_detect_reg0 <= 1'b0;
            posedge_detect_reg1 <= 1'b0;
        end
        else begin
            posedge_detect_reg0 <=  touch_valid;
            posedge_detect_reg1 <=  posedge_detect_reg0;
        end
    end

    //������Ʒ��Ӧ���
    localparam product1_price = 5'd4;
    localparam product2_price = 5'd8;
    localparam product3_price = 5'd10;
    localparam product4_price = 5'd7;
    localparam product5_price = 5'd5;
    localparam product6_price = 5'd12;
    localparam product7_price = 5'd5;
    localparam product8_price = 5'd9;
    localparam product9_price = 5'd10;
    localparam product10_price = 5'd8;
    localparam product11_price = 5'd10;
    localparam product12_price = 5'd2;
    reg [4:0] product_price;     //��Ʒ���
    //ѡ���־����
    always @(*) begin
        if (!rst_n || selected_sta_flag) begin
            select_flag = 1'b0;
        end
        else if (!selected_sta_flag && touch_data >= 5'd1 && touch_data <= 5'd12) begin
            select_flag = 1'b1;
        end
        else begin
            select_flag = 1'b0;
        end
    end
    //ѡ����Ʒ���������Ʒ������
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_number <= 4'b0;
            product_price <= 5'b0;
        end
        else if (selected_sta_flag && touch_data >= 5'd1 && touch_data <= 5'd12) begin
            product_number <= touch_data;
            case (touch_data)
                5'd1: product_price <= product1_price;
                5'd2: product_price <= product2_price;
                5'd3: product_price <= product3_price;
                5'd4: product_price <= product4_price;
                5'd5: product_price <= product5_price;
                5'd6: product_price <= product6_price;
                5'd7: product_price <= product7_price;
                5'd8: product_price <= product8_price;
                5'd9: product_price <= product9_price;
                5'd10: product_price <= product10_price;
                5'd11: product_price <= product11_price;
                5'd12: product_price <= product12_price;
                default: product_price <= 5'b0;
            endcase
        end
        else if(pay_st_flag && !nonenough_flag) begin
            product_number <= 4'b0;
            product_price <= 5'b0;
        end
        else if(selected_sta_flag && cancel_flag) begin
            product_number <= 4'b0;
            product_price <= 5'b0;
        end
    end
    //֧�����
    assign nonenough_flag = (coin_val_sum < product_price) && pay_sta_flag;
    assign coin_add = coin_val_sum + coin_val;
    assign coin_ov_flag = coin_sta_flag && (coin_add > 11'd1999);
    //��Ͷ�ҽ�ֵ��������
    assign coin_sig = touch_puse && (touch_data >= 5'd15 && touch_data <= 5'd18);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            coin_val_sum <= 11'b0;
        end
        else if (coin_fn_flag && coin_add <= 11'd1999) begin
            coin_val_sum <= coin_add;
        end
        else if (pay_st_flag && !nonenough_flag) begin
            coin_val_sum <= coin_val_sum - product_price;
        end
        else if (charge_st_flag) begin
            coin_val_sum <= 11'b0;
        end
    end
    always @(posedge clk or negedge rst_n) begin//ʱ���߼�����ֵΪ��� 
        if (!rst_n) begin
            coin_val <= 5'b0;
        end
        else if (touch_puse) begin
            case (touch_data)
                5'd15: coin_val <= 5'd1;
                5'd16: coin_val <= 5'd2;
                5'd17: coin_val <= 5'd10;
                5'd18: coin_val <= 5'd20;
                default: coin_val <= coin_val;
            endcase
        end
    end 
    //ȷ����ȡ�����˱��ź�
    assign sure_flag = touch_puse && (touch_data == 5'd13);
    assign cancel_flag = touch_puse && (touch_data == 5'd14);
    assign charge_flag = touch_puse && (touch_data == 5'd19);

endmodule
