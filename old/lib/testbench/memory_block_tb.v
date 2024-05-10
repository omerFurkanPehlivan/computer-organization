`timescale 1ns / 1ns

module memory_block_tb;
	// Parameters
	parameter WORD_SIZE = 8;
	parameter BLOCK_SIZE = 8;
	parameter DELAY = 2000;
	
	// Signals
	reg [BLOCK_SIZE-1:0] select;
	reg [WORD_SIZE-1:0] data_in;
	reg clk;
	wire [WORD_SIZE-1:0] data_out;
	
	// Instantiate the memory_block module
	memory_block #(
		.WORD_SIZE(WORD_SIZE),
		.BLOCK_SIZE(BLOCK_SIZE)
	) dut (
		.select(select),
		.data_in(data_in),
		.clk(clk),
		.data_out(data_out)
	);
	
	// Clock generation
	always #(DELAY/2) clk = ~clk;
	
	// Test stimulus
	initial begin
		// Dump VCD file
		$dumpfile("testbench/memory_block_tb.vcd");
		$dumpvars(0, memory_block_tb);

		// Initialize inputs
		select = 0;
		data_in = 0;
		clk = 0;

		#(DELAY/4);
		
		// Apply stimulus
		#DELAY data_in = 8'hAB;
		#DELAY select = 8'h1;
		#DELAY select = 8'h8;
		#DELAY data_in = 8'h01;

		#DELAY data_in = 8'hEF;
		select = 8'h1;
		
		// Add more test cases here...
		
		// End simulation
		#DELAY $finish;
	end
	
endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/memory_block_tb.vvp -y ../lib testbench/memory_block_tb.v
// command: vvp testbench/memory_block_tb.vvp