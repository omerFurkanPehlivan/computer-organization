/**
 * @module edge_detector
 * @brief This module implements an edge detector circuit.
 *
 * The edge detector circuit generates a pulse signal whenever there is a rising or falling edge on the input clock signal.
 * The type of edge detection (rising, falling, or both) and the active level (high or low) can be configured using parameters.
 *
 * @param TYPE    The type of edge detection. Possible values are "RISING", "FALLING", or "BOTH".
 * @param ACTIVE  The active level of the pulse signal. Possible values are "HIGH" or "LOW".
 * @param clk     The input clock signal.
 * @param pulse   The output pulse signal indicating the detected edge.
 *
 * @note This module uses internal wires and delay elements to generate the edge detection logic based on the specified parameters.
 *       The output pulse signal is generated based on the specified TYPE and ACTIVE level.
 *
 * @dependencies
 * This module depends on the following modules:
 * - gates: This module provides gate primitives such as NOT, AND, NAND, OR, NOR, XOR, and XNOR.
 */
module edge_detector #(
	parameter TYPE = "RISING",
	parameter ACTIVE = "HIGH"
) (
	input clk,
	output pulse
);
	// Declare the internal wires
	wire /*net1, net2,*/ net3;

	// Add delay elements to generate the edge detection logic
	/*gates #(.TYPE("NOT")) not1 (.a(clk), .out(net1));
	gates #(.TYPE("NOT")) not2 (.a(net1), .out(net2));
	gates #(.TYPE("NOT")) not3 (.a(net2), .out(net3));*/
	
	// Pulse width = 1 delay of not gate (10ns)
	gates #(.TYPE("NOT")) not3 (.a(clk), .out(net3));

	// Generate the edge detection logic based on the specified TYPE
	generate
		case ({TYPE, ACTIVE})
			{"RISING", "HIGH"}: begin
				gates #(.TYPE("AND")) and1 (.a(clk), .b(net3), .out(pulse));
			end
			{"RISING", "LOW"}: begin
				gates #(.TYPE("NAND")) nand1 (.a(clk), .b(net3), .out(pulse));
			end
			{"FALLING", "HIGH"}: begin
				gates #(.TYPE("NOR")) nor1 (.a(clk), .b(net3), .out(pulse));
			end
			{"FALLING", "LOW"}: begin
				gates #(.TYPE("OR")) or2 (.a(clk), .b(net3), .out(pulse));
			end
			{"BOTH", "HIGH"}: begin
				gates #(.TYPE("XNOR")) xnor1 (.a(clk), .b(net3), .out(pulse));
			end
			{"BOTH", "LOW"}: begin
				gates #(.TYPE("XOR")) xor1 (.a(clk), .b(net3), .out(pulse));
			end
			default: begin
				// Throw an error for invalid configuration
				invalid_parameter_value error();
			end
		endcase
	endgenerate
endmodule