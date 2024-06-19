module cpu_interface( 
	input clk, //reset,
	//input [4:0] SP, EP, MemWrite, MemRead,
	output reg Ext_MemWrite, 
//	output reg [31:0] Ext_WriteData, 
	output reg [31:0] node,
//	output [31:0] WriteData,
	output MemWrite, done_out, reset,
	output  [31:0] DataAdr,
	output [8:0] cnt_out
);

reg [31:0] Ext_WriteData;
wire [31:0] WriteData;
reg done = 0;
//reg [2:0] state;
reg reset_out = 1; // 0
reg [31:0] SP = 32'd29;
reg [31:0] EP = 32'd18;
reg [31:0] Ext_DataAdr;
reg [8:0] cnt = 0;
//reg [2:0] count=0;

assign cnt_out = cnt;

assign done_out = done;
assign reset = reset_out; 

parameter IDLE=5'd0, WRITE_START_PT=5'd1,WRITE_END_PT = 5'd2, WRITE_NODE_PT = 5'd3, WRITE_CPU_DONE = 5'd4, READ_NODE = 5'd5, STOP=5'd6;
reg [2:0] state = IDLE;
reg clk_3125k = 0;

reg [2:0] counter = 0;

always @(posedge clk) begin
	if (!counter) clk_3125k = ~clk_3125k;
	counter = counter + 1'b1;
end

t2b_riscv_cpu uut (clk,reset,Ext_MemWrite,Ext_WriteData,Ext_DataAdr,MemWrite,WriteData,DataAdr,ReadData);
//navigator nav (clk,done,nodeclk,node,direction);

always @(posedge clk) begin

case (state) 

		IDLE: begin
			if (reset_out) begin

				state<=WRITE_START_PT;
				Ext_MemWrite <= 1;
			end
			else begin 
				Ext_MemWrite <= 0;
				state <= READ_NODE;
			end
		end
		
		WRITE_START_PT: begin
		if (reset_out) begin  Ext_MemWrite <= 1; Ext_WriteData <= SP; Ext_DataAdr <= 32'h02000000; state <= WRITE_END_PT; end
		else begin Ext_MemWrite = 0; state<= IDLE; end
		end
		
		WRITE_END_PT: begin
		if (reset_out) begin Ext_MemWrite <= 1; Ext_WriteData <= EP; Ext_DataAdr <= 32'h02000004; state <= WRITE_NODE_PT; end
		else begin Ext_MemWrite = 0;  state<= IDLE;  end
		end
		
		WRITE_NODE_PT: begin
		if (reset_out) begin  Ext_MemWrite <= 1; Ext_WriteData <= 0; Ext_DataAdr <= 32'h02000008; state <= WRITE_CPU_DONE; end
		else begin Ext_MemWrite <= 0;  state<= IDLE; end
		end
		
		WRITE_CPU_DONE: begin
		if (reset_out) begin Ext_WriteData <= 0; Ext_DataAdr <= 32'h0200000c; reset_out <= 0; end
		else begin state<= READ_NODE;  Ext_MemWrite <= 0; Ext_WriteData = 0; Ext_DataAdr = 0; end
		end
		
		READ_NODE: begin
		
		if (MemWrite && (!reset_out)) begin
			if (DataAdr==32'h02000008) begin
				node <= WriteData;
				if (node == EP) begin
					reset_out = 1;
				end
				cnt <= cnt + 1;
			end
		
			else if (WriteData== 32'h1 && DataAdr==32'h0200000c) begin
				done <= 1; //state <= STOP;
			end
		end
	
		end
		
		// STOP: begin
		// 	reset_out = 1;
		// end
endcase 
end
endmodule






