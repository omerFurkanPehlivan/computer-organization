module memory_word #(
	parameter WORD_SIZE = 8
) (
	input [WORD_SIZE-1:0] data_in, 
	input clk, enable,
	output [WORD_SIZE-1:0] data_out
);	
	wire write_enable_clk;
	DelayAnd and1 (.a(enable), .b(clk), .out(write_enable_clk));
	memory_bit memory_bit1 [WORD_SIZE-1:0] (
		.data_in(data_in), 
		.clk(write_enable_clk), 
		.read_enable(enable),
		.data_out(data_out)
	);
endmodule