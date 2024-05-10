module DelayOr (input a, b, output out);
	parameter delay = 10;
	or #delay or_gate (out, a, b);
endmodule