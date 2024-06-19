///* Module Start_Detector
//*  
//*  Module is used to detect start message from CH
//*  Design
//*
//*  INPUT
//*   clk_50M  : 50MHz clk signal
//*   rst      : resets start register on posedge
//*   rx       : uart receive line
//*  OUTPUT
//*   start  : register telling to start or to not start
//*/
//
//module Start_Detector(
//    input clk_50M, rx_complete, 
//	 input [7:0] rx_msg,
//    output wire start
//);
//
//    reg [2:0] state = 3'd0;
//	 reg start_reg = 0;
//	 assign start = start_reg;
//    always @(posedge rx_complete) begin
//        case(state) 
//            3'd0: begin
//                // ascii for S or s
//                if (rx_msg == 8'd83 || rx_msg == 8'd115) state <= 3'd1;
//            end
//            3'd1: begin
//                // ascii for T or t
//                if (rx_msg == 8'd84 || rx_msg == 8'd116) state <= 3'd2;
//            end
//            3'd2: begin
//                // ascii for A or a
//                if (rx_msg == 8'd65 || rx_msg == 8'd97) state <= 3'd3;
//            end
//            3'd3: begin
//                // ascii for R or r
//                if (rx_msg == 8'd82 || rx_msg == 8'd114) state <= 3'd4;
//            end
//            3'd4: begin
//                // ascii for T or t
//                if (rx_msg == 8'd84 || rx_msg == 8'd116) begin
//                    state <= 3'd0; start_reg <= 1;
//                end
//            end
//        endcase
//    end
//endmodule


module Start_Detector(
    input clk, rx_complete, 
	 input [7:0] rx_msg, 
	 input bdm_done,
	 input [1:0] i,
    output wire search_red,
	 output reg [1:0] LED_num,
	 output reg [5:0] end_point,
	 output reg PBM_msg
); 
	 parameter IFM = 0, PBM = 1;
	 parameter DELAY = 31'd500000000;
    reg [2:0] IFM_state = 3'd0;
	 reg [3:0] PBM_state = 4'd0;
	 reg [1:0] units_num [0:3];
	 reg [1:0] count=0;
	 reg search_reg = 0;
	 reg IFM_cnt = 0;
	 reg msg_type = IFM;
	 reg start;
	 
	 reg ifm_done=0;
	 reg [31:0] delay_counter = 0;
	 
	 assign search_red=search_reg;
	 
initial begin
    // Assign zero to each element individually
    units_num[0] <= 2'b00;
    units_num[1] <= 2'b00;
    units_num[2] <= 2'b00;
    units_num[3] <= 2'b00;
end
	 
	 
	 
	 always @ (posedge clk) begin
	 
	 
	 if (!ifm_done) begin
		delay_counter <= delay_counter + 1'b1;
      if (delay_counter==DELAY) begin
		ifm_done<=1;
		end
	end
	else begin
			msg_type<=PBM;	start<=1;
			if (bdm_done || start) begin
			LED_num<=units_num[i];
			search_reg <= 1;
		end
		end
		

	 end  
	 
    always @(posedge rx_complete) begin
		
		case(msg_type)
			IFM: begin
			
			  case(IFM_state) 
					3'd0: begin
						 // ascii for I or i
						 if (rx_msg == 8'd73 || rx_msg == 8'd105) begin IFM_state <= 3'd1; end
					end
					3'd1: begin
						 // ascii for F or f
						 if (rx_msg == 8'd70 || rx_msg == 8'd102) begin IFM_state <= 3'd2;end
					end
					3'd2: begin
						 // ascii for M or m
						 if (rx_msg == 8'd77 || rx_msg == 8'd109) begin IFM_state <= 3'd3;end
					end
					3'd3: begin
						 // ascii for -
						 if (rx_msg == 8'd45)begin IFM_state <= 3'd4;end
					end
					3'd4: begin
					    //Unit
						 
						 // ascii for E or e
						 if (rx_msg == 8'd69 || rx_msg == 8'd101) begin
							  IFM_state <= 3'd5;
							  if(count==0) begin units_num[0]<=2'd1; end
							  else if (count==1) begin units_num[1]<=2'd1; end
							  else if (count==2) begin units_num[2]<=2'd1; end
							  else if (count==3) begin units_num[3]<=2'd1; end
							  count<=count+1;
						 end
						 
						 
						 // ascii for C or c
						 else if (rx_msg == 8'd67 || rx_msg == 8'd99) begin
							  IFM_state <= 3'd5;
							  if(count==0) begin units_num[0]<=2'd2; end
							  else if (count==1) begin units_num[1]<=2'd2; end
							  else if (count==2) begin units_num[2]<=2'd2; end
							  else if (count==3) begin units_num[3]<=2'd2; end
							   count<=count+1;
						 end
						
						 
						 // ascii for R or r
						 else if (rx_msg == 8'd82 || rx_msg == 8'd114) begin
							  IFM_state <= 3'd5;
							  if(count==0) begin units_num[0]<=2'd3; end
							  else if (count==1) begin units_num[1]<=2'd3; end
							  else if (count==2) begin units_num[2]<=2'd3; end
							  else if (count==3) begin units_num[3]<=2'd3; end
							  count<=count+1;
						 end
						 count<=count+1;
					end
					3'd5: begin
						 // ascii for U or u
						 if (rx_msg == 8'd85 || rx_msg == 8'd117) begin
							  IFM_state <= 3'd6;
						 end
					end
					3'd6: begin
						 // ascii for -
						 if (rx_msg == 8'd45) begin IFM_state <= 3'd7; end
					end
					3'd7: begin
						 // ascii for #
						 if (rx_msg == 8'd35 && !IFM_cnt) begin
							  IFM_state <= 3'd0;
							  IFM_cnt <= IFM_cnt + 1;
							  
						 end
						 else if (IFM_cnt && rx_msg == 8'd35) begin
							  IFM_cnt <= 0;
							  IFM_state <= 3'd0;
							  
							  
							  
						 end
					end
					default: IFM_state <= 3'd0;
			  endcase
		  end
		  
		  PBM: begin
		  
				  	
		


				case(PBM_state) 
					4'd0: begin
						 // ascii for  P or p
						 if (rx_msg == 8'd80 || rx_msg == 8'd112) PBM_state <= 4'd1;
					end
					4'd1: begin
						 // ascii for B or b
						 if (rx_msg == 8'd66 || rx_msg == 8'd98) PBM_state <= 4'd2;
					end
					4'd2: begin
						 // ascii for M or m
						 if (rx_msg == 8'd77 || rx_msg == 8'd109) PBM_state <= 4'd3;
					end
					4'd3: begin
						 // ascii for -
						 if (rx_msg == 8'd45) PBM_state <= 4'd4;
					end
					4'd4: begin
						 // ascii for S or s
						 if (rx_msg == 8'd83 || rx_msg == 8'd115) begin
							  PBM_state <= 4'd5;
						 end
					end
					4'd5: begin
						 // ascii for U or u
						 if (rx_msg == 8'd85 || rx_msg == 8'd117) begin
							  PBM_state <= 4'd6;
						 end
					end
					4'd6: begin
						 // ascii for -
						 if (rx_msg == 8'd45) PBM_state <= 4'd7;
					end
					4'd7: begin
						 // ascii for B or b
						 if (rx_msg == 8'd66 || rx_msg == 8'd98) begin
							  PBM_state <= 4'd8;
						 end
					end
					4'd8: begin
						 // ascii for 1
						 if (rx_msg == 8'd49) begin
							  end_point <= 5'd22;
							  PBM_state <= 4'd9;
							  
						 end
						 // ascii for 3
						 else if (rx_msg == 8'd51) begin
							  end_point <= 5'd23;
							  PBM_state <= 4'd9;
						 end
						 
						  // ascii for 2
						 else if (rx_msg == 8'd50) begin
							  end_point <= 5'd10;
							  PBM_state <= 4'd9;
						 end
						 
						  // ascii for 4
						 else if (rx_msg == 8'd52) begin
							  end_point <= 5'd11;
							  PBM_state <= 4'd9;
						 end
						 
					end
					4'd9: begin
						 // ascii for -
						 if (rx_msg == 8'd45) PBM_state <= 4'd10;
					end
					4'd10: begin
						 // ascii for #
						 if (rx_msg == 8'd35) begin
							  PBM_state <= 4'd0;
							  PBM_msg<=1;
						 end
					end
					default: PBM_state <= 4'd0;
			  endcase
		  end
		  default: msg_type <= IFM;
		endcase
    end

endmodule
