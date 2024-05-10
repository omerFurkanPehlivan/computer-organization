`timescale 1ns / 1ns

module adder_tb;
	parameter WIDTH = 4;
	parameter DELAY = 2000;
	
	reg [WIDTH-1:0] a, b;
	reg cin;
	wire [WIDTH-1:0] sum;
	wire cout;
	
	adder #(.WIDTH(WIDTH)) dut (
		.a(a),
		.b(b),
		.cin(cin),
		.sum(sum),
		.cout(cout)
	);
	
	initial begin
		// Dump VCD file
		$dumpfile("testbench/adder_tb.vcd");
		$dumpvars(0, adder_tb);

		// Test case 1
		a = 4'b0000;
		b = 4'b0000;
		cin = 0;
		#DELAY;
		$display("a = %b, b = %b, cin = %b, sum = %b, cout = %b", a, b, cin, sum, cout);
		
		// Test case 2
		a = 4'b1010;
		b = 4'b0110;
		cin = 1;
		#DELAY;
		$display("a = %b, b = %b, cin = %b, sum = %b, cout = %b", a, b, cin, sum, cout);
		
		// Add more test cases here...
		
		// Test case 3
		a = 4'b1111;
		b = 4'b0001;
		cin = 0;
		#DELAY;

		
		// Test case 4
		a = 4'b0101;
		b = 4'b0011;
		cin = 1;
		#DELAY;

		$display("a = %b, b = %b, cin = %b, sum = %b, cout = %b", a, b, cin, sum, cout);

		// Test case 5
		a = 4'b1100;
		b = 4'b1010;
		cin = 0;
		#DELAY;

		$display("a = %b, b = %b, cin = %b, sum = %b, cout = %b", a, b, cin, sum, cout);

		// Test case 6
		a = 4'b0111;
		b = 4'b1001;
		cin = 1;
		#DELAY;

		$display("a = %b, b = %b, cin = %b, sum = %b, cout = %b", a, b, cin, sum, cout);
		


		$finish;
	end
endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/adder_tb.vvp -y ../lib testbench/adder_tb.v
// command: vvp testbench/adder_tb.vvp