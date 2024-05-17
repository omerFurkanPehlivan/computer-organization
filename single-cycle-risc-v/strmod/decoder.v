// Works well but there are some artifacts in the output
// when enable is falling

module decoder #(
	parameter ADDR_WIDTH = 1
) (
	input [ADDR_WIDTH-1:0] a,
	input en,
	output [2**ADDR_WIDTH-1:0] out
);
	generate
		if (ADDR_WIDTH > 1) begin
			wire b_bar, en_low, en_high, a_n_1_delayed;
			wire b = a[ADDR_WIDTH-1];
			gates #(.TYPE("NOT")) not1 (.a(a[ADDR_WIDTH-1]), .out(b_bar));
			gates #(.TYPE("BUF")) buf1 (.a(a[ADDR_WIDTH-1]), .out(a_n_1_delayed));
			gates #(.TYPE("AND")) and1 (.a(b_bar), .b(en), .out(en_low));
			gates #(.TYPE("AND")) and2 (.a(a_n_1_delayed), .b(en), .out(en_high));

			decoder #(
				.ADDR_WIDTH(ADDR_WIDTH - 1)
			) decoder_low (
				.a(a[ADDR_WIDTH-2:0]),
				.en(en_low),
				.out(out[2**(ADDR_WIDTH-1)-1:0])
			);
			decoder #(
				.ADDR_WIDTH(ADDR_WIDTH - 1)
			) decoder_high (
				.a(a[ADDR_WIDTH-2:0]),
				.en(en_high),
				.out(out[2**ADDR_WIDTH-1:2**(ADDR_WIDTH-1)])
			);
		end
		else if (ADDR_WIDTH == 1) begin
			wire a_bar, a_delayed;
			gates #(.TYPE("NOT")) not1 (.a(a), .out(a_bar));
			gates #(.TYPE("BUF")) buf1 (.a(a), .out(a_delayed));
			gates #(.TYPE("AND")) and_low (.a(a_bar), .b(en), .out(out[0]));
			gates #(.TYPE("AND")) and_high (.a(a_delayed), .b(en), .out(out[1]));
		end else begin
			invalid_parameter_value error();
		end
	endgenerate
endmodule