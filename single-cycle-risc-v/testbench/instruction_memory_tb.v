`timescale 1ns/1ns

module instruction_memory_tb;
  
  reg [3:0] addr;
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

	for (addr = 0; addr < 3; addr = addr + 1)
		#DELAY;
	#DELAY
    $finish;
  end
  
endmodule
