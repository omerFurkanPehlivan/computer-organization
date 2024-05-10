module n_input_and #(
	parameter N = 1
) (
	input [N-1:0] a,
	output out
);
	supply0 gnd;
	supply1 vdd;
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

endmodule