module main_decoder (
	input [6:0] op,
	output branch,
	output jump,
	output [1:0] result_src,
	output mem_write,
	output alu_src,
	output [1:0] imm_src,
	output reg_write,
	output [1:0] alu_op
);
	wire [6:0] op_inv;
	wire lw, sw, r_type, beq, i_type_alu, jal;

	// Select the operation
	// Effected by the operatoion number
	localparam SELECT_BITS = 3;
	wire [SELECT_BITS-1:0] select;

	// Valid if any of the operation is selected
	wire valid;

	// Invert the opcode
	DelayNot not1 [6:0] (.a(op), .out(op_inv));

	// Enable lw if opcode is 0000011
	n_input_and #(
		.N(7)
	) and_lw (
		.a({
			op_inv[6],
			op_inv[5],
			op_inv[4],
			op_inv[3],
			op_inv[2],
			op[1],
			op[0]
		}),
		.out(lw)
	);

	// Enable sw if opcode is 0100011
	n_input_and #(
		.N(7)
	) and_sw (
		.a({
			op_inv[6],
			op[5],
			op_inv[4],
			op_inv[3],
			op_inv[2],
			op[1],
			op[0]
		}),
		.out(sw)
	);

	// Enable r_type if opcode is 0110011
	n_input_and #(
		.N(7)
	) and_r_type (
		.a({
			op_inv[6],
			op[5],
			op[4],
			op_inv[3],
			op_inv[2],
			op[1],
			op[0]
		}),
		.out(r_type)
	);

	// Enable beq if opcode is 1100011
	n_input_and #(
		.N(7)
	) and_beq (
		.a({
			op[6],
			op[5],
			op_inv[4],
			op_inv[3],
			op_inv[2],
			op[1],
			op[0]
		}),
		.out(beq)
	);

	// Enable i_type_alu if opcode is 0010011
	n_input_and #(
		.N(7)
	) and_i_type_alu (
		.a({
			op_inv[6],
			op_inv[5],
			op[4],
			op_inv[3],
			op_inv[2],
			op[1],
			op[0]
		}),
		.out(i_type_alu)
	);

	// Enable jal if opcode is 1101111
	n_input_and #(
		.N(7)
	) and_jal (
		.a({
			op[6],
			op[5],
			op_inv[4],
			op[3],
			op[2],
			op[1],
			op[0]
		}),
		.out(jal)
	);	

	// First operation is the highest priority
	priority_encoder #(
		.OUTPUT_WIDTH(SELECT_BITS)
	) priority_encoder1 (
		.a({
			lw,			//111
			sw,			//110
			r_type,		//101
			beq,		//100
			i_type_alu,	//011
			jal,		//010
			2'b0
		}),
		.out(select),
		.valid(valid)
	);

	// Look up to priority encoder for the selected operation
	// 
	mux #(
		.SELECT_BITS(SELECT_BITS),
		.DATA_WIDTH(11)
	) mux1 (
		.data_list({
			11'b1_00_1_0_01_0_00_0,
			11'b0_01_1_1_xx_0_00_0,
			11'b1_xx_0_0_00_0_10_0,
			11'b0_10_0_0_xx_1_01_0,
			11'b1_00_1_0_00_0_10_0,
			11'b1_11_x_0_10_0_xx_1,
			{((1<<SELECT_BITS)-6){11'b0}}
		}),
		.select(select),
		.data_out({reg_write, imm_src, alu_src, mem_write, result_src, branch, alu_op, jump})
	);

endmodule
