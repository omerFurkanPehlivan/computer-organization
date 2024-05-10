module immediate_extender (
	input [31:7] instr,
	input [1:0] imm_src,
	output [31:0] imm
);
	mux #(
		.SELECT_BITS(2),
		.DATA_WIDTH(32)
	) mux1 (
		.data_list({
			{{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}, // 11 - J
			{{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}, // 10 - B
			{{20{instr[31]}}, instr[31:25], instr[11:7]}, // 01 - S
			{{20{instr[31]}}, instr[31:20]} // 00 - I
		}),
		.select(imm_src),
		.data_out(imm)
	);
endmodule