//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.11.01 Education (64-bit)
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9
//Device Version: C
//Created Time: Wed Jun 18 12:50:10 2025

module Gowin_SP (dout, clk, oce, ce, reset, wre, ad, din);

output [15:0] dout;
input clk;
input oce;
input ce;
input reset;
input wre;
input [13:0] ad;
input [15:0] din;

wire [26:0] spx9_inst_0_dout_w;
wire [8:0] spx9_inst_0_dout;
wire [26:0] spx9_inst_1_dout_w;
wire [8:0] spx9_inst_1_dout;
wire [26:0] spx9_inst_2_dout_w;
wire [8:0] spx9_inst_2_dout;
wire [26:0] spx9_inst_3_dout_w;
wire [8:0] spx9_inst_3_dout;
wire [26:0] spx9_inst_4_dout_w;
wire [8:0] spx9_inst_4_dout;
wire [26:0] spx9_inst_5_dout_w;
wire [8:0] spx9_inst_5_dout;
wire [26:0] spx9_inst_6_dout_w;
wire [8:0] spx9_inst_6_dout;
wire [26:0] spx9_inst_7_dout_w;
wire [8:0] spx9_inst_7_dout;
wire [30:0] sp_inst_8_dout_w;
wire [30:0] sp_inst_9_dout_w;
wire [30:0] sp_inst_10_dout_w;
wire [30:0] sp_inst_11_dout_w;
wire [30:0] sp_inst_12_dout_w;
wire [30:0] sp_inst_13_dout_w;
wire [30:0] sp_inst_14_dout_w;
wire dff_q_0;
wire dff_q_1;
wire dff_q_2;
wire mux_o_0;
wire mux_o_1;
wire mux_o_2;
wire mux_o_3;
wire mux_o_4;
wire mux_o_5;
wire mux_o_7;
wire mux_o_8;
wire mux_o_9;
wire mux_o_10;
wire mux_o_11;
wire mux_o_12;
wire mux_o_14;
wire mux_o_15;
wire mux_o_16;
wire mux_o_17;
wire mux_o_18;
wire mux_o_19;
wire mux_o_21;
wire mux_o_22;
wire mux_o_23;
wire mux_o_24;
wire mux_o_25;
wire mux_o_26;
wire mux_o_28;
wire mux_o_29;
wire mux_o_30;
wire mux_o_31;
wire mux_o_32;
wire mux_o_33;
wire mux_o_35;
wire mux_o_36;
wire mux_o_37;
wire mux_o_38;
wire mux_o_39;
wire mux_o_40;
wire mux_o_42;
wire mux_o_43;
wire mux_o_44;
wire mux_o_45;
wire mux_o_46;
wire mux_o_47;
wire mux_o_49;
wire mux_o_50;
wire mux_o_51;
wire mux_o_52;
wire mux_o_53;
wire mux_o_54;
wire mux_o_56;
wire mux_o_57;
wire mux_o_58;
wire mux_o_59;
wire mux_o_60;
wire mux_o_61;
wire ce_w;
wire gw_gnd;

assign ce_w = ~wre & ce;
assign gw_gnd = 1'b0;

SPX9 spx9_inst_0 (
    .DO({spx9_inst_0_dout_w[26:0],spx9_inst_0_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_0.READ_MODE = 1'b0;
defparam spx9_inst_0.WRITE_MODE = 2'b00;
defparam spx9_inst_0.BIT_WIDTH = 9;
defparam spx9_inst_0.BLK_SEL = 3'b000;
defparam spx9_inst_0.RESET_MODE = "ASYNC";

SPX9 spx9_inst_1 (
    .DO({spx9_inst_1_dout_w[26:0],spx9_inst_1_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_1.READ_MODE = 1'b0;
defparam spx9_inst_1.WRITE_MODE = 2'b00;
defparam spx9_inst_1.BIT_WIDTH = 9;
defparam spx9_inst_1.BLK_SEL = 3'b001;
defparam spx9_inst_1.RESET_MODE = "ASYNC";

SPX9 spx9_inst_2 (
    .DO({spx9_inst_2_dout_w[26:0],spx9_inst_2_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_2.READ_MODE = 1'b0;
defparam spx9_inst_2.WRITE_MODE = 2'b00;
defparam spx9_inst_2.BIT_WIDTH = 9;
defparam spx9_inst_2.BLK_SEL = 3'b010;
defparam spx9_inst_2.RESET_MODE = "ASYNC";

SPX9 spx9_inst_3 (
    .DO({spx9_inst_3_dout_w[26:0],spx9_inst_3_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_3.READ_MODE = 1'b0;
defparam spx9_inst_3.WRITE_MODE = 2'b00;
defparam spx9_inst_3.BIT_WIDTH = 9;
defparam spx9_inst_3.BLK_SEL = 3'b011;
defparam spx9_inst_3.RESET_MODE = "ASYNC";

SPX9 spx9_inst_4 (
    .DO({spx9_inst_4_dout_w[26:0],spx9_inst_4_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_4.READ_MODE = 1'b0;
defparam spx9_inst_4.WRITE_MODE = 2'b00;
defparam spx9_inst_4.BIT_WIDTH = 9;
defparam spx9_inst_4.BLK_SEL = 3'b100;
defparam spx9_inst_4.RESET_MODE = "ASYNC";

SPX9 spx9_inst_5 (
    .DO({spx9_inst_5_dout_w[26:0],spx9_inst_5_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_5.READ_MODE = 1'b0;
defparam spx9_inst_5.WRITE_MODE = 2'b00;
defparam spx9_inst_5.BIT_WIDTH = 9;
defparam spx9_inst_5.BLK_SEL = 3'b101;
defparam spx9_inst_5.RESET_MODE = "ASYNC";

SPX9 spx9_inst_6 (
    .DO({spx9_inst_6_dout_w[26:0],spx9_inst_6_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_6.READ_MODE = 1'b0;
defparam spx9_inst_6.WRITE_MODE = 2'b00;
defparam spx9_inst_6.BIT_WIDTH = 9;
defparam spx9_inst_6.BLK_SEL = 3'b110;
defparam spx9_inst_6.RESET_MODE = "ASYNC";

SPX9 spx9_inst_7 (
    .DO({spx9_inst_7_dout_w[26:0],spx9_inst_7_dout[8:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({ad[13],ad[12],ad[11]}),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[8:0]})
);

defparam spx9_inst_7.READ_MODE = 1'b0;
defparam spx9_inst_7.WRITE_MODE = 2'b00;
defparam spx9_inst_7.BIT_WIDTH = 9;
defparam spx9_inst_7.BLK_SEL = 3'b111;
defparam spx9_inst_7.RESET_MODE = "ASYNC";

SP sp_inst_8 (
    .DO({sp_inst_8_dout_w[30:0],dout[9]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({gw_gnd,gw_gnd,gw_gnd}),
    .AD(ad[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[9]})
);

defparam sp_inst_8.READ_MODE = 1'b0;
defparam sp_inst_8.WRITE_MODE = 2'b00;
defparam sp_inst_8.BIT_WIDTH = 1;
defparam sp_inst_8.BLK_SEL = 3'b000;
defparam sp_inst_8.RESET_MODE = "ASYNC";

SP sp_inst_9 (
    .DO({sp_inst_9_dout_w[30:0],dout[10]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({gw_gnd,gw_gnd,gw_gnd}),
    .AD(ad[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[10]})
);

defparam sp_inst_9.READ_MODE = 1'b0;
defparam sp_inst_9.WRITE_MODE = 2'b00;
defparam sp_inst_9.BIT_WIDTH = 1;
defparam sp_inst_9.BLK_SEL = 3'b000;
defparam sp_inst_9.RESET_MODE = "ASYNC";

SP sp_inst_10 (
    .DO({sp_inst_10_dout_w[30:0],dout[11]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({gw_gnd,gw_gnd,gw_gnd}),
    .AD(ad[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[11]})
);

defparam sp_inst_10.READ_MODE = 1'b0;
defparam sp_inst_10.WRITE_MODE = 2'b00;
defparam sp_inst_10.BIT_WIDTH = 1;
defparam sp_inst_10.BLK_SEL = 3'b000;
defparam sp_inst_10.RESET_MODE = "ASYNC";

SP sp_inst_11 (
    .DO({sp_inst_11_dout_w[30:0],dout[12]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({gw_gnd,gw_gnd,gw_gnd}),
    .AD(ad[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[12]})
);

defparam sp_inst_11.READ_MODE = 1'b0;
defparam sp_inst_11.WRITE_MODE = 2'b00;
defparam sp_inst_11.BIT_WIDTH = 1;
defparam sp_inst_11.BLK_SEL = 3'b000;
defparam sp_inst_11.RESET_MODE = "ASYNC";

SP sp_inst_12 (
    .DO({sp_inst_12_dout_w[30:0],dout[13]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({gw_gnd,gw_gnd,gw_gnd}),
    .AD(ad[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[13]})
);

defparam sp_inst_12.READ_MODE = 1'b0;
defparam sp_inst_12.WRITE_MODE = 2'b00;
defparam sp_inst_12.BIT_WIDTH = 1;
defparam sp_inst_12.BLK_SEL = 3'b000;
defparam sp_inst_12.RESET_MODE = "ASYNC";

SP sp_inst_13 (
    .DO({sp_inst_13_dout_w[30:0],dout[14]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({gw_gnd,gw_gnd,gw_gnd}),
    .AD(ad[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[14]})
);

defparam sp_inst_13.READ_MODE = 1'b0;
defparam sp_inst_13.WRITE_MODE = 2'b00;
defparam sp_inst_13.BIT_WIDTH = 1;
defparam sp_inst_13.BLK_SEL = 3'b000;
defparam sp_inst_13.RESET_MODE = "ASYNC";

SP sp_inst_14 (
    .DO({sp_inst_14_dout_w[30:0],dout[15]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .WRE(wre),
    .BLKSEL({gw_gnd,gw_gnd,gw_gnd}),
    .AD(ad[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[15]})
);

defparam sp_inst_14.READ_MODE = 1'b0;
defparam sp_inst_14.WRITE_MODE = 2'b00;
defparam sp_inst_14.BIT_WIDTH = 1;
defparam sp_inst_14.BLK_SEL = 3'b000;
defparam sp_inst_14.RESET_MODE = "ASYNC";

DFFE dff_inst_0 (
  .Q(dff_q_0),
  .D(ad[13]),
  .CLK(clk),
  .CE(ce_w)
);
DFFE dff_inst_1 (
  .Q(dff_q_1),
  .D(ad[12]),
  .CLK(clk),
  .CE(ce_w)
);
DFFE dff_inst_2 (
  .Q(dff_q_2),
  .D(ad[11]),
  .CLK(clk),
  .CE(ce_w)
);
MUX2 mux_inst_0 (
  .O(mux_o_0),
  .I0(spx9_inst_0_dout[0]),
  .I1(spx9_inst_1_dout[0]),
  .S0(dff_q_2)
);
MUX2 mux_inst_1 (
  .O(mux_o_1),
  .I0(spx9_inst_2_dout[0]),
  .I1(spx9_inst_3_dout[0]),
  .S0(dff_q_2)
);
MUX2 mux_inst_2 (
  .O(mux_o_2),
  .I0(spx9_inst_4_dout[0]),
  .I1(spx9_inst_5_dout[0]),
  .S0(dff_q_2)
);
MUX2 mux_inst_3 (
  .O(mux_o_3),
  .I0(spx9_inst_6_dout[0]),
  .I1(spx9_inst_7_dout[0]),
  .S0(dff_q_2)
);
MUX2 mux_inst_4 (
  .O(mux_o_4),
  .I0(mux_o_0),
  .I1(mux_o_1),
  .S0(dff_q_1)
);
MUX2 mux_inst_5 (
  .O(mux_o_5),
  .I0(mux_o_2),
  .I1(mux_o_3),
  .S0(dff_q_1)
);
MUX2 mux_inst_6 (
  .O(dout[0]),
  .I0(mux_o_4),
  .I1(mux_o_5),
  .S0(dff_q_0)
);
MUX2 mux_inst_7 (
  .O(mux_o_7),
  .I0(spx9_inst_0_dout[1]),
  .I1(spx9_inst_1_dout[1]),
  .S0(dff_q_2)
);
MUX2 mux_inst_8 (
  .O(mux_o_8),
  .I0(spx9_inst_2_dout[1]),
  .I1(spx9_inst_3_dout[1]),
  .S0(dff_q_2)
);
MUX2 mux_inst_9 (
  .O(mux_o_9),
  .I0(spx9_inst_4_dout[1]),
  .I1(spx9_inst_5_dout[1]),
  .S0(dff_q_2)
);
MUX2 mux_inst_10 (
  .O(mux_o_10),
  .I0(spx9_inst_6_dout[1]),
  .I1(spx9_inst_7_dout[1]),
  .S0(dff_q_2)
);
MUX2 mux_inst_11 (
  .O(mux_o_11),
  .I0(mux_o_7),
  .I1(mux_o_8),
  .S0(dff_q_1)
);
MUX2 mux_inst_12 (
  .O(mux_o_12),
  .I0(mux_o_9),
  .I1(mux_o_10),
  .S0(dff_q_1)
);
MUX2 mux_inst_13 (
  .O(dout[1]),
  .I0(mux_o_11),
  .I1(mux_o_12),
  .S0(dff_q_0)
);
MUX2 mux_inst_14 (
  .O(mux_o_14),
  .I0(spx9_inst_0_dout[2]),
  .I1(spx9_inst_1_dout[2]),
  .S0(dff_q_2)
);
MUX2 mux_inst_15 (
  .O(mux_o_15),
  .I0(spx9_inst_2_dout[2]),
  .I1(spx9_inst_3_dout[2]),
  .S0(dff_q_2)
);
MUX2 mux_inst_16 (
  .O(mux_o_16),
  .I0(spx9_inst_4_dout[2]),
  .I1(spx9_inst_5_dout[2]),
  .S0(dff_q_2)
);
MUX2 mux_inst_17 (
  .O(mux_o_17),
  .I0(spx9_inst_6_dout[2]),
  .I1(spx9_inst_7_dout[2]),
  .S0(dff_q_2)
);
MUX2 mux_inst_18 (
  .O(mux_o_18),
  .I0(mux_o_14),
  .I1(mux_o_15),
  .S0(dff_q_1)
);
MUX2 mux_inst_19 (
  .O(mux_o_19),
  .I0(mux_o_16),
  .I1(mux_o_17),
  .S0(dff_q_1)
);
MUX2 mux_inst_20 (
  .O(dout[2]),
  .I0(mux_o_18),
  .I1(mux_o_19),
  .S0(dff_q_0)
);
MUX2 mux_inst_21 (
  .O(mux_o_21),
  .I0(spx9_inst_0_dout[3]),
  .I1(spx9_inst_1_dout[3]),
  .S0(dff_q_2)
);
MUX2 mux_inst_22 (
  .O(mux_o_22),
  .I0(spx9_inst_2_dout[3]),
  .I1(spx9_inst_3_dout[3]),
  .S0(dff_q_2)
);
MUX2 mux_inst_23 (
  .O(mux_o_23),
  .I0(spx9_inst_4_dout[3]),
  .I1(spx9_inst_5_dout[3]),
  .S0(dff_q_2)
);
MUX2 mux_inst_24 (
  .O(mux_o_24),
  .I0(spx9_inst_6_dout[3]),
  .I1(spx9_inst_7_dout[3]),
  .S0(dff_q_2)
);
MUX2 mux_inst_25 (
  .O(mux_o_25),
  .I0(mux_o_21),
  .I1(mux_o_22),
  .S0(dff_q_1)
);
MUX2 mux_inst_26 (
  .O(mux_o_26),
  .I0(mux_o_23),
  .I1(mux_o_24),
  .S0(dff_q_1)
);
MUX2 mux_inst_27 (
  .O(dout[3]),
  .I0(mux_o_25),
  .I1(mux_o_26),
  .S0(dff_q_0)
);
MUX2 mux_inst_28 (
  .O(mux_o_28),
  .I0(spx9_inst_0_dout[4]),
  .I1(spx9_inst_1_dout[4]),
  .S0(dff_q_2)
);
MUX2 mux_inst_29 (
  .O(mux_o_29),
  .I0(spx9_inst_2_dout[4]),
  .I1(spx9_inst_3_dout[4]),
  .S0(dff_q_2)
);
MUX2 mux_inst_30 (
  .O(mux_o_30),
  .I0(spx9_inst_4_dout[4]),
  .I1(spx9_inst_5_dout[4]),
  .S0(dff_q_2)
);
MUX2 mux_inst_31 (
  .O(mux_o_31),
  .I0(spx9_inst_6_dout[4]),
  .I1(spx9_inst_7_dout[4]),
  .S0(dff_q_2)
);
MUX2 mux_inst_32 (
  .O(mux_o_32),
  .I0(mux_o_28),
  .I1(mux_o_29),
  .S0(dff_q_1)
);
MUX2 mux_inst_33 (
  .O(mux_o_33),
  .I0(mux_o_30),
  .I1(mux_o_31),
  .S0(dff_q_1)
);
MUX2 mux_inst_34 (
  .O(dout[4]),
  .I0(mux_o_32),
  .I1(mux_o_33),
  .S0(dff_q_0)
);
MUX2 mux_inst_35 (
  .O(mux_o_35),
  .I0(spx9_inst_0_dout[5]),
  .I1(spx9_inst_1_dout[5]),
  .S0(dff_q_2)
);
MUX2 mux_inst_36 (
  .O(mux_o_36),
  .I0(spx9_inst_2_dout[5]),
  .I1(spx9_inst_3_dout[5]),
  .S0(dff_q_2)
);
MUX2 mux_inst_37 (
  .O(mux_o_37),
  .I0(spx9_inst_4_dout[5]),
  .I1(spx9_inst_5_dout[5]),
  .S0(dff_q_2)
);
MUX2 mux_inst_38 (
  .O(mux_o_38),
  .I0(spx9_inst_6_dout[5]),
  .I1(spx9_inst_7_dout[5]),
  .S0(dff_q_2)
);
MUX2 mux_inst_39 (
  .O(mux_o_39),
  .I0(mux_o_35),
  .I1(mux_o_36),
  .S0(dff_q_1)
);
MUX2 mux_inst_40 (
  .O(mux_o_40),
  .I0(mux_o_37),
  .I1(mux_o_38),
  .S0(dff_q_1)
);
MUX2 mux_inst_41 (
  .O(dout[5]),
  .I0(mux_o_39),
  .I1(mux_o_40),
  .S0(dff_q_0)
);
MUX2 mux_inst_42 (
  .O(mux_o_42),
  .I0(spx9_inst_0_dout[6]),
  .I1(spx9_inst_1_dout[6]),
  .S0(dff_q_2)
);
MUX2 mux_inst_43 (
  .O(mux_o_43),
  .I0(spx9_inst_2_dout[6]),
  .I1(spx9_inst_3_dout[6]),
  .S0(dff_q_2)
);
MUX2 mux_inst_44 (
  .O(mux_o_44),
  .I0(spx9_inst_4_dout[6]),
  .I1(spx9_inst_5_dout[6]),
  .S0(dff_q_2)
);
MUX2 mux_inst_45 (
  .O(mux_o_45),
  .I0(spx9_inst_6_dout[6]),
  .I1(spx9_inst_7_dout[6]),
  .S0(dff_q_2)
);
MUX2 mux_inst_46 (
  .O(mux_o_46),
  .I0(mux_o_42),
  .I1(mux_o_43),
  .S0(dff_q_1)
);
MUX2 mux_inst_47 (
  .O(mux_o_47),
  .I0(mux_o_44),
  .I1(mux_o_45),
  .S0(dff_q_1)
);
MUX2 mux_inst_48 (
  .O(dout[6]),
  .I0(mux_o_46),
  .I1(mux_o_47),
  .S0(dff_q_0)
);
MUX2 mux_inst_49 (
  .O(mux_o_49),
  .I0(spx9_inst_0_dout[7]),
  .I1(spx9_inst_1_dout[7]),
  .S0(dff_q_2)
);
MUX2 mux_inst_50 (
  .O(mux_o_50),
  .I0(spx9_inst_2_dout[7]),
  .I1(spx9_inst_3_dout[7]),
  .S0(dff_q_2)
);
MUX2 mux_inst_51 (
  .O(mux_o_51),
  .I0(spx9_inst_4_dout[7]),
  .I1(spx9_inst_5_dout[7]),
  .S0(dff_q_2)
);
MUX2 mux_inst_52 (
  .O(mux_o_52),
  .I0(spx9_inst_6_dout[7]),
  .I1(spx9_inst_7_dout[7]),
  .S0(dff_q_2)
);
MUX2 mux_inst_53 (
  .O(mux_o_53),
  .I0(mux_o_49),
  .I1(mux_o_50),
  .S0(dff_q_1)
);
MUX2 mux_inst_54 (
  .O(mux_o_54),
  .I0(mux_o_51),
  .I1(mux_o_52),
  .S0(dff_q_1)
);
MUX2 mux_inst_55 (
  .O(dout[7]),
  .I0(mux_o_53),
  .I1(mux_o_54),
  .S0(dff_q_0)
);
MUX2 mux_inst_56 (
  .O(mux_o_56),
  .I0(spx9_inst_0_dout[8]),
  .I1(spx9_inst_1_dout[8]),
  .S0(dff_q_2)
);
MUX2 mux_inst_57 (
  .O(mux_o_57),
  .I0(spx9_inst_2_dout[8]),
  .I1(spx9_inst_3_dout[8]),
  .S0(dff_q_2)
);
MUX2 mux_inst_58 (
  .O(mux_o_58),
  .I0(spx9_inst_4_dout[8]),
  .I1(spx9_inst_5_dout[8]),
  .S0(dff_q_2)
);
MUX2 mux_inst_59 (
  .O(mux_o_59),
  .I0(spx9_inst_6_dout[8]),
  .I1(spx9_inst_7_dout[8]),
  .S0(dff_q_2)
);
MUX2 mux_inst_60 (
  .O(mux_o_60),
  .I0(mux_o_56),
  .I1(mux_o_57),
  .S0(dff_q_1)
);
MUX2 mux_inst_61 (
  .O(mux_o_61),
  .I0(mux_o_58),
  .I1(mux_o_59),
  .S0(dff_q_1)
);
MUX2 mux_inst_62 (
  .O(dout[8]),
  .I0(mux_o_60),
  .I1(mux_o_61),
  .S0(dff_q_0)
);
endmodule //Gowin_SP
