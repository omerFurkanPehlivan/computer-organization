`timescale 1ns/1ns

module	edge_detector_tb;
	
	reg clk;
	wire [1:0] out;

	rising_edge_detector rising_edge_detector1 (clk, out[0]);
	falling_edge_detector falling_edge_detector1 (clk, out[1]);

	initial begin
		$dumpfile("testbench/edge_detector_tb.vcd");
		$dumpvars(0, edge_detector_tb);

		clk = 0;
		#100 clk = 0;

		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;

		#50 clk = 1;
		#10 clk = 0;
		#10 clk = 1;
		#10 clk = 0;
		#10 clk = 1;
		#10 clk = 0;

		#50 clk = 0;
		#20 clk = 1;
		#20 clk = 0;
		#20 clk = 1;
		#20 clk = 0;
		#20 clk = 1;
		#20 clk = 0;

		#50 clk = 0;
		#30 clk = 1;
		#30 clk = 0;
		#30 clk = 1;
		#30 clk = 0;
		#30 clk = 1;
		#30 clk = 0;

		#100 clk = 0;
		#40 clk = 1;
		#40 clk = 0;
		#40 clk = 1;
		#40 clk = 0;
		#40 clk = 1;
		#40 clk = 0;

		#200 clk = 0;
		#100 clk = 1;
		#100 clk = 0;
		#100 clk = 1;
		#100 clk = 0;
		#100 clk = 1;
		#100 clk = 0;
		
		#10 $finish;
	end
endmodule

// current directory: 21011056/Q1/lib/
// command: iverilog -o testbench/edge_detector_tb.vvp -s edge_detector_tb -c lib_list.cf testbench/edge_detector_tb.v
// command: vvp testbench/edge_detector_tb.vvp