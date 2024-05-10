module sign_extender #(
	parameter INPUT_WIDTH = 1,
	parameter OUTPUT_WIDTH = 32
)(
	input [INPUT_WIDTH-1:0] data_in,
	output [OUTPUT_WIDTH-1:0] data_out
);

	assign data_out = {(OUTPUT_WIDTH-INPUT_WIDTH){data_in[INPUT_WIDTH-1]} ,data_in};
endmodule