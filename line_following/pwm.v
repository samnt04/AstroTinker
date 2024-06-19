/*
Module PWM

This Module is responsible for pwm generation

PWM Module design

Input   :  clk_3125K     : 3125KHz clock
           duty_cycle    : required duty cycle 4 bit value

Output  :  pwm           : pwm signal 
*/

module PWM(
    input clk_3125K,
	 input [11:0] duty_cycle,
	 input forward,
    output reg pwm_pos, pwm_neg
);

	reg [11:0] cnt_f = 0;
	reg [11:0] cnt_b = 0;
	 
	always @(posedge clk_3125K) begin
		//cnt <= cnt + 12'd1;
		if (forward) begin
			cnt_f <= cnt_f + 12'd1;
			cnt_b <= 0;
			pwm_pos <= (cnt_f < duty_cycle) ? 1 : 0;
			pwm_neg <= 0;
		end
		else begin
			cnt_b <= cnt_b + 12'd1;
			cnt_f <= 0;
			pwm_neg <= (cnt_b < duty_cycle) ? 1:0;
			pwm_pos <= 0;
		end
	end 
endmodule
