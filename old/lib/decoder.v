// Renaming WIDTH to ADDR_WIDTH or INPUT_WIDTH would be better,
// but need to change its parent modules as well.
module decoder #(
	parameter WIDTH = 1
) (
	input [WIDTH-1:0] a, 
	input en, 
	output [2**WIDTH-1:0] out
);
	generate
		if (WIDTH > 1) begin
			wire b_bar, en_low, en_high;
			//wire b = a[WIDTH-1];
			DelayNot not1 (.a(a[WIDTH-1]), .out(b_bar));
			DelayAnd and1 (.a(b_bar), .b(en), .out(en_low));
			DelayAnd and2 (.a(a[WIDTH-1]), .b(en), .out(en_high));
			decoder #(.WIDTH(WIDTH - 1)) decoder_low (.a(a[WIDTH-2:0]), .en(en_low), .out(out[2**(WIDTH-1)-1:0]));
			decoder #(.WIDTH(WIDTH - 1)) decoder_high (.a(a[WIDTH-2:0]), .en(en_high), .out(out[2**WIDTH-1:2**(WIDTH-1)]));
		end
		else if (WIDTH == 1) begin
			wire a_bar;
			DelayNot not1 (.a(a), .out(a_bar));
			DelayAnd and_low (.a(a_bar), .b(en), .out(out[0]));
			DelayAnd and_high (.a(a), .b(en), .out(out[1]));
		end
	endgenerate
endmodule