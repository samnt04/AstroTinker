// AstroTinker Bot : Task 2A : UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Input:  clk_50M - 50 MHz clock
        rx      - UART Receiver

Output: rx_msg      - read incoming message
        rx_complete - message received flag
*/

// module declaration
module uart_rx (
  input clk_50M, rx,
  output [7:0] rx_msg_out,
  output rx_complete_out
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

////////////////////////// Add your code here

parameter ST_START=2'b00, ST_DATA=2'b01, ST_STOP=2'b10;


reg [3:0] counter = 0;
reg [8:0] duration = 1;
reg [1:0] state=ST_START;
reg [7:0] data_in=0;
reg [7:0] rx_msg=0;
reg rx_complete=0;
reg rx_flag = 1;

assign rx_msg_out = rx_msg;
assign rx_complete_out = rx_complete;

always @(posedge clk_50M) begin
		case(state)
		
			ST_START: begin
				
//				if (rx == 0) begin
//					rx_complete<=0;
//					duration <= duration + 1'b1;
//					if (duration == 9'd433) begin
//						duration<=1; //1
//						data_in <= 0;
//						state <= ST_DATA;
//					end
//				end
				if (!rx) begin
					rx_flag <= 0;
				end
				if (!rx_flag) begin
					rx_complete<=0;
					duration <= duration + 1'b1;
					if (duration == 9'd432) begin
						duration<=1; //1
						data_in <= 0;
						state <= ST_DATA;
						rx_flag <= 1;
					end
				end
				end
		
			ST_DATA: begin
				duration <= duration + 1'b1;
				
				
				if (counter == 4'd8) begin 
					duration<=1;
					counter <= 0;
					state <= ST_STOP;
					rx_msg<=data_in;
				end
				
				else if (duration >= 9'd217) begin
				 if (duration == 9'd217) begin data_in[counter]<=rx; end
				 else if (duration >= 9'd433) begin // 432
					counter <= counter + 1;
					duration <= 1;
					end
				end			
			
			end
			
			
			ST_STOP: begin
				duration <= duration + 1'b1;
				if (duration == 9'd217) begin // 432
				rx_complete<=1;
				duration<=1;
				state <= ST_START;
				end

				
			end
				
				
	  default: state <= ST_START;
    endcase
end
endmodule