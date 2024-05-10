`timescale 1ns / 1ns

module priority_encoder_tb;

  // Parameters
  parameter OUTPUT_WIDTH = 4;
  localparam INPUT_WIDTH = 1 << OUTPUT_WIDTH;

  localparam DELAY = 2000;

  // Inputs
  reg [INPUT_WIDTH-1:0] a;

  // Outputs
  wire [OUTPUT_WIDTH-1:0] out;
  wire valid;

  // Instantiate the module under test
  priority_encoder #(
    .OUTPUT_WIDTH(OUTPUT_WIDTH)
  ) priority_encoder1 (
    .a(a),
    .out(out),
    .valid(valid)
  );


  // Test stimulus
  integer i;
  initial begin

	// Dump VCD file
	$dumpfile("testbench/priority_encoder_tb.vcd");
	$dumpvars(0, priority_encoder_tb);
    
	for (i = 0; i < 1<<INPUT_WIDTH; i = i + 1) begin
		a = i;
		#DELAY;
	end

    $finish;
  end

endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/priority_encoder_tb.vvp -y ../lib testbench/priority_encoder_tb.v
// command: vvp testbench/priority_encoder_tb.vvp