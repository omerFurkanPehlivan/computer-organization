`timescale 1ns/1ns
module testbench;
	parameter WORD_SIZE = 32;
	parameter DELAY = 2000;
	
	reg [WORD_SIZE-1:0] data_in;
	reg clk, select;
	wire [WORD_SIZE-1:0] data_out;
	
	memory_word #(
		.WORD_SIZE(WORD_SIZE)
	) dut (
		.data_in(data_in),
		.clk(clk),
		.read_enable(select),
		.data_out(data_out)
	);
	
	initial begin
		// Dump VCD file
		$dumpfile("testbench/memory_word_tb.vcd");
		$dumpvars(0, testbench);

		clk = 0;
		read_enable = 0;
		data_in = 8'b10101010;
		
		#DELAY;
		
		read_enable = 1;
		
		#DELAY;
		
		read_enable = 0;
		
		#DELAY;

		read_enable = 1;
		data_in = 32'hABCD1234;
		#DELAY;
		data_in = 32'h98765432;
		#DELAY;
		data_in = 32'hFEDCBA98;
		#DELAY;
		data_in = 32'h24681357;
		
		#DELAY;
		$finish;
	end
	
	always #(DELAY/2) clk = ~clk;
	
endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/memory_word_tb.vvp -y ../lib testbench/memory_word_tb.v
// command: vvp testbench/memory_word_tb.vvp