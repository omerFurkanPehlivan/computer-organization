// Writes data at rising edge of clk
// if read_enable is high, data_out is stored data
// if read_enable is low, data_out is 0
module memory_bit (
	input data_in, 
	input clk, read_enable,
	output data_out
);	
	wire q;
	d_flip_flop dff(.d(data_in), .clk(clk), .q(q), .qbar());
	DelayAnd and1 (.a(q), .b(read_enable), .out(data_out));
endmodule