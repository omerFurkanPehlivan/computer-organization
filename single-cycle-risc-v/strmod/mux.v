/**
 * Implements a multiplexer (MUX) module with configurable select bits and data width.
 *
 * Module Name: mux
 *
 * Parameters:
 *   - SELECT_BITS: Number of select bits (default: 1)
 *   - DATA_WIDTH: Width of the data (default: 1)
 *
 * Inputs:
 *   - data_list: Input data list, where higher index comes first ([(1 << SELECT_BITS) * DATA_WIDTH)-1:0])
 *   - select: Select input for choosing the data (SELECT_BITS-1:0)
 *
 * Outputs:
 *   - data_out: Output data based on the select input (DATA_WIDTH-1:0)
 *
 * Description:
 *   The mux module takes in a data list and a select input, and outputs the selected data based on the select input.
 *   The data list is split into an array of vectors, and the selected data is determined using the select input.
 *   The module supports both 2-to-1 and n-to-1 multiplexing based on the number of select bits.
 *   For 2-to-1 multiplexing, the module uses AND and OR gates to select the appropriate data.
 *   For n-to-1 multiplexing, the module recursively uses smaller mux modules to select the data.
 *
 * Dependencies:
 *   - gates.v: A module that implements basic logic gates (AND, OR, NOT)
 *
 * Example Usage:
 *    2-to-1 MUX
 *   mux #(
 *     .SELECT_BITS(1),
 *     .DATA_WIDTH(4)
 *   ) my_mux (
 *     .data_list({
			4'b0101, 	// Select 1: 4'b0101
			4'b1010		// Select 0: 4'b1010
		}),
 *     .select(select),
 *     .data_out(data_out)
 *   );
 *
 *    4-to-1 MUX
 *   mux #(
 *     .SELECT_BITS(2),
 *     .DATA_WIDTH(2)
 *   ) my_mux (
 *     .data_list({
			8'b01010101, // Select 11: 8'b01010101
			8'b10101010, // Select 10: 8'b10101010
			8'b11110000, // Select 01: 8'b11110000
			8'b00001111  // Select 00: 8'b00001111
			}),
 *     .select(select),
 *     .data_out(data_out)
 *   );
 */
// Higher index comes first in data_list
module mux #(
	parameter SELECT_BITS = 1,
	parameter DATA_WIDTH = 1
) (
	input [((1 << SELECT_BITS) * DATA_WIDTH )-1:0] data_list, 
	input [SELECT_BITS-1:0] select, 
	output [DATA_WIDTH-1:0] data_out
);
	localparam MUX_DELAY_2_TO_1 = 20;
	localparam MUX_DELAY_N_TO_1 = MUX_DELAY_2_TO_1 * (SELECT_BITS - 1);

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
				wire mux1_out, mux2_out, select_delayed;
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

				gates #(.TYPE("BUF"), .DELAY(MUX_DELAY_N_TO_1)) buf1 (.a(select[SELECT_BITS - 1]), .out(select_delayed));

				mux #(
					.SELECT_BITS(1)
				) mux3 (
					.data_list({mux2_out, mux1_out}),
					.select(select_delayed),
					.data_out(data_out[i])
				);
			end
		end 
		else if (SELECT_BITS == 1) begin: mux_2_to_1
			wire [DATA_WIDTH-1:0] and1_out, and2_out;
			wire select_not, select_delayed;
			for (i = 0; i < DATA_WIDTH; i = i + 1) begin: mux_2_bit
				//gates #(.TYPE("BUF")) buf1 (.a(select), .out(select_delayed));
				//gates #(.TYPE("NOT")) not1 (.a(select), .out(select_not));
				// a little cheating :)
				not (select_not, select);
				gates #(.TYPE("AND")) and1 (.a(splitted_data_list[i][0]), .b(select_not), .out(and1_out[i]));
				gates #(.TYPE("AND")) and2 (.a(splitted_data_list[i][1]), .b(select), .out(and2_out[i]));
				gates #(.TYPE("OR")) or1 (.a(and1_out[i]), .b(and2_out[i]), .out(data_out[i]));
			end
		end
	endgenerate
	
endmodule