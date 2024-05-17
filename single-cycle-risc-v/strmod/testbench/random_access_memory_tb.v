`timescale 1ns / 1ns

module random_access_memory_tb;
	// Parameters
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 8;
	parameter BLOCK_SIZE = 256;
	parameter CLOCK_PERIOD = 2000; // Updated parameter name

	// Signals
	reg [DATA_WIDTH-1:0] data_in;
	reg [ADDR_WIDTH-1:0] addr;
	reg clk, write_enable;
	wire [DATA_WIDTH-1:0] data_out;

	// Instantiate the ram
	random_access_memory #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.BLOCK_SIZE(BLOCK_SIZE)
	) ram1 (
		.data_in(data_in),
		.addr(addr),
		.clk(clk),
		.write_enable(write_enable),
		.data_out(data_out)
	);

	// Clock generation
	always #(CLOCK_PERIOD/2) clk = ~clk;

	// Test stimulus
	initial begin
		// Dump VCD file
		$dumpfile("testbench/random_access_memory_tb.vcd");
		$dumpvars(0, random_access_memory_tb);

		// Initialize inputs
		data_in = 0;
		addr = 0;
		clk = 0;
		write_enable = 0;

		#(CLOCK_PERIOD/4);

		// Write operation
		data_in = 8'hAA;
		addr = 8'h01;
		write_enable = 1;
		#CLOCK_PERIOD;

		// Read operation
		addr = 8'h01;
		write_enable = 0;
		#CLOCK_PERIOD;

		// Write Test
		addr = 8'hAA; // Choose an address
		data_in = 8'h55; // Choose a data value
		write_enable = 1'b1;
		#CLOCK_PERIOD; // Wait for some time

		addr = 8'hBB; // Choose another address
		data_in = 8'h66; // Choose another data value
		#CLOCK_PERIOD; // Wait for some time

		// Read Test
		write_enable = 1'b0;
		addr = 8'hAA;
		#CLOCK_PERIOD; // Wait for some time

		// Check the output
		addr = 8'h01;
		#CLOCK_PERIOD; // Wait for some time
		if (data_out === 8'hAA)
			$display("Read operation successful");
		else
			$display("Read operation failed");

		// End simulation
		$finish;
	end

endmodule
