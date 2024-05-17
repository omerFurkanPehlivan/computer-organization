`timescale 1ns / 1ns

module flip_flip_tb;
	localparam CLOCK_PERIOD = 500;


  // Inputs
  reg clk;
  reg d;
  
  // Outputs
  wire [1:0] q;
  wire [1:0] qbar;
  
  // Instantiate the flip_flip module
  flip_flop #(.TYPE("D"), .TRIGGER("RISING")) d_rising (
    .clk(clk),
    .d(d),
    .q(q[0]),
    .qbar(qbar[0])
  );
  
  flip_flop #(.TYPE("D"), .TRIGGER("HIGH")) d_high (
    .clk(clk),
    .d(d),
    .q(q[1]),
    .qbar(qbar[1])
  );
  
  // Clock generation
  always #(CLOCK_PERIOD) clk = ~clk;
  
  // Stimulus
  initial begin
	$dumpfile("testbench/flip_flop_tb.vcd");
	$dumpvars(0, flip_flip_tb);

    clk = 0;
    d = 0;

	#(CLOCK_PERIOD / 4);
    
    // Test case 1
    #CLOCK_PERIOD d = 1;
    #CLOCK_PERIOD d = 0;
    
    // Test case 2
    #CLOCK_PERIOD d = 1;
    #CLOCK_PERIOD d = 1;
    
    // Test case 3
    #CLOCK_PERIOD d = 0;
    #CLOCK_PERIOD d = 1;
    
    // Test case 4
    #CLOCK_PERIOD d = 0;
    #CLOCK_PERIOD d = 0;
    
    // Add more test cases as needed
    
    $finish;
  end
  
endmodule