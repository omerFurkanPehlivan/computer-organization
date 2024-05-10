`timescale 10ns/10ns

module register_file_tb;
	// Parameters
	parameter WORD_SIZE = 32;
	parameter ADDR_WIDTH = 5;
	parameter DELAY = 200;
	
	// Signals
	reg [ADDR_WIDTH-1:0] read_addr_1, read_addr_2, write_addr;
	reg [WORD_SIZE-1:0] data_in;
	reg clk, write_enable;
	wire [WORD_SIZE-1:0] read_data_1, read_data_2;
	
	// Instantiate the register_file module
	register_file #(
		.WORD_SIZE(WORD_SIZE),
		.ADDR_WIDTH(ADDR_WIDTH)
	) regfile (
		.read_addr_1(read_addr_1),
		.read_addr_2(read_addr_2),
		.write_addr(write_addr),
		.data_in(data_in),
		.clk(clk),
		.write_enable(write_enable),
		.read_data_1(read_data_1),
		.read_data_2(read_data_2)
	);
	
	// Clock generation
	always #(DELAY/2) clk = ~clk;
	
	// Test stimulus
	integer i, n;
	initial begin
		// Dump VCD file
		$dumpfile("testbench/register_file_tb.vcd");
		$dumpvars(0, register_file_tb);

		// Clock phase alignment
		clk = 0;
		#(DELAY/4);

		// Write data to registers
		n = 1 << ADDR_WIDTH;
		for (i = 0; i < n; i = i + 1) begin
			write_addr = i;
			data_in = 32'hA0000000 + i;
			write_enable = 1;
			#DELAY;
		end

		// Read data from registers
		write_enable = 0;
		for (i = 0; i < n; i = i + 2) begin
			read_addr_1 = i;
			read_addr_2 = i + 1;
			#DELAY;
		end

		// End simulation
		$finish;
	end
endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/register_file_tb.vvp -y ../lib testbench/register_file_tb.v
// command: vvp testbench/register_file_tb.vvp