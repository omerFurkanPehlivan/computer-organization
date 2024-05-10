/**
 * @module latch
 * @brief This module implements a latch with configurable type and active level.
 *
 * The latch module supports one type of latch at the moment: SR latch. The type of latch is determined by the `TYPE` parameter.
 * The active level of the latch can be either "HIGH" or "LOW" and is determined by the `ACTIVE` parameter.
 *
 * @param TYPE The type of latch. Valid values are "SR_LATCH".
 * @param ACTIVE The active level of the latch. Valid values are "HIGH" and "LOW".
 *
 * @input s The set input of the latch.
 * @input r The reset input of the latch.
 * @output q The output of the latch.
 * @output qbar The complement output of the latch.
 *
 * @description
 * The latch module generates the logic for the specified type and active level of the latch.
 * If the `TYPE` parameter is not set to a valid value, an error is thrown.
 * The SR latch logic is generated based on the specified active level.
 * If the active level is "HIGH", the SR latch is implemented using NOR gates.
 * If the active level is "LOW", the SR latch is implemented using NAND gates.
 * The D latch logic is generated based on the specified active level.
 * If the active level is "HIGH", the D latch is implemented using AND and OR gates.
 * If the active level is "LOW", the D latch is implemented using NAND and NOR gates.
 *
 * @example
 * 	Example usage of the latch module:
 * latch #(.TYPE("SR_LATCH"), .ACTIVE("HIGH")) sr_latch (.s(s), .r(r), .q(q), .qbar(qbar));
 */
module latch #(
	parameter TYPE = "SR_LATCH",
	parameter ACTIVE = "HIGH"
) (
	input s, r,
	output q, qbar
);

	generate
		if (TYPE != "SR_LATCH") 
			invalid_parameter_value error();
			
			// Generate the SR latch logic based on the specified ACTIVE
		case (ACTIVE)
			"HIGH": begin
				gates #(.TYPE("NOR")) nor1 (.a(r), .b(qbar), .out(q));
				gates #(.TYPE("NOR")) nor2 (.a(s), .b(q), .out(qbar));
			end
			"LOW": begin
				gates #(.TYPE("NAND")) nand1 (.a(r), .b(q), .out(qbar));
				gates #(.TYPE("NAND")) nand2 (.a(s), .b(qbar), .out(q));
			end
				
			default: begin
				// Throw an error for invalid configuration
				invalid_parameter_value error();
			end
		endcase
	endgenerate
endmodule
