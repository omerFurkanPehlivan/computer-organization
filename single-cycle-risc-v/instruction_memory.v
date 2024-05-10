module instruction_memory (
	input [4:0] addr,
	output [31:0] data
);
	localparam DATA_WIDTH = 32,
		ADDR_WIDTH = 5,
		INSTRUCTIONS = 4;

	read_only_memory #(
		.DATA_WIDTH(32),
		.ADDR_WIDTH(5),
		.DATA_COUNT(INSTRUCTIONS)
	) rom1 (
		.data_list({
			32'hafcecece, // 0
			32'h01234567, // 1
			32'h89abcdef, // 2
			32'hffffffff // 3
		}),
		.addr(addr),
		.data_out(data)
	);
endmodule