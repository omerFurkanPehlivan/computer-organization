module DelayBufIf1 (input a, en, output out);
	parameter delay = 10;
	bufif1 #delay bufif1_gate (out, a, en);
endmodule