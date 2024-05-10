module DelayBuf (input a, output out);
	parameter delay = 10;
	buf #delay buf_gate (out, a);
endmodule