module register_file (
	input [4:0] addr1, addr2, addr3,
	input [31:0] data_in,
	input clk,
	input write_enable,
	output [31:0] data_out1, data_out2;
)
	reg [31:0] registers [31:0];

	always @(posedge clk) begin
		if (write_enable) begin
			registers[addr3] <= data_in;
		end
	end

	assign data_out1 = registers[addr1];
	assign data_out2 = registers[addr2];
endmodule