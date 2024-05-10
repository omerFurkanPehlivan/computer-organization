/**
 * @module n_input_gates
 * @brief Implements n-input gates with configurable gate type and number of inputs.
 *
 * The `n_input_gates` module implements n-input gates with a configurable gate type and number of inputs.
 * The supported gate types are "AND" and "OR". The number of inputs is specified by the parameter N.
 *
 * @param TYPE The gate type. Supported values are "AND" and "OR". Default is "OR".
 * @param N The number of inputs. Default is 2.
 * @param a The input signal, an array of N bits.
 * @param out The output signal.
 */
module n_input_gates #(
	parameter TYPE = "OR",
	parameter N = 2
) (
	input [N-1:0] a,
	output out
);
	supply0 gnd;
	supply1 vdd;

	generate
		case (TYPE)
			"AND": begin
				wire [N-1:0] nmos_line;

				nmos nmos1 [N-1:0] (
					nmos_line, {gnd, nmos_line[N-1:1]}, a
				);

				pmos pmos1 [N-1:0] (
					nmos_line[0], vdd, a
				);

				// inverter
				pmos pmos2 (out, vdd, nmos_line[0]);
				nmos nmos2 (out, gnd, nmos_line[0]);
			end
			"OR": begin
				wire [N-1:0] pmos_line;

				pmos pmos2 [N-1:0] (
					pmos_line, {vdd, pmos_line[N-1:1]}, a
				);
				nmos nmos1 [N-1:0] (
					pmos_line[0], gnd, a
				);

				pmos pmos3 (out, vdd, pmos_line[0]);
				nmos nmos2 (out, gnd, pmos_line[0]);
			end
			default: invalid_parameter_value error();
		endcase
	endgenerate
endmodule
