`timescale 1ns/1ns
module datapath_tb;
	// Parameters
	localparam CLOCK_PERIOD = 10;

	// Instantiate the datapath module
	datapath dut();

	// Test stimulus
	initial begin
		// Dump VCD file
		$dumpfile("testbench/datapath_tb.vcd");
		$dumpvars(0, datapath_tb);

		#(CLOCK_PERIOD * 250)
		$finish;
	end

endmodule