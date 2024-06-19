module dummy(
		input clk,
		input [4:0] prev_node, curr_node, next_node,
		output reg [2:0] direction,
//		output [9:0] index_p, index_c, index_n,
//		output [3:0] orientation_x, orientation_y, direction_x, direction_y,
		output reg [2:0] state
);
//                   29   28   27   26   25   24   23   22   21   20   19   18   17   16   15   14   13   12   11   10   9    8    7    6    5    4    3    2    1    0

parameter x = 120'b 0001_0001_0010_0010_0011_0011_0000_0000_0000_0001_0010_0011_0010_0011_1110_1101_1101_1110_0000_0000_0000_1111_1101_1101_1110_1110_1111_1111_0000_0000;
parameter y = 120'b 0001_0000_0001_0000_0000_0011_0100_0010_0011_0011_0101_0101_0110_0110_0110_0110_0101_0101_0100_0010_0011_0011_0011_0000_0001_0000_0000_0001_0001_0000;

wire [3:0] orientation_x, orientation_y, direction_x, direction_y;
wire [9:0] index_p, index_c, index_n;

 assign index_p = prev_node*4;
 assign index_c = curr_node*4;
 assign index_n = next_node*4;
 
 assign orientation_x = x[index_c +: 4] - x[index_p +: 4];
 assign orientation_y = y[index_c +: 4] - y[index_p +: 4];
 assign direction_x = x[index_n +: 4] - x[index_c +: 4];
 assign direction_y = y[index_n +: 4] - y[index_c +: 4];
 
 
 always @(clk) begin
 
	 if (!orientation_y && (orientation_x < 7 && orientation_x > 0)) begin  // north
			if (direction_y > 0 && direction_y < 7) begin
				direction <= 3'd1;  // left
			end
			else if (direction_y > 12) begin
				direction <= 3'd2;  //right
			end
			else if (direction_x > 12) begin
				direction <= 3'd3;  // reverse
			end
			else begin
				direction <= 3'd0;
			end
			state<= 1;
	 end
	 else if (!orientation_y && (orientation_x > 12)) begin  // south
			if (direction_y>0 && direction_y<7) begin
				direction <= 3'd2;  // right
			end
			else if (direction_y > 12) begin
				direction <= 3'd1;  //left
			end
			else if (direction_x>0 && direction_x<7) begin
				direction <= 3'd3;  // reverse
			end
			else begin
				direction <= 3'd0;
			end
			state <= 2;
	 end
	 else if (!orientation_x && (orientation_y>0 && orientation_y<7)) begin //east
			if (direction_x>0 && direction_x<7) begin
				direction <= 3'd2; //right
			end
			else if (direction_x > 12) begin
				direction <= 3'd1; //left
			end
			else if (direction_y > 12) begin
				direction <= 3'd3;  // reverse
			end
			else begin
				direction <= 3'd0;
			end
			state <= 3;
	 end
	 else if (!orientation_x && (orientation_y > 12)) begin //west
			if (direction_x>0 && direction_x<7) begin
				direction <= 3'd1; //left 
			end
			else if (direction_x > 12) begin
				direction <= 3'd2; //right
			end
			else if (direction_y>0 && direction_y<7) begin
				direction <= 3'd3;  // reverse
			end
			else begin
				direction <= 3'd0;
			end
			state <= 4;
	 end
	 else begin
		direction <= 3'd0;
		state <= 5;
	 end

end
endmodule