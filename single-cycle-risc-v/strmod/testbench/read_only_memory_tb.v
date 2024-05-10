`timescale 1ns/1ns

module read_only_memory_tb;
  // Parameters
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 3;
  parameter DATA_COUNT = 5;
  localparam DELAY = 1000;

  // Signals
  reg [(DATA_COUNT) * DATA_WIDTH - 1:0] data_list;
  reg [ADDR_WIDTH-1:0] addr;
  reg overflow;
  wire [DATA_WIDTH-1:0] data_out;

  // Instantiate the module under test
  read_only_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_COUNT(DATA_COUNT)
  ) dut (
    .data_list({
		32'hafcecece, // 0
		32'h01234567, // 1
		32'h89abcdef, // 2
		32'hffffffff, // 3
		32'h15151515 // 4
	}),
    .addr(addr),
    .data_out(data_out)
  );

  // Initialize signals
  initial begin
	$dumpfile("testbench/read_only_memory_tb.vcd");
	$dumpvars(0, read_only_memory_tb);

    for (addr = 0; addr < (1 << ADDR_WIDTH) - 1; addr = addr + 1) begin
	  #DELAY;
	end

    $finish;
  end
endmodule