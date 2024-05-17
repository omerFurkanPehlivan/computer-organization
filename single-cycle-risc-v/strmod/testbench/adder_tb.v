`timescale 1ns/1ns

module adder_tb;
  
  // Parameters
  parameter TYPE = "ADDER";
  parameter WIDTH = 2;
  
  // Inputs
  reg [WIDTH:0] a, b;
  reg [1:0] cin;
  
  // Outputs
  wire [WIDTH-1:0] sum;
  wire cout;
  
  // Instantiate the adder module
  adder #(
    .TYPE(TYPE),
    .WIDTH(WIDTH)
  ) dut (
    .a(a[WIDTH-1:0]),
    .b(b[WIDTH-1:0]),
    .cin(cin[0]),
    .sum(sum),
    .cout(cout)
  );
  
  // Test stimulus
  initial begin
	$dumpfile("testbench/adder_tb.vcd");
	$dumpvars(0, adder_tb);

	for (cin = 0; cin < 2; cin = cin + 1) begin
		for (a = 0; a < (1<<WIDTH); a = a + 1) begin
			for (b = 0; b < (1<<WIDTH); b = b + 1) begin
				#2000;
			end
		end
	end	
    #2000;
	$finish;
    
  end
  
endmodule