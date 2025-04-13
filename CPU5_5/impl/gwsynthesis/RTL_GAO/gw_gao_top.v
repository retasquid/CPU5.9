module gw_gao(
    \ROMaddr[15] ,
    \ROMaddr[14] ,
    \ROMaddr[13] ,
    \ROMaddr[12] ,
    \ROMaddr[11] ,
    \ROMaddr[10] ,
    \ROMaddr[9] ,
    \ROMaddr[8] ,
    \ROMaddr[7] ,
    \ROMaddr[6] ,
    \ROMaddr[5] ,
    \ROMaddr[4] ,
    \ROMaddr[3] ,
    \ROMaddr[2] ,
    \ROMaddr[1] ,
    \ROMaddr[0] ,
    clk_xtal,
    write,
    clk,
    \cpu5_5/pc_inst/INTjmp ,
    \cpu5_5/pc_inst/jmp ,
    \cpu5_5/pc_inst/PCpp ,
    \cpu5_5/pc_inst/Ret ,
    \cpu5_5/regfile_inst/registers[0][15] ,
    \cpu5_5/regfile_inst/registers[0][14] ,
    \cpu5_5/regfile_inst/registers[0][13] ,
    \cpu5_5/regfile_inst/registers[0][12] ,
    \cpu5_5/regfile_inst/registers[0][11] ,
    \cpu5_5/regfile_inst/registers[0][10] ,
    \cpu5_5/regfile_inst/registers[0][9] ,
    \cpu5_5/regfile_inst/registers[0][8] ,
    \cpu5_5/regfile_inst/registers[0][7] ,
    \cpu5_5/regfile_inst/registers[0][6] ,
    \cpu5_5/regfile_inst/registers[0][5] ,
    \cpu5_5/regfile_inst/registers[0][4] ,
    \cpu5_5/regfile_inst/registers[0][3] ,
    \cpu5_5/regfile_inst/registers[0][2] ,
    \cpu5_5/regfile_inst/registers[0][1] ,
    \cpu5_5/regfile_inst/registers[0][0] ,
    \cpu5_5/regfile_inst/registers[1][15] ,
    \cpu5_5/regfile_inst/registers[1][14] ,
    \cpu5_5/regfile_inst/registers[1][13] ,
    \cpu5_5/regfile_inst/registers[1][12] ,
    \cpu5_5/regfile_inst/registers[1][11] ,
    \cpu5_5/regfile_inst/registers[1][10] ,
    \cpu5_5/regfile_inst/registers[1][9] ,
    \cpu5_5/regfile_inst/registers[1][8] ,
    \cpu5_5/regfile_inst/registers[1][7] ,
    \cpu5_5/regfile_inst/registers[1][6] ,
    \cpu5_5/regfile_inst/registers[1][5] ,
    \cpu5_5/regfile_inst/registers[1][4] ,
    \cpu5_5/regfile_inst/registers[1][3] ,
    \cpu5_5/regfile_inst/registers[1][2] ,
    \cpu5_5/regfile_inst/registers[1][1] ,
    \cpu5_5/regfile_inst/registers[1][0] ,
    \cpu5_5/regfile_inst/registers[2][15] ,
    \cpu5_5/regfile_inst/registers[2][14] ,
    \cpu5_5/regfile_inst/registers[2][13] ,
    \cpu5_5/regfile_inst/registers[2][12] ,
    \cpu5_5/regfile_inst/registers[2][11] ,
    \cpu5_5/regfile_inst/registers[2][10] ,
    \cpu5_5/regfile_inst/registers[2][9] ,
    \cpu5_5/regfile_inst/registers[2][8] ,
    \cpu5_5/regfile_inst/registers[2][7] ,
    \cpu5_5/regfile_inst/registers[2][6] ,
    \cpu5_5/regfile_inst/registers[2][5] ,
    \cpu5_5/regfile_inst/registers[2][4] ,
    \cpu5_5/regfile_inst/registers[2][3] ,
    \cpu5_5/regfile_inst/registers[2][2] ,
    \cpu5_5/regfile_inst/registers[2][1] ,
    \cpu5_5/regfile_inst/registers[2][0] ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \ROMaddr[15] ;
input \ROMaddr[14] ;
input \ROMaddr[13] ;
input \ROMaddr[12] ;
input \ROMaddr[11] ;
input \ROMaddr[10] ;
input \ROMaddr[9] ;
input \ROMaddr[8] ;
input \ROMaddr[7] ;
input \ROMaddr[6] ;
input \ROMaddr[5] ;
input \ROMaddr[4] ;
input \ROMaddr[3] ;
input \ROMaddr[2] ;
input \ROMaddr[1] ;
input \ROMaddr[0] ;
input clk_xtal;
input write;
input clk;
input \cpu5_5/pc_inst/INTjmp ;
input \cpu5_5/pc_inst/jmp ;
input \cpu5_5/pc_inst/PCpp ;
input \cpu5_5/pc_inst/Ret ;
input \cpu5_5/regfile_inst/registers[0][15] ;
input \cpu5_5/regfile_inst/registers[0][14] ;
input \cpu5_5/regfile_inst/registers[0][13] ;
input \cpu5_5/regfile_inst/registers[0][12] ;
input \cpu5_5/regfile_inst/registers[0][11] ;
input \cpu5_5/regfile_inst/registers[0][10] ;
input \cpu5_5/regfile_inst/registers[0][9] ;
input \cpu5_5/regfile_inst/registers[0][8] ;
input \cpu5_5/regfile_inst/registers[0][7] ;
input \cpu5_5/regfile_inst/registers[0][6] ;
input \cpu5_5/regfile_inst/registers[0][5] ;
input \cpu5_5/regfile_inst/registers[0][4] ;
input \cpu5_5/regfile_inst/registers[0][3] ;
input \cpu5_5/regfile_inst/registers[0][2] ;
input \cpu5_5/regfile_inst/registers[0][1] ;
input \cpu5_5/regfile_inst/registers[0][0] ;
input \cpu5_5/regfile_inst/registers[1][15] ;
input \cpu5_5/regfile_inst/registers[1][14] ;
input \cpu5_5/regfile_inst/registers[1][13] ;
input \cpu5_5/regfile_inst/registers[1][12] ;
input \cpu5_5/regfile_inst/registers[1][11] ;
input \cpu5_5/regfile_inst/registers[1][10] ;
input \cpu5_5/regfile_inst/registers[1][9] ;
input \cpu5_5/regfile_inst/registers[1][8] ;
input \cpu5_5/regfile_inst/registers[1][7] ;
input \cpu5_5/regfile_inst/registers[1][6] ;
input \cpu5_5/regfile_inst/registers[1][5] ;
input \cpu5_5/regfile_inst/registers[1][4] ;
input \cpu5_5/regfile_inst/registers[1][3] ;
input \cpu5_5/regfile_inst/registers[1][2] ;
input \cpu5_5/regfile_inst/registers[1][1] ;
input \cpu5_5/regfile_inst/registers[1][0] ;
input \cpu5_5/regfile_inst/registers[2][15] ;
input \cpu5_5/regfile_inst/registers[2][14] ;
input \cpu5_5/regfile_inst/registers[2][13] ;
input \cpu5_5/regfile_inst/registers[2][12] ;
input \cpu5_5/regfile_inst/registers[2][11] ;
input \cpu5_5/regfile_inst/registers[2][10] ;
input \cpu5_5/regfile_inst/registers[2][9] ;
input \cpu5_5/regfile_inst/registers[2][8] ;
input \cpu5_5/regfile_inst/registers[2][7] ;
input \cpu5_5/regfile_inst/registers[2][6] ;
input \cpu5_5/regfile_inst/registers[2][5] ;
input \cpu5_5/regfile_inst/registers[2][4] ;
input \cpu5_5/regfile_inst/registers[2][3] ;
input \cpu5_5/regfile_inst/registers[2][2] ;
input \cpu5_5/regfile_inst/registers[2][1] ;
input \cpu5_5/regfile_inst/registers[2][0] ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \ROMaddr[15] ;
wire \ROMaddr[14] ;
wire \ROMaddr[13] ;
wire \ROMaddr[12] ;
wire \ROMaddr[11] ;
wire \ROMaddr[10] ;
wire \ROMaddr[9] ;
wire \ROMaddr[8] ;
wire \ROMaddr[7] ;
wire \ROMaddr[6] ;
wire \ROMaddr[5] ;
wire \ROMaddr[4] ;
wire \ROMaddr[3] ;
wire \ROMaddr[2] ;
wire \ROMaddr[1] ;
wire \ROMaddr[0] ;
wire clk_xtal;
wire write;
wire clk;
wire \cpu5_5/pc_inst/INTjmp ;
wire \cpu5_5/pc_inst/jmp ;
wire \cpu5_5/pc_inst/PCpp ;
wire \cpu5_5/pc_inst/Ret ;
wire \cpu5_5/regfile_inst/registers[0][15] ;
wire \cpu5_5/regfile_inst/registers[0][14] ;
wire \cpu5_5/regfile_inst/registers[0][13] ;
wire \cpu5_5/regfile_inst/registers[0][12] ;
wire \cpu5_5/regfile_inst/registers[0][11] ;
wire \cpu5_5/regfile_inst/registers[0][10] ;
wire \cpu5_5/regfile_inst/registers[0][9] ;
wire \cpu5_5/regfile_inst/registers[0][8] ;
wire \cpu5_5/regfile_inst/registers[0][7] ;
wire \cpu5_5/regfile_inst/registers[0][6] ;
wire \cpu5_5/regfile_inst/registers[0][5] ;
wire \cpu5_5/regfile_inst/registers[0][4] ;
wire \cpu5_5/regfile_inst/registers[0][3] ;
wire \cpu5_5/regfile_inst/registers[0][2] ;
wire \cpu5_5/regfile_inst/registers[0][1] ;
wire \cpu5_5/regfile_inst/registers[0][0] ;
wire \cpu5_5/regfile_inst/registers[1][15] ;
wire \cpu5_5/regfile_inst/registers[1][14] ;
wire \cpu5_5/regfile_inst/registers[1][13] ;
wire \cpu5_5/regfile_inst/registers[1][12] ;
wire \cpu5_5/regfile_inst/registers[1][11] ;
wire \cpu5_5/regfile_inst/registers[1][10] ;
wire \cpu5_5/regfile_inst/registers[1][9] ;
wire \cpu5_5/regfile_inst/registers[1][8] ;
wire \cpu5_5/regfile_inst/registers[1][7] ;
wire \cpu5_5/regfile_inst/registers[1][6] ;
wire \cpu5_5/regfile_inst/registers[1][5] ;
wire \cpu5_5/regfile_inst/registers[1][4] ;
wire \cpu5_5/regfile_inst/registers[1][3] ;
wire \cpu5_5/regfile_inst/registers[1][2] ;
wire \cpu5_5/regfile_inst/registers[1][1] ;
wire \cpu5_5/regfile_inst/registers[1][0] ;
wire \cpu5_5/regfile_inst/registers[2][15] ;
wire \cpu5_5/regfile_inst/registers[2][14] ;
wire \cpu5_5/regfile_inst/registers[2][13] ;
wire \cpu5_5/regfile_inst/registers[2][12] ;
wire \cpu5_5/regfile_inst/registers[2][11] ;
wire \cpu5_5/regfile_inst/registers[2][10] ;
wire \cpu5_5/regfile_inst/registers[2][9] ;
wire \cpu5_5/regfile_inst/registers[2][8] ;
wire \cpu5_5/regfile_inst/registers[2][7] ;
wire \cpu5_5/regfile_inst/registers[2][6] ;
wire \cpu5_5/regfile_inst/registers[2][5] ;
wire \cpu5_5/regfile_inst/registers[2][4] ;
wire \cpu5_5/regfile_inst/registers[2][3] ;
wire \cpu5_5/regfile_inst/registers[2][2] ;
wire \cpu5_5/regfile_inst/registers[2][1] ;
wire \cpu5_5/regfile_inst/registers[2][0] ;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\ROMaddr[15] ,\ROMaddr[14] ,\ROMaddr[13] ,\ROMaddr[12] ,\ROMaddr[11] ,\ROMaddr[10] ,\ROMaddr[9] ,\ROMaddr[8] ,\ROMaddr[7] ,\ROMaddr[6] ,\ROMaddr[5] ,\ROMaddr[4] ,\ROMaddr[3] ,\ROMaddr[2] ,\ROMaddr[1] ,\ROMaddr[0] ,clk_xtal,write,clk,\cpu5_5/pc_inst/INTjmp ,\cpu5_5/pc_inst/jmp ,\cpu5_5/pc_inst/PCpp ,\cpu5_5/pc_inst/Ret ,\cpu5_5/regfile_inst/registers[0][15] ,\cpu5_5/regfile_inst/registers[0][14] ,\cpu5_5/regfile_inst/registers[0][13] ,\cpu5_5/regfile_inst/registers[0][12] ,\cpu5_5/regfile_inst/registers[0][11] ,\cpu5_5/regfile_inst/registers[0][10] ,\cpu5_5/regfile_inst/registers[0][9] ,\cpu5_5/regfile_inst/registers[0][8] ,\cpu5_5/regfile_inst/registers[0][7] ,\cpu5_5/regfile_inst/registers[0][6] ,\cpu5_5/regfile_inst/registers[0][5] ,\cpu5_5/regfile_inst/registers[0][4] ,\cpu5_5/regfile_inst/registers[0][3] ,\cpu5_5/regfile_inst/registers[0][2] ,\cpu5_5/regfile_inst/registers[0][1] ,\cpu5_5/regfile_inst/registers[0][0] ,\cpu5_5/regfile_inst/registers[1][15] ,\cpu5_5/regfile_inst/registers[1][14] ,\cpu5_5/regfile_inst/registers[1][13] ,\cpu5_5/regfile_inst/registers[1][12] ,\cpu5_5/regfile_inst/registers[1][11] ,\cpu5_5/regfile_inst/registers[1][10] ,\cpu5_5/regfile_inst/registers[1][9] ,\cpu5_5/regfile_inst/registers[1][8] ,\cpu5_5/regfile_inst/registers[1][7] ,\cpu5_5/regfile_inst/registers[1][6] ,\cpu5_5/regfile_inst/registers[1][5] ,\cpu5_5/regfile_inst/registers[1][4] ,\cpu5_5/regfile_inst/registers[1][3] ,\cpu5_5/regfile_inst/registers[1][2] ,\cpu5_5/regfile_inst/registers[1][1] ,\cpu5_5/regfile_inst/registers[1][0] ,\cpu5_5/regfile_inst/registers[2][15] ,\cpu5_5/regfile_inst/registers[2][14] ,\cpu5_5/regfile_inst/registers[2][13] ,\cpu5_5/regfile_inst/registers[2][12] ,\cpu5_5/regfile_inst/registers[2][11] ,\cpu5_5/regfile_inst/registers[2][10] ,\cpu5_5/regfile_inst/registers[2][9] ,\cpu5_5/regfile_inst/registers[2][8] ,\cpu5_5/regfile_inst/registers[2][7] ,\cpu5_5/regfile_inst/registers[2][6] ,\cpu5_5/regfile_inst/registers[2][5] ,\cpu5_5/regfile_inst/registers[2][4] ,\cpu5_5/regfile_inst/registers[2][3] ,\cpu5_5/regfile_inst/registers[2][2] ,\cpu5_5/regfile_inst/registers[2][1] ,\cpu5_5/regfile_inst/registers[2][0] }),
    .clk_i(clk)
);

endmodule
