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
