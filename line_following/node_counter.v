// pvt submodule counter
// counter counts on any state change of node_clk
// node_cnt resets to 7 on the 2nd round of a 0-6 count
module node_counter(
    input node_clk,
    output wire [2:0] node_cnt,
	 output node_cnt_state_wire
);
    
    reg [2:0] node_cnt_reg = 3'b000;
    reg node_cnt_state = 0;
	 assign node_cnt = node_cnt_reg;
	 assign node_cnt_state_wire = node_cnt_state;
	 
    always @(posedge node_clk) begin
        node_cnt_reg <= node_cnt_reg + 1;
		  if (node_cnt_reg==6) begin
			  case(node_cnt_state) 
					1'b0: begin
							  node_cnt_reg <= 2; node_cnt_state <= 1;
					end
					1'b1: begin
							  node_cnt_reg <= 7; node_cnt_state <= 0;
					end
					default : node_cnt_reg <= 1;
			  endcase
		  end
    end
endmodule