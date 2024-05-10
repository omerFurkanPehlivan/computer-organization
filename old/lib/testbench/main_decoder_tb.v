`timescale 1ns / 1ns

module main_decoder_tb;

	// Parameters
	localparam DELAY = 500;

	// Inputs
	reg [6:0] op;

	// Outputs
	wire branch;
	wire jump;
	wire [1:0] result_src;
	wire mem_write;
	wire alu_src;
	wire [1:0] imm_src;
	wire reg_write;
	wire [1:0] alu_op;

	// Instantiate the main_decoder module
	main_decoder dut (
		.op(op),
		.branch(branch),
		.jump(jump),
		.result_src(result_src),
		.mem_write(mem_write),
		.alu_src(alu_src),
		.imm_src(imm_src),
		.reg_write(reg_write),
		.alu_op(alu_op)
	);

	initial begin
		// Dump VCD file
		$dumpfile("testbench/main_decoder_tb.vcd");
		$dumpvars(0, main_decoder_tb);

		op = 7'b0000000; // Test case 1: op = 0h
		#DELAY;
		op = 7'b0000011; // Test case 2: op = 3h / lw
		#DELAY;
		op = 7'b0100011; // Test case 3: op = 23h / sw
		#DELAY;
		op = 7'b0110011; // Test case 4: op = 33h / r_type
		#DELAY;
		op = 7'b1100011; // Test case 5: op = 63h / beq
		#DELAY;
		op = 7'b0010011; // Test case 6: op = 13h / i_type_alu
		#DELAY;
		op = 7'b1101111; // Test case 7: op = 6Fh / jal
		#DELAY;
		$finish;
	end

endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/main_decoder_tb.vvp -y ../lib testbench/main_decoder_tb.v
// command: vvp testbench/main_decoder_tb.vvp