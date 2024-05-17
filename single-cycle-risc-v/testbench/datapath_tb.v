`timescale 1ns / 1ns

module datapath_tb;
	localparam CLOCK_PERIOD = 2000;
	localparam INSTRUCTION_NUMBER = 200;
	localparam PROGRAM = "sorter";


	// Instantiate the datapath module
	datapath #(
		.PROGRAM("sorter"),
		.INSTRUCTION_MEMORY_ADDR_WIDTH(7),
		.DATA_MEMORY_ADDR_WIDTH(6)
	) datapath1 ();

	// Test cases
	initial begin
		// Dump VCD file
		$dumpfile("testbench/datapath_tb.vcd");
		$dumpvars(0, datapath_tb);


		#(CLOCK_PERIOD * (INSTRUCTION_NUMBER));

		$finish;
	end

endmodule
