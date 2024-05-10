module DelayXnor (input a, b, output out);
	parameter delay = 10;
	xnor #delay xnor_gate (out, a, b);
endmodule