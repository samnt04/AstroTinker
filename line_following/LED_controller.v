module LED_controller(
					input clk,red_in,blue_in,green_in,
					input [1:0] LED_num,
					output r1_wire,b1_wire,g1_wire,r2_wire,b2_wire,g2_wire,r3_wire,b3_wire,g3_wire
);



reg r1=0,r2=0,r3=0,b1=0,b2=0,b3=0,g1=0,g2=0,g3=0;
assign r1_wire=r1, b1_wire=b1, g1_wire=g1, r2_wire=r2, b2_wire=b2, g2_wire=g2, r3_wire=r3, b3_wire=b3, g3_wire=g3;
always @(posedge clk) begin

		if (LED_num==2'd1) begin
			if (red_in) begin 
				r1<=1;
				b1<=0;
				g1<=0;
			end
			
			else if (blue_in) begin 
				r1<=0;
				b1<=1;
				g1<=0;
			end
		
			else if (green_in) begin 
				r1<=0;
				g1<=1;
				b1<=0;
			end
			
		end
		
		else if (LED_num==2'd2) begin
			if (red_in) begin 
				r2<=1;
				b2<=0;
				g2<=0;
			end
			
			else if (blue_in) begin 
				r2<=0;
				b2<=1;
				g2<=0;
			end
		
			else if (green_in) begin 
				r2<=0;
				b2<=0;
				g2<=1;
			end
			
		end
			
			
		else if (LED_num==2'd3) begin
			if (red_in) begin 
				r3<=1;
				b3<=0;
				g3<=0;
				
			end
			
			else if (blue_in) begin 
				r3<=0;
				b3<=1;
				g3<=0;
			end
		
			else if (green_in) begin 
				r3<=0;
				b3<=0;
				g3<=1;
			end
			
		end
end
endmodule	
					
					