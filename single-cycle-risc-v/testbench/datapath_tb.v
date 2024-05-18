`timescale 1ns / 1ns

module datapath_tb;
	localparam CLOCK_PERIOD = 2000;
	localparam INSTRUCTION_NUMBER = 20;	// Used to determine the simulation time
	localparam PROGRAM = "test";	// Program to be loaded into the instruction memory
	// Address width of the instruction memory
	// affects the number of instructions that can be stored
	// and compilation time
	localparam INSTRUCTION_MEMORY_ADDR_WIDTH = 4;	
	// Address width of the data memory
	// affects the number of data that can be stored and compilation time
	localparam DATA_MEMORY_ADDR_WIDTH = 2;


	// Instantiate the datapath module
	datapath #(
		.PROGRAM(PROGRAM),
		.INSTRUCTION_MEMORY_ADDR_WIDTH(INSTRUCTION_MEMORY_ADDR_WIDTH),
		.DATA_MEMORY_ADDR_WIDTH(DATA_MEMORY_ADDR_WIDTH)
	) datapath1 ();

	// Test cases
	initial begin
		// Dump VCD file
		$dumpfile("testbench/datapath_tb.vcd");
		$dumpvars(0, datapath_tb);


		#(CLOCK_PERIOD * (INSTRUCTION_NUMBER + 2));

		$finish;
	end

endmodule
