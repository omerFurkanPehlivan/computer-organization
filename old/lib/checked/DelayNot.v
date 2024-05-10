module DelayNot (input a ,output out);
	parameter delay = 10;
	not #delay not_gate (out, a);
endmodule