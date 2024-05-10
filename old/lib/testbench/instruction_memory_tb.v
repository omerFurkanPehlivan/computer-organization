`timescale 1ns/1ns

module instruction_memory_tb;
  
  reg [4:0] addr;
  wire [31:0] data;

  localparam DELAY = 2000;
  
  instruction_memory dut (
    .addr(addr),
    .data(data)
  );
  
  initial begin
	// Dump VCD file
	$dumpfile("testbench/instruction_memory_tb.vcd");
	$dumpvars(0, instruction_memory_tb);

    // Test case 1
    addr = 0;
    #DELAY;
    if (data !== 32'hafcecece)
      $display("Test case 1 failed");
    
    // Test case 2
    addr = 1;
    #DELAY;
    if (data !== 32'h01234567)
      $display("Test case 2 failed");
    
    // Test case 3
    addr = 2;
    #DELAY;
    if (data !== 32'h89abcdef)
      $display("Test case 3 failed");
    
    // Test case 4
    addr = 3;
    #DELAY;
    if (data !== 32'hffffffff)
      $display("Test case 4 failed");
    
    // Test case 5
    addr = 4;
    #DELAY;
    if (data !== 32'b0)
      $display("Test case 5 failed");
    
    $display("Testing complete");
    $finish;
  end
  
endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/instruction_memory_tb.vvp -y ../lib testbench/instruction_memory_tb.v
// command: vvp testbench/instruction_memory_tb.vvp