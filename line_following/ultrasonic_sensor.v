module ultrasonic_sensor(
	input clk_50M, echo,
	output reg trigger,
	output reg d_val,
	output reg rst
);

parameter ST_IDLE = 2'b00, ST_TRIGGER = 2'b01, ST_ECHO_WAIT = 2'b10, ST_COUNT = 2'b11;
parameter THRESH = 26'd20000; // 10000 worked orginally
reg [1:0] state = ST_IDLE;
reg [25:0] cnt = 1;


always @(posedge clk_50M) begin
		rst<=0;
		if(state == ST_IDLE) begin
			trigger <= 0;
			cnt <= cnt + 1'b1;
			if (cnt == 26'd7500000) begin
				cnt <= 1;
				state = ST_TRIGGER;
			end
		end
		else if (state == ST_TRIGGER) begin
			cnt <= cnt + 1'b1;
			trigger<=1;
			if (cnt == 26'd500) begin
				cnt <= 1;
				trigger<=0;
				state <= ST_ECHO_WAIT;
			end
		end
		else if(state == ST_ECHO_WAIT) begin
			if (echo) state <= ST_COUNT;
		end
		else if (state == ST_COUNT) begin
			cnt <= cnt + 1'b1;
			if (!echo) begin
				if (cnt <= THRESH) d_val <= 1;
				else d_val <= 0;
				cnt<=1;
				state <= ST_IDLE;
			end
		end
		else state<=ST_IDLE;	
end
endmodule