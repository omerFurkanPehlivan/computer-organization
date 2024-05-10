module DelayNor (input a, b, output out);
	parameter delay = 10;
	nor #delay nor_gate (out, a, b);
endmodule