module DelayAnd (input a, b, output out);
	parameter delay = 10;
	and #delay and_gate (out, a, b);
endmodule