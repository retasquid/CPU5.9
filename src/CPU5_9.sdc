//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.01 Education (64-bit) 
//Created Time: 2025-05-30 16:22:54
create_clock -name clk_out -period 100 -waveform {0 50} [get_ports {clk_out}]
