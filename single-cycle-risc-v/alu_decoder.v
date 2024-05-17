module alu_decoder (
	input [1:0] alu_op,
	input [2:0] funct3,
	input op_5,
	input funct7_5,
	output [2:0] alu_control
);
	wire [2:0] mux_op5_funct7_5_out,
		mux_funct3_out,
		mux_alu_op_out;
	wire [1:0] funct_3_encoded;
	wire op5_and_funct7_5,
		funct3_0h,
		funct3_2h,
		funct3_6h,
		funct3_7h;

	// Encoder for FUNCT3
	wire [2:0] funct3_bar;
	gates #(
		.TYPE("NOT")
	) not_funct3 [2:0] (
		.a(funct3), 
		.out(funct3_bar)
	);

	n_input_gates #(
		.TYPE("AND"),
		.N(3)
	) and_funct3_0h (
		.a(
			funct3_bar
		),
		.out(funct3_0h)
	);

	n_input_gates #(
		.TYPE("AND"),
		.N(3)
	) and_funct3_2h (
		.a({
			funct3_bar[2],
			funct3[1],
			funct3_bar[0]
		}),
		.out(funct3_2h)
	);

	n_input_gates #(
		.TYPE("AND"),
		.N(3)
	) and_funct3_6h (
		.a({
			funct3[2],
			funct3[1],
			funct3_bar[0]
		}),
		.out(funct3_6h)
	);

	n_input_gates #(
		.TYPE("AND"),
		.N(3)
	) and_funct3_7h (
		.a(
			funct3
		),
		.out(funct3_7h)
	);

	priority_encoder #(
		.OUTPUT_WIDTH(2)
	) encoder_funct3 (
		.a({
			funct3_7h,
			funct3_6h,
			funct3_2h,
			funct3_0h
		}),
		.out(funct_3_encoded)
	);


	// Mux for ALU_OP
	mux #(
		.SELECT_BITS(2),
		.DATA_WIDTH(3)
	) mux_alu_op (
		.data_list({
			3'bxxx,	// alu_op = 3h
			mux_funct3_out,	// alu_op = 2h
			3'b001,	// alu_op = 1h
			3'b000	// alu_op = 0h
			}),
		.select(alu_op),
		.data_out(alu_control)
	);

	// Mux for FUNCT3
	mux #(
		.SELECT_BITS(2),
		.DATA_WIDTH(3)
	) mux_funct3 (
		.data_list({
			3'b010,	// funct3 = 7h
			3'b011,	// funct3 = 6h
			3'b101,	// funct3 = 2h
			mux_op5_funct7_5_out	// funct3 = 0h
			}),
		.select(funct_3_encoded),
		.data_out(mux_funct3_out)
	);

	// Mux for OP_5
	// op_5 & funct7_5
	gates #(
		.TYPE("AND")
	) and_op5_funct7_5 (
		.a(op_5),
		.b(funct7_5),
		.out(op5_and_funct7_5)
	);

	mux #(
		.SELECT_BITS(1),
		.DATA_WIDTH(3)
	) mux_op5 (
		.data_list({
			3'b001,	// op_5 & funct7_5 = 1h
			3'b000	// op_5 & funct7_5 = 0h
			}),
		.select(op5_and_funct7_5),
		.data_out(mux_op5_funct7_5_out)
	);

endmodule
