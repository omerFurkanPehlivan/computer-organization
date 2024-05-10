module memory_1x32bit (input [31:0] data_in, input clk, output [31:0] data_out);
	d_flip_flop dff[31:0](.d(data_in), .clk(clk), .q(data_out));
endmodule