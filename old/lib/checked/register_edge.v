// Rising edge triggered register
module register_edge #(
	parameter WORD_SIZE = 32
) (
	input [WORD_SIZE-1:0] data_in, 
	output clk,
	output [WORD_SIZE-1:0] data_out
);	
	wire rising_edge_pulse;
	rising_edge_detector rising_edge_detector1 (
		.clk(clk),
		.out(rising_edge_pulse)
	);
	register_bit register_bit1 [WORD_SIZE-1:0] (
		.data_in(data_in),
		.en(rising_edge_pulse), 
		.data_out(data_out)
	);
endmodule