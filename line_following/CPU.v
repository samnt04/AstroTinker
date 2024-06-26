module CPU(
		input clk, FI, new_path,
		output wire [69:0] path_out,
		output flag_out
);

reg count = 0;
reg flag = 0;
reg [69:0] path = 0;
reg [1:0] cnt = 0;

assign path_out = path;
assign flag_out = flag;

always @(posedge clk) begin
//		count <= count + 1;
//		case(count)
//			0: begin //      0     1     29    28    26    27   26    25    24    20    29     1     0
//				path <= 70'b00000_00001_11101_11100_11010_11011_11010_11001_11000_10100_11101_00001_00000;
//			end
//			1: begin //      0     1     2     8     7     6     4     5     4     3     2     1     0     1
//				path <= 70'b00000_00001_00010_01000_00111_00110_00100_00101_00100_00011_00010_00001_00000_00001;
//			end
//			2: begin //      0     1     29    20    19    18    16    17    16    14    15    14   13    12     8     2     1     0
//				path <= 70'b00000_00001_11101_10100_10011_10010_10000_10001_10000_01110_01111_01110_01101_01100_01000_00010_00001_00000;
//			end
//			default: begin path <= 0; end
//		endcase
		case(count)
			0: begin //      0     1     29    28    26    27   26    25    24    20    29     1     0
//				path <= 70'b00000_00001_11101_11100_11010_11011_11010_11001_11000_10100_11101_00001_00000; 
				if (cnt==0) begin
				//     				0     1     2     3     4     5     4     6     7     8     2     1     0   
				path <= 70'b00000_00001_00010_00011_00100_00101_00100_00110_00111_01000_00010_00001_00000;
				cnt <= cnt +1;
				end
				else if (cnt==2) begin
					cnt <= cnt + 1;   
			 //                  12     19     18   16    17    16   14   15   14     13    12     8     7     6     7				
						path <= 70'b01010_10011_10010_10000_10001_10000_01110_01111_01110_01101_01100_01000_00111_00110_00111;
				end
				if (FI) begin count <= 1; flag <= 1; end
			end
			1: begin //     25    24    20    21    22    21    20    24    25
//				path <= 70'b11001_11000_10100_10101_10110_10101_10100_11000_11001;
				if (cnt==1) begin
				//            6     7     8     9     10    9     8     7     6     7
				path <= 70'b00110_00111_01000_01001_01010_01001_01000_00111_00110_00111;
				end
				else if (cnt == 3) begin
//                        13     12     8     9   11  9    8   11   12     13
				path <= 70'b01101_01100_01000_01001_01011_01001_01000_01011_01100_01101;
				end
				flag <= 0;
				if (new_path) begin count <= 0; end
			end
		endcase
end
endmodule