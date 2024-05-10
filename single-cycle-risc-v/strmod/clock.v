/**
 * @file clock.v
 * @brief This module implements a clock generator with a reset signal.
 *
 * The clock module generates a clock signal with a specified period. It also includes a reset signal
 * that can be used to reset the clock. The clock signal is generated using a mux and a delay gate.
 *
 * @param CLOCK_PERIOD The period of the clock signal in nanoseconds. Default value is 2000 ns.
 * @param rst The reset signal. When asserted, the clock signal is reset.
 * @param clk_out The generated clock signal.
 *
 * @note This module requires the `mux` and `gates` modules to be instantiated.
 */

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
	gates #(
		.TYPE("NOT"),
		// 20ns delay from the Mux
		.DELAY((CLOCK_PERIOD/2)-20)
	) not1 (
		.a(not_in),
		.out(clk_out)
	);
endmodule