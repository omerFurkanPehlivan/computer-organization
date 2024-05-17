module adder #(
	parameter TYPE = "ADDER",
	parameter WIDTH = 1
) (
	input [WIDTH-1:0] a, b,
	input cin,
	output [WIDTH-1:0] sum,
	output cout
);
	
	generate
		if (TYPE == "HALF_ADDER" && WIDTH == 1) begin
			if (WIDTH != 1) begin
				invalid_parameter_value error();
			end
			else begin
				gates #(.TYPE("XOR")) xor1 (.a(a), .b(b), .out(sum));
				gates #(.TYPE("AND")) and1 (.a(a), .b(b), .out(cout));
			end
		end
		else if (TYPE == "FULL_ADDER" && WIDTH == 1) begin
			else begin
				wire sum_half, carry_half, carry_half_2;
				adder #(
					.TYPE("HALF_ADDER")
				) half_adder1 (
					.a(a),
					.b(b),
					.sum(sum_half),
					.cout(carry_half));
			
				adder #(
					.TYPE("HALF_ADDER")
				) half_adder2 (
					.a(sum_half),
					.b(cin),
					.sum(sum),
					.cout(carry_half_2));
				gates #(.TYPE("OR")) or1(.a(carry_half), .b(carry_half_2), .out(cout));
			end
		end
		else if (TYPE == "ADDER" && WIDTH > 1) begin
			wire [WIDTH-2:0] carry_line;
			adder #(
				.TYPE("FULL_ADDER")
			) full_adder1 [WIDTH-1:0] (
				.a(a),
				.b(b),
				.cin({carry_line, cin}),
				.sum(sum),
				.cout({cout, carry_line})
			);
		end
		else begin
			invalid_parameter_value error();
		end
	endgenerate
	
endmodule/**
 * Module: gates
 * Description: This module implements various logic gates based on the selected TYPE parameter.
 *              The gates include AND, OR, NAND, NOR, XOR, XNOR, NOT, BUF, and BUFIF1.
 *              The output of the selected gate is determined by the inputs 'a' and 'b'.
 *              The DELAY parameter specifies the delay in the gate.
 *
 * Parameters:
 *   - TYPE: Specifies the type of gate to be instantiated. Valid values are "AND", "OR", "NAND", "NOR", "XOR", "XNOR", "NOT", "BUF", and "BUFIF1".
 *   - DELAY: Specifies the delay in the gate.
 *
 * Inputs:
 *   - a: Input signal 'a' to the gate.
 *   - b: Input signal 'b' to the gate.
 *
 * Outputs:
 *   - out: Output signal of the selected gate.
 *
 * Instantiated Gates:
 *   - and_gate: AND gate instantiated when TYPE is "AND".
 *   - or_gate: OR gate instantiated when TYPE is "OR".
 *   - nand_gate: NAND gate instantiated when TYPE is "NAND".
 *   - nor_gate: NOR gate instantiated when TYPE is "NOR".
 *   - xor_gate: XOR gate instantiated when TYPE is "XOR".
 *   - xnor_gate: XNOR gate instantiated when TYPE is "XNOR".
 *   - not_gate: NOT gate instantiated when TYPE is "NOT".
 *   - buf_gate: BUF gate instantiated when TYPE is "BUF".
 *   - bufif1_gate: BUFIF1 gate instantiated when TYPE is "BUFIF1".
 *
 * Usage Example:
 *   gates #(TYPE = "AND", DELAY = 10) my_and_gate (.a(in1), .b(in2), .out(out));
 */
 
`timescale 1ns/1ns

module gates #(
	parameter TYPE = "AND",
	parameter DELAY = 10
)  (
	input a, b,
	output out
);

	generate
		case (TYPE)
			"AND": and #DELAY and_gate (out, a, b);
			"OR": or #DELAY or_gate (out, a, b);
			"NAND": nand #DELAY nand_gate (out, a, b);
			"NOR": nor #DELAY nor_gate (out, a, b);
			"XOR": xor #DELAY xor_gate (out, a, b);
			"XNOR": xnor #DELAY xnor_gate (out, a, b);
			"NOT": not #DELAY not_gate (out, a);
			"BUF": buf #DELAY buf_gate (out, a);
			"BUFIF1": bufif1 #DELAY bufif1_gate (out, a, b);
			default: invalid_parameter_value_gates_type type();
		endcase
	endgenerate
endmodule