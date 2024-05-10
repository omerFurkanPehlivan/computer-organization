/**
 * @module register
 * @brief This module represents a register with configurable trigger and word size.
 *
 * The register module takes an input data_in and stores it in a flip-flop. The trigger type can be set to either "LEVEL" or "EDGE".
 * The enable signal is driven by an AND gate with the clock signal.
 * If the trigger type is "LEVEL", the output of the AND gate is directly connected to the enable_inner signal.
 * If the trigger type is "EDGE", an edge detector is used to detect rising edges of the enable signal, and the output of the edge detector is connected to the enable_inner signal.
 * The output data_out represents the stored value in the register.
 *
 * @param TRIGGER The trigger type for the register. Valid values are "LEVEL" and "EDGE". Default is "LEVEL".
 * @param WORD_SIZE The word size of the register. Default is 1.
 *
 * @input data_in The input data to be stored in the register.
 * @input enable The enable signal for the register.
 * @input clk The clock signal for the register.
 * @output data_out The output data stored in the register.
 */
module register #(
	parameter TRIGGER = "LEVEL",
	parameter WORD_SIZE = 1
) (
	input [WORD_SIZE-1:0] data_in, 
	input enable, clk,
	output [WORD_SIZE-1:0] data_out
);
	generate
			wire enable_inner;
			case(TRIGGER)
				"LEVEL": begin
					gates #(
						.TYPE("AND")
					) and1 (
						.a(enable),
						.b(clk),
						.out(enable_inner)
					);
				end
				"EDGE": begin
					wire enable_clock;
					gates #(
						.TYPE("AND")
					) and1 (
						.a(enable),
						.b(clk),
						.out(enable_clock)
					);

					edge_detector #(
						.TYPE("RISING"),
						.ACTIVE("HIGH")
					) rising_edge_detector1 (
						.clk(enable_clock),
						.pulse(enable_inner)
					);
				end
				default: begin
					invalid_parameter_value error();
				end
			endcase
			flip_flop #(
				.TYPE("D"),
				.TRIGGER("HIGH")
			) flip_flop1 [WORD_SIZE-1:0] (
				.d(data_in),
				.clk(enable_inner),
				.q(data_out)
			);
	endgenerate
endmodule
