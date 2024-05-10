module DelayNand (input a, b, output out);
	parameter delay = 10;
	nand #delay nand_gate (out, a, b);
endmodule