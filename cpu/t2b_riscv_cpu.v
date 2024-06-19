
// t2b_riscv_cpu_tutorial.v - Top Module to test riscv_cpu

module t2b_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData
);

wire [31:0] PC, Instr;
wire        MemWrite_rv32;
wire [31:0] DataAdr_rv32, WriteData_rv32;

// instantiate processor and memories
riscv_cpu rvcpu (
    // inputs
    .clk(clk),                  .reset(reset), 
    // 32 bit                   32 bit
    .Instr(Instr),              .ReadData(ReadData), 
    // 32 bit
    .PC(PC),                    
    
    // outputs
    // 32 bit                   32 bit
    .MemWrite(MemWrite_rv32),   .Mem_WrAddr(DataAdr_rv32),  
    // 32 bit
    .Mem_WrData(WriteData_rv32)
);
instr_mem instrmem (
    // inputs 32 bit
    .instr_addr(PC), 
    // outputs 32 bit
    .instr(Instr)
);
data_mem datamem (
    // inputs
    .clk(clk),              .wr_en(MemWrite), 
    // 32 bit               32 bit
    .wr_addr(DataAdr),      .wr_data(WriteData), 
    // outputs 32 bit
    .rd_data_mem(ReadData)
);

assign MemWrite  = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule
