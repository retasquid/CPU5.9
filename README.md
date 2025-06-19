# CPU5.9
Implementation of a basic 16-bit CPU with UART, SPI, Interruptions(semi functionnal) and a stack.

It has been develloped for a tang nano 9k FPGA and use between 2000 and 3000 LUTs

## Specs
-RAM : 24kB

-ROM : 255 B with internal logic
or 64kB with external spi flash
  
-1 instruction per cycle

-1 UART with auto clear read buffer

-1 SPI

-max freq on tang nano 9k : 10kHz
