module touch_top(
    input             clk        , //ϵͳʱ���ź�
    input             rst_n      , //ϵͳ��λ�ź�
    //LCD��������ź�            
    output            touch_rst_n, //��������λ
    inout             touch_int  , //TOUCH INT�ź�
    output            touch_scl  , //I2C��SCLʱ���ź�
    inout             touch_sda,   //TOUCH IIC����
    //�û��˿�
    // input     [15:0]  lcd_id     , //LCD ID
    output    [31:0]  data        //����������
);

//parameter define
parameter CLK_FREQ = 50_000_000   ;  //i2c_driģ�������ʱ��Ƶ��(CLK_FREQ)
parameter I2C_FREQ = 250_000      ;  //I2C��SCLʱ��Ƶ��
parameter REG_NUM_WID = 8         ;  //һ�ζ�д�Ĵ����ĸ�����λ��
                                     
//wire define                        
wire  [6:0]             slave_addr     ;  //������ַ
wire                    i2c_exec       ;  //I2C����ִ���ź�
wire                    i2c_rh_wl      ;  //I2C��д�����ź�
wire  [15:0]            i2c_addr       ;  //I2C�����ڵ�ַ
wire  [7:0]             i2c_data_w     ;  //I2CҪд������
wire                    bit_ctrl       ;  //�ֵ�ַλ����(0:8b,1:16b)
wire  [REG_NUM_WID-1:0] reg_num        ;  //һ�ζ�д�Ĵ����ĸ���
wire  [7:0]             i2c_data_r     ;  //I2C����������
wire                    i2c_done       ;  //I2C�������
wire                    once_byte_done ;  ////һ�ֽ����ݶ�/д�������
wire                    i2c_ack        ;  //Ӧ���־
wire                    dri_clk        ;  //I2C����ʱ��
//*****************************************************
//**                    main code
//*****************************************************

//I2C����ģ��
i2c_dri  #(
    .CLK_FREQ      (CLK_FREQ     ),
    .I2C_FREQ      (I2C_FREQ     ),
    .WIDTH         (REG_NUM_WID  )
    )
    u_i2c_dri(   
    .clk           (clk          ),
    .rst_n         (rst_n        ),
                                 
    .slave_addr    (slave_addr    ),
    .i2c_exec      (i2c_exec      ),
    .i2c_rh_wl     (i2c_rh_wl     ),
    .i2c_addr      (i2c_addr      ),
    .i2c_data_w    (i2c_data_w    ),
    .bit_ctrl      (bit_ctrl      ),
    .reg_num       (reg_num       ),
    .i2c_data_r    (i2c_data_r    ),
    .i2c_done      (i2c_done      ),
    .once_byte_done(once_byte_done),
    .scl           (touch_scl     ),
    .sda           (touch_sda     ),
    .ack           (i2c_ack       ),

    .dri_clk       (dri_clk       ) 
    );

//��������ģ��
touch_dri  #(
    .WIDTH         (REG_NUM_WID   )
     )
    u_touch_dri(
    .clk           (dri_clk       ),
    .rst_n         (rst_n         ),
                                  
    .slave_addr    (slave_addr    ),
    .i2c_exec      (i2c_exec      ),
    .i2c_rh_wl     (i2c_rh_wl     ),
    .i2c_addr      (i2c_addr      ),
    .i2c_data_w    (i2c_data_w    ),
    .bit_ctrl      (bit_ctrl      ),
    .reg_num       (reg_num       ),
                                  
    .i2c_data_r    (i2c_data_r    ),
    .i2c_ack       (i2c_ack       ),
    .i2c_done      (i2c_done      ),
    .once_byte_done(once_byte_done),
     
    // .lcd_id        (lcd_id        ),
    .data          (data          ),
    .touch_rst_n   (touch_rst_n   ),
    .touch_int     (touch_int     )
    );

endmodule
