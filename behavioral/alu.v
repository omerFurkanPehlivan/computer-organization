module alu (
	input [31:0] a, b,
	input [2:0] alu_control,
	output [31:0] result
	output cout, zero

);
	always @(*) begin
		cout = 0;
		case (alu_op)
			3'b000: {cout, result} = a + b + cin;
			3'b001: {cout, result} = a + (~b) + cin;
			3'b010: result = a & b;
			3'b011: result = a | b;
			3'b101: result = (a < b);
			default: result = {32{1'bx}};
		endcase
		zero = (result == 32'h0);
	end