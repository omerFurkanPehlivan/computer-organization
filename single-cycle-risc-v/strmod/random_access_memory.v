module random_access_memory #(
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 4,
	parameter BLOCK_SIZE = (1 << ADDR_WIDTH)
) (
	input [DATA_WIDTH-1:0] data_in,
	input [ADDR_WIDTH-1:0] addr,
	input clk, 
		write_enable,
	output [DATA_WIDTH-1:0] data_out
);
	if (BLOCK_SIZE > (1 << ADDR_WIDTH)) begin
		ram_cant_adress_that_size error();
	end

	wire [BLOCK_SIZE-1:0] select;
	wire clk_edge,
		write_enable_clk_edge;
	wire [DATA_WIDTH-1:0] reg_out [BLOCK_SIZE-1:0];
	// It is reversed because of the way the memory 
	// is implemented (Exactly: OR gates for output)
	wire [BLOCK_SIZE-1:0] reg_out_enabled [DATA_WIDTH-1:0];

	// a decoder to select the word to write to or read from
	decoder #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) decoder1 (
		.a(addr),
		.en(1'b1), // Always enabled for reading
		.out(select)
	);

	// Detect the rising edge of the clock
	edge_detector #(
		.TYPE("RISING"),
		.ACTIVE("HIGH")
	) rising_edge_detector1 (
		.clk(clk),
		.pulse(clk_edge)
	);

	// AND Write enable and clock to get the write enable for the memory
	gates #(
		.TYPE("AND")
	) and1 (
		.a(write_enable),
		.b(clk_edge),
		.out(write_enable_clk_edge)
	);
	
	generate
		genvar i, j;
		for (i = 0; i < BLOCK_SIZE; i = i + 1) begin

			register #(
				.TRIGGER("LEVEL"),
				.WORD_SIZE(DATA_WIDTH)
			) register1 (
				.data_in(data_in),
				.enable(select[i]),
				.clk(write_enable_clk_edge),
				.data_out(reg_out[i])
			);


			// Enable the output of the register with select
			for (j = 0; j < DATA_WIDTH; j = j + 1) begin
				gates #(
					.TYPE("AND")
				) and1 (
					.a(reg_out[i][j]),
					.b(select[i]),
					.out(reg_out_enabled[j][i])
				);
			end
		end

		for (i = 0; i < DATA_WIDTH; i = i + 1) begin
			// Create an OR gate for each bit of the output
			n_input_gates #(
				.TYPE("OR"),
				.N(BLOCK_SIZE)
			) or1 (
				.a(reg_out_enabled[i]),
				.out(data_out[i])
			);
		end
	endgenerate
endmodule
