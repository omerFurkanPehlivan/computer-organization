`timescale 1ns / 1ns

module alu_tb;
	// Parameters
	parameter WIDTH = 32;
	parameter DELAY = 2000;

	// Inputs
	reg [WIDTH-1:0] a, b;
	reg [2:0] alu_control;

	// Outputs
	wire [WIDTH-1:0] result;
	wire carry, zero, overflow;

	// Instantiate the alu module
	alu #(.WIDTH(WIDTH)) dut (
		.a(a),
		.b(b),
		.alu_control(alu_control),
		.result(result),
		.carry(carry),
		.zero(zero),
		.overflow(overflow)
	);

	// Test stimulus
	initial begin
		// Dump VCD file
		$dumpfile("testbench/alu_tb.vcd");
		$dumpvars(0, alu_tb);

		#DELAY;

		a = 32'h00000001;
		b = 32'h00000002;
		alu_control = 3'b000; // Add
		#DELAY;

		a = 32'hFEFEFEFE;
		b = 32'hABABABAB;
		alu_control = 3'b000; // Add
		#DELAY;

		a = 32'hCAFECAFE;
		b = 32'hFACEFACE;
		alu_control = 3'b000; // Add
		#DELAY;

		a = 32'hFFFFFFFF;
		b = 32'hFFFFFFFF;
		alu_control = 3'b000; // Add
		#DELAY;

		a = 32'hFFFFFFFF;
		b = 32'h00000001;
		alu_control = 3'b000; // Add
		#DELAY;

		a = 32'h00000003;
		b = 32'h00000002;
		alu_control = 3'b001; // Subtract
		#DELAY;

		a = 32'h00000002;
		b = 32'h00000003;
		alu_control = 3'b001; // Subtract
		#DELAY;

		a = 32'h00000003;
		b = 32'h00000002;
		alu_control = 3'b010; // AND
		#DELAY;

		a = 32'h00000003;
		b = 32'h00000002;
		alu_control = 3'b011; // OR
		#DELAY;

		a = 32'h80000000;
		b = 32'h80000000;
		alu_control = 3'b101; // SLT
		#DELAY;
		
		a = 32'h70000000;
		b = 32'h80000000;
		alu_control = 3'b101; // SLT
		#DELAY;
		
		a = 32'h80000000;
		b = 32'h70000000;
		alu_control = 3'b101; // SLT
		#DELAY;
		
		a = 32'h00000001;
		b = 32'h00000002;
		alu_control = 3'b101; // SLT
		#DELAY;
		
		a = 32'h00000002;
		b = 32'h00000001;
		alu_control = 3'b101; // SLT
		#DELAY;
	
		// End simulation
		$finish;
	end

endmodule