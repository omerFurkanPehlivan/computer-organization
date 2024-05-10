// Just trying to make a 500KHz clock module for now,
// I will try to make a generic one later
`timescale 1ns / 1ns

module clock #(
	parameter CLOCK_PERIOD = 2000

) (
	input rst,
	output clk_out
);
	wire not_in;

	// Mux for Reset
	mux #(
		.SELECT_BITS(1),
		.DATA_WIDTH(1)
	) mux1 (
		.data_list({1'b1, clk_out}),
		.select(rst),
		.data_out(not_in)
	);

	// Delay for Clock
	DelayNot #(
		// 20ns delay from the Mux
		.delay((CLOCK_PERIOD/2)-20)
	) not1 (
		.a(not_in),
		.out(clk_out)
	);
endmodule