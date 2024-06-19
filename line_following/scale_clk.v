/*
* Module Scale_CLK
* Module that scales 50MHz clock signal to 3.125MHz, 1MHz and 195KHz
* 
* Input
*  clk_50M  : 50 MHz input signal
* Output
*  clk_1M   : 1 MHz output
*  clk_195K : 1KHz output
*/
module scale_clk (
    input clk_50M,
    output reg clk_3125KHz
);

initial begin
    clk_3125KHz = 0;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [2:0] counter =0;

always @(posedge clk_50M) begin
	if(!counter) clk_3125KHz = ~clk_3125KHz;
	counter = counter +1'b1;
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule

