`timescale 1ns/1ns
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

	reg [31:0] pc_next_rst;
	reg clk;
	wire rst;

	// Clock
	initial clk = 0;
	always #(CLOCK_PERIOD / 2) clk = ~clk;

	// Reset
	power_on_reset power_on_reset1 (rst);

	// PC Next
	mux #(
		.WIDTH(32),
		.SEL_WIDTH(1)
	) mux_pc_next (
		.data_list({pc_target, pc_plus_4}),
		.sel(pc_src),
		.data_out(pc_next)
	);

	// PC Next Reset
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			#5 pc_next_rst <= 32'h0;
		end else begin
			#5 pc_next_rst <= pc_next;
		end
	end

	// PC Register
	register #(
		.WIDTH(32)
	) reg_pc (
		.clk(clk),
		.rst(rst),
		.data_in(pc_next_rst),
		.data_out(pc)
	);

	// Instruction Memory
	instruction_memory #(
		.WIDTH(32),
		.ADDR_WIDTH(16)
	) instruction_memory (
		.addr(pc[15:0]),
		.clk(clk),
		.rst(rst),
		.data_out(instruction)
	);

	// Adder PC + 4
	adder #(
		.WIDTH(32)
	) adder_pc_plus_4 (
		.a(pc),
		.b(32'h4),
		.sum(pc_plus_4),
		.cin(1'b0)
	);

	// Control Unit
	control_unit control_unit1 (
		.op(instruction[6:0]),
		.funct3(instruction[14:12]),
		.funct7_5(instruction[30]),
		.zero(zero),
		.pc_src(pc_src),
		.result_src(result_src),
		.mem_write(mem_write),
		.alu_control(alu_control),
		.alu_src(alu_src),
		.imm_src(imm_src),
		.reg_write(reg_write)
	);

	// Register File
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

	// Immediate Extender
	immediate_extender immediate_extender1 (
		.instr(instruction[31:7]),
		.imm_src(imm_src),
		.imm(imm_ext)
	);

	// Mux Source B
	mux #(
		.WIDTH(32),
		.SEL_WIDTH(1)
	) mux_src_b (
		.data_list({imm_ext, write_data}),
		.sel(alu_src),
		.data_out(src_b)
	);

	// ALU
	alu alu1 (
		.a(src_a),
		.b(src_b),
		.alu_control(alu_control),
		.result(alu_result),
		.zero(zero)
	);

	// Adder PC Target
	adder #(
		.WIDTH(32)
	) adder_pc_target (
		.a(pc),
		.b(imm_ext),
		.sum(pc_target),
		.cin(1'b0)
	);

	// Data Memory
	data_memory data_memory1 (
		.address(alu_result),
		.write_data(write_data),
		.clk(clk),
		.write_enable(mem_write),
		.read_data(read_data)
	);

	// Mux Result
	mux #(
		.WIDTH(32),
		.SEL_WIDTH(2)
	) mux_result (
		.data_list({{32{1'bx}}, pc_plus_4, read_data, alu_result}),
		.sel(result_src),
		.data_out(result)
	);
endmodule
