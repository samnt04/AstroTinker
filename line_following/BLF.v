///*
//Module BLF
//
//This Module is responsible for ensuring the bot follows the black line and detects nodes
//
//Controller design
//
//Input   :  l, c, r      : 12 bit ir sensor readings froma adc_controller
//           adc_clk      : 3125KHz clock has to be the same as adc_controller to prevent garbage values
//
//Output  :  m1            : left duty cycle 
//           m2            : right motor duty cycle 
//           node_clk      : clock toggles at every node can be used by other modules to register node event
//           node_cnt      : node number
//*/
//
////Black Line Following
module BLF(
    input [11:0] l, c, r,
	 input clk,
	 input [2:0] direction,
	 input fault,
    output wire [11:0] m1_wire, m2_wire, 	 // l and r motors
	 output reg m1_forward, m2_forward,
	 output wire node_clk
//	 output [69:0] path 
	 //output wire node_flag_wire
	 
);

	 parameter thresh = 12'd110; // 90 
	 parameter DELAY = 27'd4000000, thresh_rev = 12'd110, REV_DELAY = 27'd1000000, T_DELAY = 27'd1000000; //4000000
	 reg [11:0] prev_l, prev_c, prev_r;
	 reg t_flag = 0;
	 reg node_flag = 0;
	 reg [26:0] delay_counter = 0;
	 reg [11:0] m1 = 0;
	 reg [11:0] m2 = 0;
	 reg reverse = 0;
	 reg rev_flag = 0;
	 reg prev_reverse = 0;
//	 reg [69:0] path_reg = 0;
	 assign m1_wire = m1;
	 assign m2_wire = m2;
	 assign node_clk = node_flag;
//	 assign path = path_reg;

	 
    always @(posedge clk) begin
//	 path_reg <= 70'b00000_00001_11101_11100_11010_11011_11010_11001_11000_10100_11101_00001_00000;
	 
	 if (node_flag) begin
		delay_counter <= delay_counter + 1'b1;
		if (delay_counter == DELAY) begin
			node_flag <= 0; delay_counter <= 0;
		end
		if (delay_counter == T_DELAY) begin
			t_flag <= 0;
		end
	end
	else begin
		delay_counter <= 0;
	end
	if (r >= thresh_rev && rev_flag && (delay_counter>REV_DELAY)) begin rev_flag <= 0; end
	else if (rev_flag) begin
		delay_counter <= delay_counter + 1;
		m1 <= 12'd1000; m2 <= 12'd1000; // 2000, 2000
		m1_forward<=1; m2_forward<=0;
	end
	 else if (!rev_flag && !fault && !t_flag) begin     
		 // straight
			  if ((l <= thresh && c >= thresh) && r <= thresh) begin
					m1 <= 12'd1200; m2 <= 12'd1200; // 1800, 1800
					m1_forward<=1; m2_forward<=1;
			  end
			  // sharp left
			  else if ((l >= thresh && c <= thresh) && r <= thresh) begin
					m1 <= 0; m2 <= 12'd1200; // 0, 3000
					m1_forward<=1; m2_forward<=1;
					prev_l <= l;
					prev_c <= c;
					prev_r <= r;
			  end
			  // soft left
			  else if ((l >= thresh && c >= thresh) && r <= thresh ) begin
					m1 <= 12'd1000; m2 <= 12'd1200; // 1000, 2000
					m1_forward<=1; m2_forward<=1;
					prev_l <= l;
					prev_c <= c;
					prev_r <= r;
			  end
			  
			  // sharp right
			  else if ((l <= thresh && c <= thresh) && r >= thresh) begin
					m1 <= 12'd1200; m2 <= 0; // 3000, 0
					m1_forward<=1; m2_forward<=1;
					prev_l <= l;
					prev_c <= c;
					prev_r <= r;
			  end
			  // soft right
			  else if ((l <= thresh && c >= thresh) && r >= thresh) begin
					m1 <= 12'd1200; m2 <= 12'd1000; // 2000, 1000
					m1_forward<=1; m2_forward<=1;
					prev_l <= l;
					prev_c <= c;
					prev_r <= r;
			  end
				// node case
			  else if ((l >= thresh && c >= thresh) && r >= thresh) begin
					 if (!node_flag) begin
						 node_flag <= 1;
						 t_flag <= 1;
					end
					case(direction)
						 3'd0 : begin // straight
							  m1_forward <= 1; m2_forward <= 1;
//							  t_delay <= 27'd0; t_flag <= 1;
							  m1 <= 12'd1500; m2 <= 12'd1500; // 2000, 2000
							  end
						 3'd1 : begin // left
							  m1 <= 12'd0; m2 <= 12'd1500; // 0, 3000
							  m1_forward<=1; m2_forward<=1;
//							  t_delay <= 27'd0; t_flag <= 1;
							  prev_l <= 12'd100;
							  prev_c <= 12'd0;
							  prev_r <= 12'd0;
							  end
						 3'd2 : begin // right
							  m1 <= 12'd1500; m2 <= 12'd0; // 3000, 0
							  m1_forward<=1; m2_forward<=1;
//							  t_delay <= 27'd0; t_flag <= 1;
							  prev_l <= 12'd0;
							  prev_c <= 12'd0;
							  prev_r <= 12'd100;
							  end
						3'd3: begin // reverse
							m1 <= 12'd1000; m2 <= 12'd1000; // 2000, 2000
							m1_forward<=1; m2_forward<=0;
							rev_flag <= 1;
						end
//						3'd5 : begin // sharp right
//							  m1 <= 12'd2500; m2 <= 12'd0; // 3000, 0
//							  m1_forward<=1; m2_forward<=0;
//							  t_delay <= 27'd0; t_flag <= 1;
//							  prev_l <= 12'd0;
//							  prev_c <= 12'd0;
//							  prev_r <= 12'd100;
//						end
						 default : begin
							  m1_forward<=0; m2_forward<=0;
							  m1 <= 12'd0; m2 <= 12'd0; // stop
							  end
					endcase
					
			  end
			  else begin
					// prev turn was a sharp right
					if ((prev_l <= thresh && prev_c <= thresh) && prev_r >= thresh) begin
						m1 <= 12'd1200; m2 <= 12'd0; // 3500, 0
						m1_forward<=1; m2_forward<=1;
					end
					// prev turn was a soft right
					else if ((prev_l <= thresh && prev_c >= thresh) && prev_r >= thresh) begin
						m1 <= 12'd1200; m2 <= 12'd1000; // 2500, 500
						m1_forward<=1; m2_forward<=1;
					end
					// prev turn was a sharp left
					else if ((prev_l >= thresh && prev_c <= thresh) && prev_r <= thresh) begin
						m1 <= 12'd0; m2 <= 12'd1200; // 0, 3500
						m1_forward<=1; m2_forward<=1;
					end
					// prev turn was a soft left
					else if ((prev_l >= thresh && prev_c >= thresh) && prev_r <= thresh ) begin
						m1 <= 12'd1000; m2 <= 12'd1200; // 1000, 2500
						m1_forward<=1; m2_forward<=1;
					end
					else begin
						m1 <= 12'd500; m2 <= 12'd500;
						m1_forward<=1; m2_forward<=1;
					end
				end
		  end
//		  else begin
//				m1 <= 12'd0; m2 <= 12'd0;
//				m1_forward<=1; m2_forward<=1;
//		  end
    end
endmodule