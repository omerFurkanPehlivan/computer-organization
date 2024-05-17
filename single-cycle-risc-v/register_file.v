module register_file #(
	parameter WORD_SIZE = 32,
	parameter ADDR_WIDTH = 5
) (
	input [ADDR_WIDTH-1:0] read_addr_1, read_addr_2, write_addr,
	input [WORD_SIZE-1:0] data_in,
	input clk, write_enable,
	output [WORD_SIZE-1:0] read_data_1, read_data_2
);
	wire [WORD_SIZE-1:0] register_out [(1<<ADDR_WIDTH)-1:0];
	wire [(1<<ADDR_WIDTH)-1:0] select;
	wire clk_pos_edge, write_enable_clk;

	wire [(1<<ADDR_WIDTH)*WORD_SIZE-1:0] flattened_register_out;

	// Flatten register_out
	generate
		genvar i;
		for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin: flatten_register_out
			assign flattened_register_out[i*WORD_SIZE +: WORD_SIZE] = register_out[i];
		end
	endgenerate

	edge_detector #(.TYPE("RISING"), .ACTIVE("HIGH")) rising_edge_detector1 (.clk(clk), .pulse(clk_pos_edge));

	gates #(.TYPE("AND")) and1 (.a(write_enable), .b(clk_pos_edge), .out(write_enable_clk));

	decoder #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) decoder1 (
		.a(write_addr),
		.en(1'b1),
		.out(select)
	);
	
	generate
		for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin: genregister
			register #(
				.TRIGGER("LEVEL"),
				.WORD_SIZE(WORD_SIZE)
			) register1 (
				.data_in(data_in),
				.enable(select[i]),
				.clk(write_enable_clk),
				.data_out(register_out[i])
			);
		end
	endgenerate

	mux #(
		.SELECT_BITS(ADDR_WIDTH),
		.DATA_WIDTH(WORD_SIZE)
	) read_mux_1 (
		.data_list(flattened_register_out),
		.select(read_addr_1),
		.data_out(read_data_1)
	);

	mux #(
		.SELECT_BITS(ADDR_WIDTH),
		.DATA_WIDTH(WORD_SIZE)
	) read_mux_2 (
		.data_list(flattened_register_out),
		.select(read_addr_2),
		.data_out(read_data_2)
	);
endmodule