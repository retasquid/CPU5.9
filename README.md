# CPU5.9
Implementation of a basic 16-bit CPU with UART, SPI, Interruptions(work in progress).

It has been develloped for a tang nano 9k FPGA and use between 2500 and 3500 LUTs

## Specs
The CPU5.9 is slower than others µcontrollers because of the fpga latency and the architecture focused on 1 instruction per cycle.
| Core | CLOCK(MHz) | RAM(Bits) | ROM(Bits) | Inst Per Cycle(IPC) | PROTOCOL | Registers |
| ---- | ---------- | --------- | --------- | ------------------- | -------- | -------- |
| CPU5.9 | 0.4 | 16x24k | 32x65k | 1 | 1 UART / 1 SPI | 16 |
| ATmega328p | 20 | 8x2k | 16x32k | 1 - 0.25 | 1 UART / 1 SPI / 1 I2C | 32 |

Here is the instruction set (ISA) : https://docs.google.com/spreadsheets/d/1vhOGe5fxQasLqWsNROVNf7gBmljAszf1FUEZTxNj6Uk/edit?usp=sharing
