// Testbench for sr_latch module
`timescale 1ns/1ns

module flip_flop_tb;
	reg s, r, clk;
	wire [2:0] q, qbar;

	parameter delay = 2000;
	parameter clock_half = 1000;

	sr_latch sr_latch1 (.s(s), .r(r), .q(q[0]), .qbar(qbar[0]));
	sr_flip_flop sr_flip_flop1 (.s(s), .r(r), .clk(clk), .q(q[1]), .qbar(qbar[1]));
	d_flip_flop d_flip_flop1 (.d(s), .clk(clk), .q(q[2]), .qbar(qbar[2]));

	initial begin
		$dumpfile("testbench/flip_flop_tb.vcd");
		$dumpvars(0, flip_flop_tb);

		clk = 0; // Initialize clock
		#200;
		// Test case 1: Set S=1, R=0
		s = 1;
		r = 0;
		#delay; // Wait
		// Expected output: Q=1, Qbar=0

		// Test case 2: Set S=0, R=1
		s = 0;
		r = 1;
		#delay; // Wait
		// Expected output: Q=0, Qbar=1

		// Test case 3: Set S=0, R=0
		s = 0;
		r = 0;
		#delay; // Wait
		// Expected output: Q=Q (unchanged)

		// Test case 4: Set S=1, R=1
		s = 1;
		r = 1;
		#delay; // Wait
		// Expected output: Invalid state (Q = 0, Qbar = 0) (both S and R are high)

		// Test case 5: Set S=0, R=0
		s = 0;
		r = 0;
		#delay; // Wait
		// Expected output: Invalid state (both S and R are low)

		// Test case 6: Set S=1, R=0
		s = 1;
		r = 0;
		#delay; // Wait
		// Expected output: Q=1, Qbar=0

		$finish; // End simulation
	end

	always #clock_half clk = ~clk; // Clock toggles every clock_half
endmodule

// current directory: 21011056/Q1/lib/
// command: iverilog -o testbench/flip_flop_tb.vvp -c lib_list.cf testbench/flip_flop_tb.v
// command: vvp testbench/flip_flop_tb.vvp