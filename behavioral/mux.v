module mux #(
	parameter WIDTH = 8,
	parameter SEL_WIDTH = 1
) (
	input [WIDTH*(1<<SEL_WIDTH)-1:0] data_list,
	input [SEL_WIDTH-1:0] sel,
	output wire [WIDTH-1:0] data_out
);

	genvar i;
	generate
		for (i = 0; i < (1<<SEL_WIDTH); i = i + 1) begin : mux_gen
			assign data_out = (sel == i) ? data_list[WIDTH*i +: WIDTH] : data_out;
		end
	endgenerate
endmodule