module n_input_or #(parameter N = 2) (input [N-1:0] a, output out);
	//assign out = |a;
	wire [N-1:0] pmos_line;
	supply1 vdd;
	supply0 gnd;
	
	pmos pmos1 (pmos_line[N-1], vdd, a[N-1]);
	pmos pmos2 [N-2:0] (pmos_line[N-2:0], pmos_line[N-1:1], a[N-2:0]);

	nmos nmos1 [N-1:0] (pmos_line[0], gnd, a);

	pmos pmos3 (out, vdd, pmos_line[0]);
	nmos nmos2 (out, gnd, pmos_line[0]);
endmodule