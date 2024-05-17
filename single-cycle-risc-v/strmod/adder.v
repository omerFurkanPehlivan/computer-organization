module adder #(
	parameter TYPE = "ADDER",
	parameter WIDTH = 1
) (
	input [WIDTH-1:0] a, b,
	input cin,
	output [WIDTH-1:0] sum,
	output cout
);
	
	generate
		if (TYPE == "HALF_ADDER" && WIDTH == 1) begin
			if (WIDTH != 1) begin
				invalid_parameter_value error();
			end
			else begin
				gates #(.TYPE("XOR")) xor1 (.a(a), .b(b), .out(sum));
				gates #(.TYPE("AND")) and1 (.a(a), .b(b), .out(cout));
			end
		end
		else if (TYPE == "FULL_ADDER" && WIDTH == 1) begin
			wire sum_half, carry_half, carry_half_2;
			adder #(
				.TYPE("HALF_ADDER")
			) half_adder1 (
				.a(a),
				.b(b),
				.sum(sum_half),
				.cout(carry_half));
		
			adder #(
				.TYPE("HALF_ADDER")
			) half_adder2 (
				.a(sum_half),
				.b(cin),
				.sum(sum),
				.cout(carry_half_2));
			gates #(.TYPE("OR")) or1(.a(carry_half), .b(carry_half_2), .out(cout));
		end
		else if (TYPE == "ADDER" && WIDTH > 1) begin
			wire [WIDTH-2:0] carry_line;
			adder #(
				.TYPE("FULL_ADDER")
			) full_adder1 [WIDTH-1:0] (
				.a(a),
				.b(b),
				.cin({carry_line, cin}),
				.sum(sum),
				.cout({cout, carry_line})
			);
		end
		else begin
			invalid_parameter_value error();
		end
	endgenerate
	
endmodule