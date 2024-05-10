module DelayXor (input a, b, output out);
	parameter delay = 10;
	xor #delay xor_gate (out, a, b);
endmodule