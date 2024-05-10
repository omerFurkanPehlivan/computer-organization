`timescale 1ns / 1ns

module datapath;
	localparam DATA_WIDTH = 32,
		INSTRUCTIN_MEMORY_ADDR_WIDTH = 5,
		REGISTER_ADDR_WIDTH = 5,
		DATA_MEMORY_ADDR_WIDTH = 5,
		CLOCK_PERIOD = 2000, // 2 us / 500 KHz
		GATE_DELAY = 10; // 10 ns
	
	input rst;
	
	// Internal Output Signals
	// PC Next Mux
	wire [DATA_WIDTH-1:0] pc_next;
	// PC
	wire [DATA_WIDTH-1:0] pc;
	// Instruction Memory
	wire [DATA_WIDTH-1:0] instruction;
	// PCPlus4 Adder
	wire [DATA_WIDTH-1:0] pc_plus_4;
	// Control Unit
	wire pc_src;
	wire [1:0] result_src;
	wire mem_write;
	wire [2:0] alu_control;
	wire alu_src;
	wire [1:0] imm_src;
	wire reg_write;
	// Register File
	wire [DATA_WIDTH-1:0] src_a, write_data;
	// Immidiate Extender
	wire [DATA_WIDTH-1:0] imm_ext;
	// ALU B Mux
	wire [DATA_WIDTH-1:0] alu_b;
	// ALU
	wire [DATA_WIDTH-1:0] alu_result;
	wire zero;
	// PCTarget Adder
	wire [DATA_WIDTH-1:0] pc_target;
	// Data Memory
	wire [DATA_WIDTH-1:0] memory_read_data;
	// Result Mux
	wire [DATA_WIDTH-1:0] result;
	// Clock
	wire clk;

	// Components

	// Mux for next Instruction Address
	// Higher index comes first in data_list
	mux #(
		.SELECT_BITS(1),
		.DATA_WIDTH(DATA_WIDTH)
	) pc_next_mux (
		.data_list({pc_target, pc_plus_4}),
		.select(pc_src),
		.data_out(pc_next)
	);

	// Program Counter
	register_edge #(
		.WORD_SIZE(DATA_WIDTH)
	) program_counter (
		.data_in(pc_next),
		.clk(clk),
		.data_out(pc)
	);

	// Instruction Memory
	// Instruction data need to be changed in instruction_memory.v
	instruction_memory instruction_memory1 (
		.addr(pc[INSTRUCTIN_MEMORY_ADDR_WIDTH-1:0]),
		.data(instruction)
	);

	// PCPlus4 Adder
	adder #(
		.WIDTH(DATA_WIDTH)
	) pc_plus_4_adder (
		.a(pc),
		.b(32'h4),
		.cin(1'b0),
		.sum(pc_plus_4),
		.cout()
	);

	// Control Unit
	control_unit control_unit1 (
		.op(instruction[6:0]),
		.funct3(instruction[14:12]),
		.funct7_5(instruction[30]),
		.zero(),
		.pc_src(pc_src),
		.result_src(result_src),
		.mem_write(mem_write),
		.alu_control(alu_control),
		.alu_src(alu_src),
		.imm_src(imm_src),
		.reg_write(reg_write)
	);

	// Register File
	register_file #(
		.WORD_SIZE(DATA_WIDTH),
		.ADDR_WIDTH(REGISTER_ADDR_WIDTH)
	) register_file1 (
		.read_addr1(instruction[19:15]),
		.read_addr2(instruction[24:20]),
		.write_addr(instruction[11:7]),
		.data_in(result),
		.clk(clk),
		.write_enable(reg_write),
		.read_data1(src_a),
		.read_data2(write_data)
	);

	// Immediate Extender
	imm_extend_32 imm_extend1_32 (
		.instr(instruction[31:7]),
		.imm_src(imm_src),
		.imm(imm_ext)
	);

	// ALU B Mux
	mux #(
		.SELECT_BITS(1),
		.DATA_WIDTH(DATA_WIDTH)
	) alu_b_mux (
		.data_list({imm_ext, write_data}),
		.select(alu_src),
		.data_out(alu_b)
	);

	// ALU
	alu #(
		.WIDTH(DATA_WIDTH)
	) alu1 (
		.a(src_a),
		.b(alu_b),
		.alu_control(alu_control),
		.result(alu_result),
		.carry(),
		.zero(zero),
		.overflow()
	);

	// PCTarget Adder
	adder #(
		.WIDTH(DATA_WIDTH)
	) pc_target_adder (
		.a(pc),
		.b(imm_ext),
		.cin(1'b0),
		.sum(pc_target),
		.cout()
	);

	// Data Memory
	random_access_memory #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(DATA_MEMORY_ADDR_WIDTH)
	) data_memory (
		.data_in(write_data),
		.addr(alu_result),
		.clk(clk),
		.write_enable(mem_write),
		.data_out(memory_read_data)
	);

	// Result Mux
	mux #(
		.SELECT_BITS(2),
		.DATA_WIDTH(DATA_WIDTH)
	) result_mux (
		.data_list({
			{DATA_WIDTH{1'bx}},	// 11
			pc_plus_4,			// 10
			memory_read_data,	// 01
			alu_result			// 00
		}),
		.select(result_src),
		.data_out(result)
	);

	// Clock
	clock #(
		.CLOCK_PERIOD(CLOCK_PERIOD)
	) clock1 (
		.rst(rst),
		.clk_out(clk)
	);

endmodule