module FIM(
    input clk_50M, tx_busy, en,
	 input red_in,
	 input [4:0] node_num,
	 output reg tx_en,
	 output reg [7:0] data_out,
	 output reg BPM_msg, 
	 output reg [4:0] end_node,
	 output blue, green,
	 output reg [1:0] LED_num,
	 output red,
	 output bdm_done_wire,
	 output [1:0] in_wire
);

	 //assign tx_en = 1;
	 reg [4:0] cnt = 5'd0;
	 parameter IDLE = 2'd0;
	 parameter SEND = 2'd1;
	 parameter WAIT = 2'd2;
	 parameter FIM = 2'd0;
	 parameter BPM = 2'd1;
	 parameter BDM = 2'd2;
	 reg [1:0] state = IDLE, blue_reg=0, green_reg=0,red_reg=0;
	 reg [1:0] msg_type=FIM;
	 reg [7:0] data_0, data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9,data_10;
	 reg bdm_done=0;
	 reg [1:0]in=0;

	 
	 assign blue=blue_reg;
	 assign green=green_reg;
	 assign red=red_reg;
	 assign bdm_done_wire=bdm_done;
	 assign in_wire=in;
	 
	 
	 
    always @(posedge clk_50M) begin 
	 //red_reg<=red_in;
	 
	 //if (reset) red_reg<=0; blue_reg<=0; green_reg<=0;
	 case(msg_type)
		FIM: begin
		case(state)
			IDLE: begin
			red_reg<=red_in;
				if (en) begin
					cnt <= 0;
					if (node_num==29) begin
					//FIM-ESU1-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd69; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd51;   //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd0;
					tx_en <= 1;
					state <= SEND;
					end
					else if (node_num==25) begin
					//FIM-ESU2-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd69; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd49;   //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd0;
					tx_en <= 1;
					state <= SEND;
					end
					else if (node_num==26) begin
					//FIM-ESU3-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd69; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd50;  //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd0;
					tx_en <= 1;
					state <= SEND;
					end
					
					else if (node_num==2) begin
					//FIM-CSU1-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd67; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd49;  //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd1;
					tx_en <= 1;
					state <= SEND;
					end
					
					
					else if (node_num==4) begin
					//FIM-CSU2-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd67; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd50;  //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd1;
					tx_en <= 1;
					state <= SEND;
					end
					
					
					else if (node_num==6) begin
					//FIM-CSU3-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd67; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd51;  //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd1;
					tx_en <= 1;
					state <= SEND;
					end
					
					else if (node_num==19) begin
					//FIM-RSU1-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd82; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd49; //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd2;
					tx_en <= 1;
					state <= SEND;
					end
					
					
					else if (node_num==16) begin
					//FIM-RSU2-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd82; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd50; //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd2;
					tx_en <= 1;
					state <= SEND;
					end
					
					else if (node_num==14) begin
					//FIM-RSU3-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd82; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd51;  //number
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd2;
					tx_en <= 1;
					state <= SEND;
					end
					
					else if (node_num==13) begin
					//FIM-RSU4-#
					data_0 <= 8'd70;
					data_1 <= 8'd73;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd82; //unit
					data_5 <= 8'd83;
					data_6 <= 8'd85;
					data_7 <= 8'd52;
					data_8 <= 8'd45;
					data_9 <= 8'd35;
					LED_num<=2'd2;
					tx_en <= 1;
					state <= SEND;
					end
				end
				else begin tx_en <= 0; end
			end
			SEND: begin
				if (!en) begin state <= IDLE; end
				if (!tx_busy) begin
					case (cnt)
						5'd0: begin data_out <= data_0; end
						5'd1: begin data_out <= data_0; end
						5'd2: begin data_out <= data_1; end
						5'd3: begin data_out <= data_2; end
						5'd4: begin data_out <= data_3; end
						5'd5: begin data_out <= data_4; end
						5'd6: begin data_out <= data_5; end
						5'd7: begin data_out <= data_6; end
						5'd8: begin data_out <= data_7; end
						5'd9: begin data_out <= data_8; end
						5'd10: begin data_out <= data_9; tx_en <= 0; blue_reg<=1; red_reg<=0; green_reg<=0; bdm_done<=0; state <= WAIT;end
						default: begin cnt <= 10; tx_en <= 0; end
					endcase
					cnt <= cnt + 1'b1;
				end
			end
			
			WAIT: begin
				blue_reg<=1;
				if (!en) begin state <= IDLE; msg_type<=BPM;end
				end
				
			default: begin state <= IDLE; end
		endcase
		end
		BPM: begin
			case(state)
			IDLE: begin
					cnt <= 0;
					if (node_num==22) begin
					//BPM-SU-B1-#
					data_0 <= 8'd66;
					data_1 <= 8'd80;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd83; 
					data_5 <= 8'd85;
					data_6 <= 8'd45;
					data_7 <= 8'd66;
					data_8 <= 8'd49;  //block number
					data_9 <= 8'd45;
					data_10<= 8'd35;
					BPM_msg<=1;
					end_node<=25;
					tx_en <= 1;
					state <= SEND;
					end
					
					else if (node_num==23) begin
					//BPM-SU-B3-#
					data_0 <= 8'd66;
					data_1 <= 8'd80;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd83; 
					data_5 <= 8'd85;
					data_6 <= 8'd45;
					data_7 <= 8'd66;
					data_8 <= 8'd51; //block number
					data_9 <= 8'd45;
					data_10 <= 8'd35;
					BPM_msg<=1;
					end_node<=28;
					tx_en <= 1;
					state <= SEND;
				end
				
				else if (node_num==10) begin
					//BPM-SU-B2-#
					data_0 <= 8'd66;
					data_1 <= 8'd80;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd83; 
					data_5 <= 8'd85;
					data_6 <= 8'd45;
					data_7 <= 8'd66;
					data_8 <= 8'd50;  //block number
					data_9 <= 8'd45;
					data_10<= 8'd35;
					BPM_msg<=1;
					end_node<=25;
					tx_en <= 1;
					state <= SEND;
					end
					
				else if (node_num==11) begin
					//BPM-SU-B4-#
					data_0 <= 8'd66;
					data_1 <= 8'd80;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd83; 
					data_5 <= 8'd85;
					data_6 <= 8'd45;
					data_7 <= 8'd66;
					data_8 <= 8'd52;  //block number
					data_9 <= 8'd45;
					data_10<= 8'd35;
					BPM_msg<=1;
					end_node<=25;
					tx_en <= 1;
					state <= SEND;
					end

			end
			
			SEND: begin
				//if (!en) begin state <= IDLE; end
				if (!tx_busy) begin
					case (cnt)
						5'd0: begin data_out <= data_0;  end
						5'd1: begin data_out <= data_0;  end
						5'd2: begin data_out <= data_1; end
						5'd3: begin data_out <= data_2; end
						5'd4: begin data_out <= data_3; end
						5'd5: begin data_out <= data_4; end
						5'd6: begin data_out <= data_5; end
						5'd7: begin data_out <= data_6; end
						5'd8: begin data_out <= data_7; end
						5'd9: begin data_out <= data_8; end
						5'd10: begin data_out <= data_9; end
						5'd11: begin data_out <= data_10; tx_en <= 0; state <= WAIT;end
						default: begin cnt <= 11; tx_en <= 0; end
					endcase
					cnt <= cnt + 1'b1;
				end
			end
			
			WAIT: begin
				state <= IDLE; msg_type<=BDM;
				end
				
				
			default: begin state <= IDLE; end
		endcase
    end
	 
	 		BDM: begin
			case(state)
			IDLE: begin
				if (en) begin
					cnt <= 0;				
					//BDM-SU-B1-#
					data_0 <= 8'd66;
					data_1 <= 8'd68;
					data_2 <= 8'd77;
					data_3 <= 8'd45;
					data_4 <= 8'd83; 
					data_5 <= 8'd85;
					data_6 <= 8'd45;
					data_7 <= 8'd66;
					//data_8 <= 8'd49;  //block number
					data_9 <= 8'd45;
					data_10<= 8'd35;
					tx_en <= 1;
					state <= SEND;


					
				end
				else begin tx_en <= 0; end
			end
			
			SEND: begin
				if (!en) begin state <= IDLE; end
				if (!tx_busy) begin
					case (cnt)
						5'd0: begin data_out <= data_0; end
						5'd1: begin data_out <= data_0; end
						5'd2: begin data_out <= data_1; end
						5'd3: begin data_out <= data_2; end
						5'd4: begin data_out <= data_3; end
						5'd5: begin data_out <= data_4; end
						5'd6: begin data_out <= data_5; end
						5'd7: begin data_out <= data_6; end
						5'd8: begin data_out <= data_7; end
						5'd9: begin data_out <= data_8; end
						5'd10: begin data_out <= data_9; end
						5'd11: begin data_out <= data_10; tx_en <= 0; state <= WAIT; blue_reg<=0; green_reg<=1; bdm_done<=1; in<=in+1;  end
						default: begin cnt <= 11; tx_en <= 0; end
					endcase
					cnt <= cnt + 1'b1;
				end
			end
			
			WAIT: begin
			red_reg<=1;
				if (!en) begin state <= IDLE; msg_type<=FIM;end
				end
			default: begin state <= IDLE; end
		endcase
    end
				
	 default: begin msg_type<=FIM; end
	 endcase
	 end
endmodule
  