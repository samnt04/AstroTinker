
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero, ALUR31,
    output [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, Jalr, ALUSrc,
    output       RegWrite, Op5,
    output [1:0] ImmSrc, Store,
    output [2:0] Load,
    output [3:0] ALUControl
);

wire [1:0] ALUOp;
wire       Branch, Jump, Take_Branch;

main_decoder    md (
    // inputs
    // 7 bits               // 3 bits
    .op(op),                .funct3(funct3), 
    
    // outputs
    // 2 bits
    .ResultSrc(ResultSrc),  .MemWrite(MemWrite), 
    .Branch(Branch),        .ALUR31(ALUR31),
    .ALUSrc(ALUSrc),        .RegWrite(RegWrite), 
    .Zero(Zero),            .Jump(Jump), 
    .Jalr(Jalr),            .Take_Branch(Take_Branch),
    // 2 bits               2 bits
    .ImmSrc(ImmSrc),        .ALUOp(ALUOp),
    // 2 bits               3 bits 
    .Store(Store),          .Load(Load)
);

alu_decoder     ad (
    // inputs
    .opb5(op[5]),           .funct3(funct3), 
    .funct7b5(funct7b5),    .ALUOp(ALUOp), 
    
    // outputs
    .ALUControl(ALUControl)
);

// for jump and branch
// assign PCSrc = (Branch & Take_Branch) | Jump;

assign PCSrc = (Take_Branch) | Jump;
assign Op5 = op[5];

endmodule
