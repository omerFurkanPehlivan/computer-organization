`timescale 1ns / 1ns

module latch_tb;
	localparam WAIT_TIME = 100;

  // Inputs
  reg s;
  reg r;

  // Outputs
  wire [1:0] q;
  wire [1:0] qbar;

  // Instantiate the latch module
  latch #(.TYPE("SR_LATCH"), .ACTIVE("HIGH")) sr_high (
    .s(s),
    .r(r),
    .q(q[0]),
    .qbar(qbar[0])
  );

  latch #(.TYPE("SR_LATCH"), .ACTIVE("LOW")) sr_low (
	.s(s),
	.r(r),
	.q(q[1]),
	.qbar(qbar[1])
  );

	integer i, j;

  // Test cases
  initial begin
    // Dump VCD file
	$dumpfile("testbench/latch_tb.vcd");
	$dumpvars(0, latch_tb);

	// HIGH active level SR latch
	s = 0;
	r = 0;
	#WAIT_TIME;

	s = 1;
	r = 0;
	#WAIT_TIME;

	s = 0;
	r = 0;
	#WAIT_TIME;

	s = 0;
	r = 1;
	#WAIT_TIME;

	s = 0;
	r = 0;
	#WAIT_TIME;

	s = 1;
	r = 1;
	#WAIT_TIME;

	s = 0;
	r = 1;
	#WAIT_TIME;


	// LOW active level SR latch
	s = 1;
	r = 1;
	#WAIT_TIME;

	s = 1;
	r = 0;
	#WAIT_TIME;

	s = 1;
	r = 1;
	#WAIT_TIME;

	s = 0;
	r = 0;
	#WAIT_TIME;



    $finish;
  end

endmodule