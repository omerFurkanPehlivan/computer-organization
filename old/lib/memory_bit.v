// Writes data at rising edge of clk
// if read_enable is high, data_out is stored data
// if read_enable is low, data_out is 0
module memory_bit (
	input data_in, 
	input clk, read_enable,
	output data_out
);	
	wire q;
	flip_flop #(.TYPE("D"), .TRIGGER("RISING")) dff(.d(data_in), .clk(clk), .q(q), .qbar());
	gates #(.TYPE("AND")) and1 (.a(q), .b(read_enable), .out(data_out));
endmodule