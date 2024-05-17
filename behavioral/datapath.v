module datapath;
	localparam CLOCK_PERIOD = 10;
	
	wire [31:0] pc_next,
		pc,
		pc_plus_4,
		instruction,
		imm_ext,
		write_data,
		src_a,
		src_b,
		alu_result,
		pc_target,
		read_data,
		result;
	wire [2:0] alu_control;
	wire [1:0] result_src,
		imm_src;
	wire pc_src,
		mem_write,
		alu_src,
		reg_write,
		zero;

	reg clk;

	// Clock
	initial clk = 0;
	always #(CLOCK_PERIOD / 2) clk = ~clk;

	mux #(
		.WIDTH(32),
		.SEL_WIDTH(1)
	) mux_pc_next (
		.data_list({pc_target, pc_plus_4}),
		.sel(pc_src),
		.data_out(pc_next)
	);

	register #(
		.WIDTH(32)
	) reg_pc (
		.clk(clk),
		.data_in(pc_next),
		.data_out(pc)
	);

	instruction_memory #(
		.WIDTH(32),
		.ADDR_WIDTH(32)
	
	) instruction_memory (
		.addr(pc),
		.data_out(instruction)
	);

	adder #(
		.WIDTH(32)
	) adder_pc_plus_4 (
		.a(pc),
		.b(32'h4),
		.sum(pc_plus_4)
		.cin(1'b0)
	);

	register_file register_file1 (
		.addr1(instruction[19:15]),
		.addr2(instruction[24:20]),
		.addr3(instruction[11:7]),
		.data_in(result),
		.clk(clk),
		.write_enable(reg_write),
		.data_out1(src_a),
		.data_out2(write_data)
	);

	immediate_extender immediate_extender1 (
		.instr(instruction[31:7]),
		.imm_src(imm_src),
		.imm(imm_ext)
	);

	mux #(
		.WIDTH(32),
		.SEL_WIDTH(1)
	) mux_src_b (
		.data_list({imm_ext, write_data}),
		.sel(alu_src),
		.data_out(src_b)
	);

	alu alu1 (
		.a(src_a),
		.b(src_b),
		.alu_control(alu_control),
		.result(alu_result),
		.zero(zero)
	);

	adder #(
		.WIDTH(32)
	) adder_pc_target (
		.a(pc),
		.b(imm_ext),
		.sum(pc_target)
		.cin(1'b0)
	);

	data_memory data_memory1 (
		.address(alu_result),
		.write_data(write_data)
		.clk(clk),
		.write_enable(mem_write),
		.read_data(read_data),
	);

	mux #(
		.WIDTH(32),
		.SEL_WIDTH(2)
	) mux_result (
		.data_list({32{1'bx}, read_data, alu_result}),
		.sel(result_src),
		.data_out(result)
	);


endmodule