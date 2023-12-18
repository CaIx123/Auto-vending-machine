module FSM_top (
    input clk,
    input rst_n,
    input touch_valid,                  //�����������
    input [31:0] data,                  //��������
    output [3:0]product_number,         //��Ʒ���
    output [10:0]coin_val_sum,           //ʣ����
    output nonenough_flag,
    output coin_ov_flag,
    output if_pay_flag,
    output if_coin_flag,
    output if_charge_flag
);
    wire FSM_clk;

    FSM_clk_div u_FSM_clk_div(
        .clk(clk),
        .rst_n(rst_n),
        .FSM_clk(FSM_clk)
    );

    wire cancel_flag,sure_flag;
    wire coin_fn_flag,coin_sig;
    wire pay_st_flag;
    wire charge_flag,charge_st_flag;
    wire selected_sta_flag,select_flag;
    wire coin_sta_flag;
    FSM_dri u_FSM_dri(
        .rst_n(rst_n),
        .clk(FSM_clk),
        //.clk(clk),
        //��������
        .data(data),                            //��������,��16λΪX����16λΪy 20~780;
        .touch_valid(touch_valid),              //�����ɹ���־
        //ȷ����ȡ���ź�
        .cancel_flag(cancel_flag),
        .sure_flag(sure_flag),
        //Ͷ���й�
        .coin_fn_flag(coin_fn_flag),            //Ͷ������ź�
        .coin_sig(coin_sig),                    //Ͷ���ź�
        //֧���й�
        .pay_st_flag(pay_st_flag),
        .nonenough_flag(nonenough_flag),        //Ǯ�����ź�
        .pay_sta_flag(pay_sta_flag),
        //�˱�/�����й�
        .charge_flag(charge_flag),
        .charge_st_flag(charge_st_flag),        //��ʼ�����ź�
        .coin_val_sum(coin_val_sum),            //��Ͷ��� ��ֵΪ0~2000 ��Ӧ0~1000r
        //ѡ����Ʒ�й�
        .selected_sta_flag(selected_sta_flag),  //������ѡ��״̬�ź�
        .select_flag(select_flag),              //ѡ���ź�
        .product_number(product_number),         //ѡ����Ʒ���1~12
        .coin_ov_flag(coin_ov_flag),
        .coin_sta_flag(coin_sta_flag)
    );

    AutoVendingFSM u_AutoVendingFSM(
        .rst_n(rst_n),
        .clk(FSM_clk),
        //.clk(clk),
        //ȷ����ȡ���ź�
        .cancel_flag(cancel_flag),
        .sure_flag(sure_flag),
        //Ͷ���й�
        .coin_fn_flag(coin_fn_flag),            //Ͷ������ź�
        .coin_sig(coin_sig),                    //Ͷ���ź�
        //֧���й�
        .pay_st_flag(pay_st_flag),
        .nonenough_flag(nonenough_flag),        //Ǯ�����ź�
        .pay_sta_flag(pay_sta_flag),            //֧����ʱ״̬��������ʾ֧����Ϣ
        //�˱�/�����й�
        .charge_flag(charge_flag),
        .charge_st_flag(charge_st_flag),        //��ʼ�����ź�
        //ѡ����Ʒ�й�
        .selected_sta_flag(selected_sta_flag),  //������ѡ��״̬�ź�
        .select_flag(select_flag),               //ѡ���ź�
        .if_pay_flag(if_pay_flag),
        .if_coin_flag(if_coin_flag),
        .if_charge_flag(if_charge_flag),
        .coin_sta_flag(coin_sta_flag)
    );

endmodule