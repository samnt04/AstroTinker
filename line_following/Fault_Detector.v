module Fault_Detector(
    input d_val,
    input rst,
    output reg pattern,
	 output wire ground// Define output port patter
);
	 // State Machine Parameters
	 /*        _           _
	 * |        ||        |__
	 * ST_ZERO  ST_ONE   ST_TWO   ST_THREE  ST_ZERO
	 */
	assign ground=0;
	 
	 // state and whether distance is above threshold or not
	 reg detected = 0;
	 reg confirmed = 0;
	 
	always @(d_val, rst) begin
		// reset condition
//		if (rst) begin
//			pattern <= 0;
//		end
		if (d_val && (!pattern) && (!detected)) begin
			detected <= 1;
		end
		else if ((!d_val) && detected && (!pattern)) begin
			confirmed <= 1;
		end
		else if (d_val && detected && confirmed) begin
			pattern <= 1;
		end
		else if ((!d_val) && detected && confirmed) begin 
			detected <= 0;
			confirmed <= 0;
		end
		else begin
			pattern <= 0;
		end
	end
endmodule