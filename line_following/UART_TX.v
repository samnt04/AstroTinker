//	/*
//Module UART Transmitter
//
//Input:  clk_50M - 50 MHz clock
//        data    - 8-bit data line to transmit
//Output: tx      - UART Transmission Line
//*/
//
module UART_TX(
    input  clk_50M, tx_en,
    input  [7:0] data,
    output reg tx, tx_busy
);

parameter ST_IDLE = 2'b00, ST_START = 2'b01, ST_DATA = 2'b10, ST_STOP = 2'b11;

reg [3:0] counter = 0;
reg [8:0] duration = 0;  // duration of 1 bit is 433 clock cycles
reg [1:0] state = ST_IDLE; 
reg [7:0] data_in=0;

always @(posedge clk_50M) begin

	 if (state != ST_IDLE) begin tx_busy <= 1; end
	 else begin tx_busy <= 0; end
		case(state)
	// Idle state checks if the data is available
       ST_IDLE: begin
            if (tx_en) begin
                state <= ST_START;
                tx <= 0;
                duration <= 1;
            end
            else begin
                tx <= 1;
                duration <= 0;
					 end
       end

      ST_START: begin
          duration <= duration + 1'b1;
          data_in <= data;
          if (duration == 433) begin
            state <= ST_DATA;
            duration <= 1;
            tx <= data_in[counter];
          end
      end

      ST_DATA: begin
          duration <= duration + 1'b1;
	      // If counter == 8 it implies that 8 bits have been sent and now a stop bit must be sent
          if (counter == 4'd8) begin
              tx <= 1;
              duration <= 1;
              counter <= 0;
              state <= ST_STOP;
          end
          else begin
		// Data is fed in serially to the receiver
              tx <= data_in[counter];
          end
          if (duration == 9'd432) begin 
		// The counter is incremented for each data bit
              counter <= counter+1;
              duration <= 0;
          end
      end

      ST_STOP: begin
          duration <= duration + 1'b1;
	      // Finally a stop bit is sent to finish the transmission
          if (duration == 9'd433) begin
              state <= ST_IDLE;
          end
      end
      default: 
          state <= ST_IDLE;
  endcase
end
endmodule

