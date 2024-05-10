module half_adder(
	input a, b,
	output sum,carry
);
    DelayXor xor1(.a(a), .b(b), .out(sum));
    DelayAnd and1(.a(a), .b(b), .out(carry));
endmodule