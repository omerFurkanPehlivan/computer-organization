`timescale 1ns / 1ns

module testbench;
	reg rst;
	wire clk_out;

	// Instantiate the clock module
	clock #(
		.CLOCK_PERIOD(2000)
	) clock1 (
		.rst(rst),
		.clk_out(clk_out)
	);

	// Stimulus
	initial begin
		// Dump VCD file
		$dumpfile("testbench/clock_tb.vcd");
		$dumpvars(0, testbench);

		rst = 1;
		#5000;
		rst = 0;
		#20000;
		rst = 1;
		#5000;
		$finish;
	end

endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/clock_tb.vvp -y ../lib testbench/clock_tb.v
// command: vvp testbench/clock_tb.vvp