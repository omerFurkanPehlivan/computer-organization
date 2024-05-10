module priority_encoder #(
	parameter OUTPUT_WIDTH = 3
) (
	input [(1<<OUTPUT_WIDTH)-1:0] a,
	output [OUTPUT_WIDTH-1:0] out,
	output valid
);

	generate
		if (OUTPUT_WIDTH == 1) begin: pri_encoder_2_to_1
			gates #(.TYPE("OR")) or1 (
				.a(a[1]),
				.b(a[0]),
				.out(valid)
			);
			assign out = a[1];
		end 
		else begin: pri_encoder_n_to_1
			wire valid1, valid2;
			wire [OUTPUT_WIDTH-2:0] out1, out2;
		
			priority_encoder #(
				.OUTPUT_WIDTH(OUTPUT_WIDTH - 1)
			) priority_encoder1 (
				.a(a[(1<<(OUTPUT_WIDTH-1))-1:0]),
				.valid(valid1),
				.out(out1)
			);
			
			priority_encoder #(
				.OUTPUT_WIDTH(OUTPUT_WIDTH - 1)
			) priority_encoder2 (
				.a(a[(1<<OUTPUT_WIDTH)-1:1<<(OUTPUT_WIDTH-1)]),
				.valid(valid2),
				.out(out2)
			);

			mux #(
				.SELECT_BITS(1),
				.DATA_WIDTH(OUTPUT_WIDTH-1)
			) mux1 (
				.data_list({out2, out1}),
				.select(valid2),
				.data_out(out[OUTPUT_WIDTH-2:0])
			);

			assign out[OUTPUT_WIDTH-1] = valid2;

			gates #(.TYPE("OR")) or1 (
				.a(valid1),
				.b(valid2),
				.out(valid)
			);
		end
	endgenerate
endmodule
