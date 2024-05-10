module memory_block #(
	parameter WORD_SIZE = 8,
	parameter BLOCK_SIZE = 256
) (
	input [BLOCK_SIZE-1:0] select,
	input [WORD_SIZE-1:0] data_in,
	input clk,
	output [WORD_SIZE-1:0] data_out
);
	wire [WORD_SIZE-1:0] data_out_from_memory_word [BLOCK_SIZE-1:0];
	wire [BLOCK_SIZE-1:0] or_inputs [WORD_SIZE-1:0];
	
	genvar i,j;

	generate
		for (i = 0; i < BLOCK_SIZE; i = i + 1) begin: memory_word_instance
			memory_word #(
				.WORD_SIZE(WORD_SIZE)
			) memory_word_instance (
				.data_in(data_in), 
				.clk(clk), 
				.enable(select[i]),
				.data_out(data_out_from_memory_word[i])
			);
			
			for (j = 0; j < WORD_SIZE; j = j + 1) begin: or_inputs_assignment
				assign or_inputs[j][i] = data_out_from_memory_word[i][j];
			end
		end

		for (i = 0; i < WORD_SIZE; i = i + 1) begin: or_gate_instance
			n_input_or #(
				.N(BLOCK_SIZE)
			) or_gate_instance (
				.a(or_inputs[i]),
				.out(data_out[i])
			);
		end
	endgenerate
endmodule