module instruction_memory #(
	parameter WIDTH = 8,
	parameter ADDR_WIDTH = 8
) (
	input [ADDR_WIDTH-1:0] addr,
	input clk,
		rst,
	output reg [WIDTH-1:0] data_out
);

	reg [WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

	initial begin
		$readmemh("instruction_memory.mem", mem, 0, (1<<ADDR_WIDTH)-1);
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			data_out <= 0;
		end else begin
			data_out <= mem[addr];
		end
	end
endmodule
