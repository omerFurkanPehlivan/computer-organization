`timescale 1ns/1ns

module edge_detector_tb;
	reg clk;
	wire [5:0] pulse;

	edge_detector #(.TYPE("RISING"), .ACTIVE("HIGH")) rising_high (.clk(clk), .pulse(pulse[0]));
	edge_detector #(.TYPE("RISING"), .ACTIVE("LOW")) rising_low (.clk(clk), .pulse(pulse[1]));
	edge_detector #(.TYPE("FALLING"), .ACTIVE("HIGH")) falling_high (.clk(clk), .pulse(pulse[2]));
	edge_detector #(.TYPE("FALLING"), .ACTIVE("LOW")) falling_low (.clk(clk), .pulse(pulse[3]));
	edge_detector #(.TYPE("BOTH"), .ACTIVE("HIGH")) both_high (.clk(clk), .pulse(pulse[4]));
	edge_detector #(.TYPE("BOTH"), .ACTIVE("LOW")) both_low (.clk(clk), .pulse(pulse[5]));

	always #200 clk = ~clk;

	initial begin
		// Dump VCD file
		$dumpfile("testbench/edge_detector_tb.vcd");
		$dumpvars(0, edge_detector_tb);
		
		clk = 0;
		
		#1000 $finish;
	end
endmodule