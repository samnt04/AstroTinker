module path_controller(
	input node_clk,
	input [69:0] path,
	input count,
	output [4:0] prev_node_out, curr_node_out, next_node_out,
	output reg new_path
);

	reg [4:0] prev_node = 0;
 	reg [4:0] curr_node = 0; 
	reg [4:0] next_node = 0;
	reg [69:0] cnt = 0;
	reg prev_count = 0;
	
	assign prev_node_out = prev_node;
	assign curr_node_out = curr_node;
	assign next_node_out = next_node;
	
always @(posedge node_clk or posedge count) begin
		if (count) begin cnt <= 0; end
		else begin
			cnt <= cnt + 70'd5;
			next_node <= {path[cnt+14], path[cnt+13], path[cnt+12], path[cnt+11], path[cnt+10]};
			curr_node <= {path[cnt+9], path[cnt+8], path[cnt+7], path[cnt+6], path[cnt+5]};
			prev_node <= {path[cnt+4], path[cnt+3], path[cnt+2], path[cnt+1], path[cnt]};		
			if (next_node==6) begin
				new_path<=1;
			end
			else begin new_path <= 0;
		end	
		prev_count <= count;
		end
end
endmodule