module random_access_memory #(
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 8
) (
	input [DATA_WIDTH-1:0] data_in,
	input [ADDR_WIDTH-1:0] addr,
	input clk, write_enable,
	output [DATA_WIDTH-1:0] data_out
);
	wire write_enable_clk;
	wire [(1 << ADDR_WIDTH) - 1:0] select;

	DelayAnd and1 (.a(write_enable), .b(clk), .out(write_enable_clk));
	decoder #(.WIDTH(ADDR_WIDTH)) decoder1 (.a(addr), .en(1'b1), .out(select));

	memory_block #(
		.WORD_SIZE(DATA_WIDTH),
		.BLOCK_SIZE(1 << ADDR_WIDTH)
	) memory_block1 (
		.select(select),
		.data_in(data_in),
		.clk(write_enable_clk),
		.data_out(data_out)
	);

endmodule