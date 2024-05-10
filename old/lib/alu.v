module alu #(
	parameter WIDTH = 32
)(
	input [WIDTH-1:0] a, b,
	input [2:0] alu_control,
	output [WIDTH-1:0] result,
	output carry, zero, overflow
);

	wire [WIDTH-1:0] b_bar, b_mux,
		sum, and_result, or_result,
		zero_extended_set_if_less_than;
	wire alu_control_1_bar,
		overflow_xor, overflow_3_xnor, overflow_xor_2,
		set_if_less_than;


	// Adder - Subtractor / Carry
	DelayNot not1 [WIDTH-1:0] (.a(b), .out(b_bar));
	mux #(.DATA_WIDTH(WIDTH), .SELECT_BITS(1)) mux1 (
		.data_list({b_bar, b}),
		.select(alu_control[0]),
		.data_out(b_mux)
	);
	adder #(.WIDTH(WIDTH)) adder1 (
		.a(a),
		.b(b_mux),
		.cin(alu_control[0]),
		.sum(sum),
		.cout(carry)
	);

	// AND
	DelayAnd and1 [WIDTH-1:0] (.a(a), .b(b), .out(and_result));

	// OR
	DelayOr or1 [WIDTH-1:0] (.a(a), .b(b), .out(or_result));

	// I'm not sure if this is the correct way to implement the following:
	// Set If Less Than
	// Overflow
	DelayNot not2 (.a(alu_control[1]), .out(alu_control_1_bar));
	DelayXor xor1 (.a(sum[WIDTH-1]), .b(a[WIDTH-1]), .out(overflow_xor));
	// 3 input XOR
	DelayXor xor2 (.a(a[WIDTH-1]), .b(b[WIDTH-1]), .out(overflow_xor_2));
	DelayXnor xnor1 (.a(overflow_xor_2), .b(alu_control[0]), .out(overflow_3_xnor));
	// Overflow
	n_input_and #(3) and2 (
		.a({overflow_3_xnor, overflow_xor, alu_control_1_bar}), 
		.out(overflow));
	// Set If Less Than
	DelayXor xor3 (.a(sum[WIDTH-1]), .b(overflow), .out(set_if_less_than));
	// Extend Set If Less Than
	

	/*
	DelayXor xor1 (.a(carry), .b(cn_1), .out(overflow));
	DelayXor xor2 (.a(overflow), .b(sum[WIDTH-1]), .out(set_if_less_than));
	*/

	zero_extender #(.INPUT_WIDTH(1), .OUTPUT_WIDTH(WIDTH)) zero_extender1(
		.data_in(set_if_less_than),
		.data_out(zero_extended_set_if_less_than)
	);
	

	// MUX
	mux #(.DATA_WIDTH(WIDTH), .SELECT_BITS(3)) mux2 (
		.data_list({
			{2*WIDTH{1'b0}},
			zero_extended_set_if_less_than,
			{WIDTH{1'b0}},
			or_result,
			and_result,
			sum,
			sum}),
		.select(alu_control[2:0]),
		.data_out(result)
	);

	// Zero
	wire zero_bar;
	n_input_or #(WIDTH) or2 (.a(result), .out(zero_bar));
	DelayNot not3 (.a(zero_bar), .out(zero));
endmodule