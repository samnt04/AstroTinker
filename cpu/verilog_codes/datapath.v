
// datapath.v - datapath for single-cycle RISC-V CPU

module datapath (
    input         clk, reset,
    input   [1:0] ResultSrc,
    input         PCSrc, Jalr, ALUSrc,
    input         RegWrite, Op5,
    input   [1:0] ImmSrc, Store,
    input   [2:0] Load,
    input   [3:0] ALUControl,
    output        Zero, ALUR31,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData
);

wire [31:0] PCNext, PCNextJalr, PCPlus4, PCTarget;
wire [31:0] ImmExt, SrcA, SrcB, Result, WriteData, ALUResult;
wire [31:0] ReadDataMem, AUIPc, URd;

// next PC logic
// Confused with JAlR
reset_ff pcreg (
    // inputs
    .clk(clk),                  .rst(reset), 
    // 32 bits
    .d(PCNextJalr),    
    
    // ouputs
    // 32 bits
    .q(PC)
);

adder pcadd4 (
    // inputs    
    // 32 bit       32 bit
    .a(PC),         .b(32'd4), 
    
    // outputs
    // 32 bit
    .sum(PCPlus4)
);
adder pcaddbranch (
    // inputs
    // 32 bits          32 bit
    .a(PC),            .b(ImmExt), 
    
    // outputs
    // 32 bit
    .sum(PCTarget)
);
mux2 pcjalrmux(
    // inputs
    // 32 bits          32 bits
    .d0(PCNext),        .d1(ALUResult), 
    .sel(Jalr),
    
    // outputs
    // 32 bits
    .y(PCNextJalr)
);
mux2 pcmux (
    // inputs
    // 32 bit       32 bit
    .d0(PCPlus4),   .d1(PCTarget), 
    .sel(PCSrc), 
    
    // outputs
    // 32 bits
    .y(PCNext)
);

// Without JALR
// reset_ff #(32) pcreg(clk, reset, PCNext, PC);
// adder          pcadd4(PC, 32'd4, PCPlus4);
// adder          pcaddbranch(PC, ImmExt, PCTarget);
// mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);


// register file logic
reg_file rf (
    
    .clk(clk),                  .wr_en(RegWrite), 
    // 5 bits                   5 bits
    .rd_addr1(Instr[19:15]),    .rd_addr2(Instr[24:20]), 
    // 5 bits                   32 bit
    .wr_addr(Instr[11:7]),      .wr_data(Result), 
    
    // outputs
    // 32 bits
    .rd_data1(SrcA), .rd_data2(WriteData)
);

imm_extend ext (
    // inputs
    // [31:7] change            
    // change siz ein imm       // 2 bit
    .instr(Instr[31:7]),        .immsrc(ImmSrc), 
    
    // outputs
    // 32 bit
    .immext(ImmExt)
);

// ALU logic
mux2 srcbmux (
    // inputs
    // 32 bit           32 bit
    .d0(WriteData),     .d1(ImmExt), 
    .sel(ALUSrc), 
    
    // outputs
    // 32 bits
    .y(SrcB)
);

alu alu (
    // outputs
    // 32 bit                   32 bit
    .a(SrcA),                  .b(SrcB), 
    // 4 bit
    .alu_ctrl(ALUControl), 
    
    // inputs
    // 32 bit
    .alu_out(ALUResult),    .zero(Zero)
);

// load data
load_extend ldextd (
    // inputs
    // 32 bit           3 bit
    .y(ReadData),       .sel(Load), 
    
    // outputs
    // 32 bits
    .data(ReadDataMem)
);

// lui and auipc
adder auipcadd  (
    // inputs
    // 32 bit   32 bit
    .a(PC),     .b({Instr[31:12], 12'b0}), 
    
    // outputs
    // 32 bit
    .sum(AUIPc)
);
mux2  luipcmux(
    // inputs
    // 32 bits      32 bits
    .d0(AUIPc),     .d1({Instr[31:12], 12'b0}), 
    .sel(Op5), 
    
    // outputs
    // 32 bits
    .y(URd)
);

mux4  resultmux (
    // inputs
    // 32 bit           32 bit
    .d0(ALUResult),     .d1(ReadDataMem), 
    // 32 bit           32 bit
    .d2(PCPlus4),       .d3(URd), 
    // 2 bit
    .sel(ResultSrc), 
    
    // outputs
    // 32 bits
    .y(Result)
);

// store data
store_extend strextd (
    // inputs
    // 32 bit           2 bit
    .y(WriteData),      .sel(Store), 
    
    // outputs
    // 32 bit
    .data(Mem_WrData)
);

// assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;
assign ALUR31 = ALUResult[31];

endmodule
