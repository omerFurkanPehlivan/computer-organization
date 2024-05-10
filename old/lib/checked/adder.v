module adder #(
	parameter WIDTH = 1
) (
	input [WIDTH-1:0] a, b,
	input cin,
	output [WIDTH-1:0] sum,
	output cout
);
	wire [WIDTH-2:0] carry_line;
	full_adder full_adder1 [WIDTH-1:0] (
		.a(a), .b(b), .cin({carry_line, cin}), .sum(sum), .cout({cout, carry_line})
	);
	
endmodule