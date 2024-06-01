module control_unit (
	input [6:0] op,
	input [2:0] funct3,
	input funct7_5,
		zero,
	output reg pc_src,
	output [1:0] result_src,
	output mem_write,
	output alu_src,
	output [1:0] imm_src,
	output reg_write,
	output [2:0] alu_control
);
	wire [1:0] alu_op;
	wire branch, jump;
	main_decoder main_decoder (
		.zero(zero),
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

	alu_decoder alu_decoder (
		.op_5(op[5]),
		.funct3(funct3),
		.funct7_5(funct7_5),
		.alu_op(alu_op),
		.alu_control(alu_control)
	);

	always @* pc_src = (branch & zero) | jump;
endmodule

