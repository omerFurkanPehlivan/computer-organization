/**
 * @module flip_flop
 * @brief This module implements a flip-flop with configurable parameters.
 *
 * The flip-flop can be configured with different types and trigger conditions.
 * It generates the flip-flop logic based on the specified parameters.
 *
 * @param TYPE The type of flip-flop. Valid options are "D".
 * @param TRIGGER The trigger condition for the flip-flop. Valid options are "RISING" and "HIGH".
 *
 * @input clk The clock signal.
 * @input d The data input signal.
 * @output q The output signal.
 * @output qbar The complement of the output signal.
 *
 * @dependencies
 * - gates.v: Contains gate modules for logic operations.
 * - latch.v: Contains latch modules for storing data.
 */
module flip_flop #(
	parameter TYPE = "D",
	parameter TRIGGER = "RISING"
) (
	input clk, d,
	output q, qbar
);	

	// Generate the flip-flop logic based on the specified TYPE
	generate
		case ({TYPE, TRIGGER})
			{"D", "HIGH"}: begin
				wire dbuf, dbar, s_inner, r_inner;
				gates #(.TYPE("NOT")) not1 (.a(d), .out(dbar));
				gates #(.TYPE("BUF")) buf1 (.a(d), .out(dbuf));
				gates #(.TYPE("AND")) and1 (.a(clk), .b(dbuf), .out(s_inner));
				gates #(.TYPE("AND")) and2 (.a(clk), .b(dbar), .out(r_inner));
				latch #(.TYPE("SR_LATCH"), .ACTIVE("HIGH")) sr_latch (.s(s_inner), .r(r_inner), .q(q), .qbar(qbar));
			end
			{"D", "RISING"}: begin
				wire clk_edge;
				edge_detector #(.TYPE("RISING"), .ACTIVE("HIGH")) edge_detector1 (.clk(clk), .pulse(clk_edge));
				flip_flop #(.TYPE("D"), .TRIGGER("HIGH")) flip_flop1 (.clk(clk_edge), .d(d), .q(q), .qbar(qbar));
			end
			default: begin
				// Throw an error for invalid configuration
				invalid_parameter_value error();
			end
		endcase
	endgenerate
endmodule
