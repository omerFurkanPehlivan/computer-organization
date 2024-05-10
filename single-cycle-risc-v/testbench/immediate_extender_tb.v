`timescale 1ns/1ns

module immediate_extender_tb;
	localparam DELAY = 200;

	reg [31:0] instr;
	reg [1:0] imm_src;
	wire [31:0] imm;

	immediate_extender dut (
		.instr(instr[31:7]),
		.imm_src(imm_src),
		.imm(imm)
	);

	initial begin
		$dumpfile("testbench/immediate_extender_tb.vcd");
		$dumpvars(0, immediate_extender_tb);

		// Test case 1 - I instruction
		instr = 32'h01234567; // instruction
		imm_src = 2'b00; // I immediate source
		#DELAY;

		// Test case 2 - S instruction
		imm_src = 2'b01; // S immediate source
		#DELAY;

		// Test case 3 - B instruction
		imm_src = 2'b10; // B immediate source
		#DELAY;

		// Test case 4 - J instruction
		imm_src = 2'b11; // J immediate source
		#DELAY;

		$finish;
	end
endmodule