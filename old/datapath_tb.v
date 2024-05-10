`timescale 1ns / 1ns

module datapath_tb;
	localparam CLOCK_PERIOD = 2000;
	localparam INSTRUCTION_NUMBER = 5;

	// Instantiate the datapath module
	datapath datapath1 (
		.rst(rst)
	);

	// Test cases
	initial begin
		// Dump VCD file
		$dumpfile("testbench/datapath_tb.vcd");
		$dumpvars(0, datapath_tb);

		// Reset clock
		rst = 1;
		#(CLOCK_PERIOD*5);
		rst = 0;

		#(CLOCK_PERIOD*INSTRUCTION_NUMBER);
		$finish;
	end

endmodule

// current directory: 21011056/Q1
// command: iverilog -o datapath_tb.vvp -y lib -s datapath_tb datapath.v datapath_tb.v
// command: vvp datapath_tb.vvp