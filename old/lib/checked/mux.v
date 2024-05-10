// Higher index comes first in data_list
module mux #(
	parameter SELECT_BITS = 1,
	parameter DATA_WIDTH = 1
) (
	input [((1 << SELECT_BITS) * DATA_WIDTH )-1:0] data_list, 
	input [SELECT_BITS-1:0] select, 
	output [DATA_WIDTH-1:0] data_out
);
	wire [(1 << SELECT_BITS) - 1:0] splitted_data_list [DATA_WIDTH-1:0];
	generate
		genvar i,j;

		// Split the data_list to Array of Vectors
		for (i = 0; i < DATA_WIDTH; i = i + 1) begin: split_data_list
			for (j = 0; j < 2 ** SELECT_BITS; j = j + 1) begin: split_data_list_2
				assign splitted_data_list[i][j] = data_list[(j * DATA_WIDTH) + i];
			end
		end

		if (SELECT_BITS > 1) begin: mux_n_to_1
			for (i = 0; i < DATA_WIDTH; i = i + 1) begin: mux_n_bit
				wire mux1_out, mux2_out;
				mux #(
					.SELECT_BITS(SELECT_BITS - 1)
					) mux1 (
					.data_list(splitted_data_list[i][(1 << (SELECT_BITS - 1)) - 1:0]),
					.select(select[SELECT_BITS - 2:0]),
					.data_out(mux1_out)
				);
				mux #(
					.SELECT_BITS(SELECT_BITS - 1)
					) mux2 (
					.data_list(splitted_data_list[i][(1 << SELECT_BITS) - 1:1 << (SELECT_BITS - 1)]),
					.select(select[SELECT_BITS - 2:0]),
					.data_out(mux2_out)
				);

				mux #(
					.SELECT_BITS(1)
					) mux3 (
					.data_list({mux2_out, mux1_out}),
					.select(select[SELECT_BITS - 1]),
					.data_out(data_out[i])
				);
			end
		end 
		else if (SELECT_BITS == 1) begin: mux_2_to_1
			wire [DATA_WIDTH-1:0] and1_out, and2_out;
			wire select_not;
			for (i = 0; i < DATA_WIDTH; i = i + 1) begin: mux_2_bit
				DelayNot not1 (.a(select), .out(select_not));
				DelayAnd and1 (.a(splitted_data_list[i][0]), .b(select_not), .out(and1_out[i]));
				DelayAnd and2 (.a(splitted_data_list[i][1]), .b(select), .out(and2_out[i]));
				DelayOr or1 (.a(and1_out[i]), .b(and2_out[i]), .out(data_out[i]));
			end
		end
	endgenerate
	
endmodule