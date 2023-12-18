module FSM_top (
    input clk,
    input rst_n,
    input touch_valid,                  //触摸检测脉冲
    input [31:0] data,                  //坐标数据
    output [3:0]product_number,         //商品序号
    output [10:0]coin_val_sum,           //剩余金额
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
        //触摸输入
        .data(data),                            //坐标数据,高16位为X，低16位为y 20~780;
        .touch_valid(touch_valid),              //触摸成功标志
        //确定，取消信号
        .cancel_flag(cancel_flag),
        .sure_flag(sure_flag),
        //投币有关
        .coin_fn_flag(coin_fn_flag),            //投币完成信号
        .coin_sig(coin_sig),                    //投币信号
        //支付有关
        .pay_st_flag(pay_st_flag),
        .nonenough_flag(nonenough_flag),        //钱不够信号
        .pay_sta_flag(pay_sta_flag),
        //退币/找零有关
        .charge_flag(charge_flag),
        .charge_st_flag(charge_st_flag),        //开始找零信号
        .coin_val_sum(coin_val_sum),            //已投金额 数值为0~2000 对应0~1000r
        //选择商品有关
        .selected_sta_flag(selected_sta_flag),  //进入已选择状态信号
        .select_flag(select_flag),              //选择信号
        .product_number(product_number),         //选择商品序号1~12
        .coin_ov_flag(coin_ov_flag),
        .coin_sta_flag(coin_sta_flag)
    );

    AutoVendingFSM u_AutoVendingFSM(
        .rst_n(rst_n),
        .clk(FSM_clk),
        //.clk(clk),
        //确定，取消信号
        .cancel_flag(cancel_flag),
        .sure_flag(sure_flag),
        //投币有关
        .coin_fn_flag(coin_fn_flag),            //投币完成信号
        .coin_sig(coin_sig),                    //投币信号
        //支付有关
        .pay_st_flag(pay_st_flag),
        .nonenough_flag(nonenough_flag),        //钱不够信号
        .pay_sta_flag(pay_sta_flag),            //支付延时状态，用于显示支付信息
        //退币/找零有关
        .charge_flag(charge_flag),
        .charge_st_flag(charge_st_flag),        //开始找零信号
        //选择商品有关
        .selected_sta_flag(selected_sta_flag),  //进入已选择状态信号
        .select_flag(select_flag),               //选择信号
        .if_pay_flag(if_pay_flag),
        .if_coin_flag(if_coin_flag),
        .if_charge_flag(if_charge_flag),
        .coin_sta_flag(coin_sta_flag)
    );

endmodule