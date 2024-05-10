// addr is inverted due to convinence of data_list indexing
/* data_list template is as follows:
data_list(
	32'hafcecece, // 0
	32'h01234567, // 1
	32'h89abcdef, // 2
	32'hffffffff, // 3
	{EMPTY_DATA{32'b0}} // 4
)
*/

module read_only_memory #(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 1
) (
	input [(1 << ADDR_WIDTH) * DATA_WIDTH - 1:0] data_list,
	input [ADDR_WIDTH-1:0] addr,
	output [DATA_WIDTH-1:0] data_out
);
	wire [ADDR_WIDTH-1:0] addr_not;
	DelayNot not1 [ADDR_WIDTH-1:0] (
		.a(addr),
		.out(addr_not)
	);
	mux #(
		.SELECT_BITS(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) mux1 (
		.data_list(data_list),
		.select(addr_not),
		.data_out(data_out)
	);
endmodule