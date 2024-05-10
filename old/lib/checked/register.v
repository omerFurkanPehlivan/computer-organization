// High Level Triggered Register
module register #(
	parameter WORD_SIZE = 32
) (
	input [WORD_SIZE-1:0] data_in, 
	input write_enable, enable,
	output [WORD_SIZE-1:0] data_out
);	
	wire wen_en;
	DelayAnd and1 (.a(enable), .b(write_enable), .out(wen_en));
	register_bit register_bit1 [WORD_SIZE-1:0] (
		.data_in(data_in),
		.en(wen_en), 
		.data_out(data_out)
	);
endmodule