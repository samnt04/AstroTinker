// riscv_cpu.v - single-cycle RISC-V CPU Processor
module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData
);

wire       ALUSrc, RegWrite, Zero, ALUR31;
wire       PCSrc, Jalr, Jump, Op5;
wire [1:0] ResultSrc, ImmSrc, Store;
wire [3:0] ALUControl;
wire [2:0] Load;

controller  c  (
    // inputs
    // 7 bits               // 3 bits
    .op(Instr[6:0]),        .funct3(Instr[14:12]), 
    .funct7b5(Instr[30]),   .Zero(Zero), 
    .ALUR31(ALUR31),

    // output
    // 2 bit                    
    .ResultSrc(ResultSrc),      .MemWrite(MemWrite), 
    .PCSrc(PCSrc),              .Jalr(Jalr), 
    .ALUSrc(ALUSrc),            .RegWrite(RegWrite),
    //                          2 bit
    .Op5(Op5),                  .ImmSrc(ImmSrc), 
    // 2 bit                    3 bit
    .Store(Store),              .Load(Load), 
    // 4 bit
    .ALUControl(ALUControl)
);

datapath    dp (
    // inputs
    .clk(clk),                  .reset(reset),
    // 2 bit 
    .ResultSrc(ResultSrc),      .PCSrc(PCSrc), 
    .Jalr(Jalr),                .ALUSrc(ALUSrc), 
    .RegWrite(RegWrite),        .Op5(Op5), 
    // 2 bit                    2 bit
    .ImmSrc(ImmSrc),            .Store(Store), 
    // 3 bit                    // 4 bit
    .Load(Load),                .ALUControl(ALUControl), 

    // outputs
    .Zero(Zero),                .ALUR31(ALUR31), 
    // 32 bit                   // 32 bit
    .PC(PC),                    .Instr(Instr),
    // 32 bit                   // 32 bit 
    .Mem_WrAddr(Mem_WrAddr),    .Mem_WrData(Mem_WrData), 
    // 32 bit
    .ReadData(ReadData)
);

endmodule
