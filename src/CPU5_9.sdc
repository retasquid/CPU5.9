//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.10.03 Education (64-bit) 
//Created Time: 2025-05-24 12:15:17
create_clock -name clk_baud -period 1000 -waveform {0 500} [get_nets {io/uart/clk_baud}]
create_clock -name clk_out -period 100 -waveform {0 50} [get_ports {clk_out}]
