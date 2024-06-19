module Patternff(
	input pattern_in, node_clk,
	output wire pattern, 
	output wire ground
);
	assign ground = 0;
	reg pattern_tmp = 0;
	assign pattern = pattern_tmp;
	always @(posedge pattern_in or posedge node_clk) begin
		if (node_clk) begin pattern_tmp <= 0; end
		else begin pattern_tmp <= 1; end
	end
endmodule

