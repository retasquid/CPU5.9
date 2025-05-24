 module CPU5_9(
    output wire[15:0] Dout,
    output wire[15:0] Addr,
    output wire write,
    output wire[15:0] ROMaddr,
    input wire[28:0] ROMdata,
    input wire[15:0] Din,
    input wire[7:0] Interrupts,
    input wire clk_bus,
    input wire rst_bus
);
    wire ENflags, SBalu, Wreg, INTjmp, jmp, PCpp, Ret, Call, outOR, CallINT,IntSTOP;
    wire[1:0] Sregin;
    wire[2:0] OPalu;
    wire[3:0] FLAGS;
    wire[15:0] B, S, MUXREG,Aint;
    
    wire[4:0] OPcode;
    wire[3:0] Rd,R1,R2;
    wire[15:0] Imm;
    
    assign OPcode = ROMdata[28:24];
    assign Rd =  ROMdata[23:20];
    assign R1 =  ROMdata[19:16];
    assign R2 =  ROMdata[15:12];
    assign Imm = ROMdata[15:0];

    assign  TEST = ROMaddr[7:0];
    
    ALU alu_inst(
        .S(S),
        .FLAGS(FLAGS),
        .A(Dout),
        .B(Addr),
        .OPALU(OPalu),
        .enFLAGS(ENflags),
        .clk(clk_bus),
        .rst(rst_bus)
    );

    PC pc_inst(
        .ADDRout(ROMaddr),
        .INTjmp(INTjmp),
        .jmp(jmp),
        .PCpp(PCpp),
        .Ret(Ret),
        .CLK(clk_bus),
        .RST(rst_bus),
        .Imm(Imm),
        .Aint(Aint),
        .DoST(Dout)
    );

    REGFILE regfile_inst(
        .A(Dout),
        .B(B),
        .Rd(MUXREG),
        .RdSEL(Rd),
        .Asel(R1),
        .Bsel(R2),
        .WRT(Wreg),
        .clk(clk_bus),
        .rst(rst_bus)
    );

    UC uc_inst(
        .PCpp(PCpp), 
        .JMP(jmp),
        .ret(Ret),
        .Wreg(Wreg),
        .Sregin(Sregin),
        .SBalu(SBalu),
        .ENflag(ENflags),
        .OPalu(OPalu),
        .Wbus(write),
        .OPCode(OPcode),
        .A(R1[1:0]),
        .FLAG(FLAGS),
        .CLK(clk_bus),
        .interrupt(1'b0),
        .CallInt(CallINT)
    );

    INTERRUPT interrupt_inst(
        .Addr(Aint),
        .Call(CallINT),
        .INTjmp(INTjmp),
        .intSTOP(IntSTOP),
        .interrupts(Interrupts),
        .CLK(clk_bus),
        .RST(rst_bus)
    );

    MUX4 mux4_inst(
        .OUT(MUXREG),
        .IN0(S),
        .IN1(Imm),
        .IN2(Din),
        .IN3(ROMaddr),
        .SEL(Sregin)
    );

    MUXdeux mux2_alu_inst(
        .OUT(Addr),
        .IN0(B),
        .IN1(Imm),
        .SEL(SBalu)
    );
endmodule