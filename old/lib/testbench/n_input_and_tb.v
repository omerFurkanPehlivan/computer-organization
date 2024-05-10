`timescale 1ns / 1ns

module n_input_and_tb;

	// Parameters
	parameter N = 4;
	parameter DELAY = 200;

	// Inputs
	reg [N-1:0] a;
	
	// Outputs
	wire out;

	// Instantiate the module under test
	n_input_and #(.N(N)) dut (
		.a(a),
		.out(out)
	);

	// Stimulus
	integer i;
	initial begin
		// Dump VCD file
		$dumpfile("testbench/n_input_and_tb.vcd");
		$dumpvars(0, n_input_and_tb);

		#DELAY;
		// Test Loop
		for (i = 0; i < 2 ** N; i = i + 1) begin
			a = i;
			#DELAY;
		end

		$finish;
	end

endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/n_input_and_tb.vvp -y ../lib testbench/n_input_and_tb.v
// command: vvp testbench/n_input_and_tb.vvp