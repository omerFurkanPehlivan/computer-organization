module data_memory (
	input [31:0] address,
	input [31:0] write_data,
	input write_enable, clk,
	output [31:0] read_data
);
	reg [31:0] memory [0:128];

	assign read_data = memory[address];

	always @(posedge clk) begin
		if (write_enable) begin
			memory[address] <= write_data;
		end
	end
endmodule