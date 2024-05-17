module control_unit (
	input [6:0] op,
	input [2:0] funct3,
	input funct7_5, 
	input zero,
	output pc_src,
	output [1:0] result_src,
	output mem_write,
	output [2:0] alu_control,
	output alu_src,
	output [1:0] imm_src,
	output reg_write
);

	wire branch, jump, zero_and_branch;
	wire [1:0] alu_op;

	// PC Source
	gates #(
		.TYPE("AND")
	) and1 (
		.a(branch),
		.b(zero),
		.out(zero_and_branch)
	);

	gates #(
		.TYPE("OR")
	) or1 (
		.a(zero_and_branch),
		.b(jump),
		.out(pc_src)
	);

	main_decoder main_decoder1 (
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

	alu_decoder alu_decoder1 (
		.alu_op(alu_op),
		.op_5(op[5]),
		.funct3(funct3),
		.funct7_5(funct7_5),
		.alu_control(alu_control)
	);
endmodule