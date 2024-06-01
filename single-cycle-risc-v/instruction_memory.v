module instruction_memory #(
	parameter ADDR_WIDTH = 4,
	parameter PROGRAM = ""
)(
	input [ADDR_WIDTH-1:0] addr,
	output [31:0] data
);
	localparam DATA_WIDTH = 32;
	localparam INSTRUCTIONS = (PROGRAM == "test") ? 15 : (PROGRAM == "sorter") ? 90 : 0;
	wire [INSTRUCTIONS*DATA_WIDTH-1:0] data_list;

	if (INSTRUCTIONS == 0) begin
		// Throw an error for invalid configuration
		no_such_program_defined error();
	end

	generate
		case (PROGRAM)
			"test": begin
				assign data_list = {
					32'h00007013,	// andi x0, x0, 0
					32'h00002023,	// sw x0, 0(x0)
					32'h00002083,	// lw x1, 0(x0) 
					32'h00f08093,	// addi x1, x1, 15
					32'h02008113,	// addi x2, x1, 32
					32'h001101b3,	// add x3, x2, x1
					32'h40118233,	// sub x4, x3, x1
					32'h0020a2b3,	// slt x5, x1, x2
					32'h0041e333,	// or x6, x3, x4
					32'h002373b3,	// and x7, x6, x2
					32'h0100046f,	// jal x8, target1
					32'h00502113,	//target2: slti x2, x0, 5
					32'h1000e093,	// ori x1, x1, 256
					32'h00a3f493,	// andi x9, x7, 10
					32'hfe410ae3	//target1: beq x2, x4, target2
				};
			end
			"sorter" : begin
				assign data_list = {
					32'h00007013,	// andi x0, x0, 0
					// Initialize the array
					32'h00300093,	// addi x1, x0, 3
					32'h00102023,	// sw x0, 0(x1)
					32'h00700093,
					32'h001020a3,
					32'h00200093,
					32'h00102123,
					32'h00600093,
					32'h001021a3,
					32'h00500093,
					32'h00102223,
					32'h00400093,
					32'h001022a3,
					32'h00100093,
					32'h00102323,
					32'h3e800093,
					32'h001023a3,
					32'h3e700093,
					32'h00102423,
					32'h01900093,
					32'h001024a3,
					32'h05a00093,
					32'h00102523,
					32'h06400093,
					32'h001025a3,
					32'h01e00093,
					32'h00102623,
					32'h01400093,
					32'h001026a3,
					32'h00a00093,
					32'h00102723,
					32'h0c800093,
					32'h001027a3,
					32'h7d000093,
					32'h51408093,
					32'h00102823,
					32'h0fa00093,
					32'h001028a3,
					32'h00c00093,
					32'h00102923,
					32'h04b00093,
					32'h001029a3,
					32'h01100093,
					32'h00102a23,
					32'h00d00093,
					32'h00102aa3,
					32'h01200093,
					32'h00102b23,
					32'h00e00093,
					32'h00102ba3,
					32'h00f00093,
					32'h00102c23,
					32'h01000093,
					32'h00102ca3,
					32'h01300093,
					32'h00102d23,
					32'h00100093,
					32'h00102da3,
					32'h00200093,
					32'h00102e23,
					32'h00900093,
					32'h00102ea3,
					32'h00600093,
					32'h00102f23,
					32'h00500093,
					32'h00102fa3,
					32'h00800093,
					32'h02102023,
					32'h00a00093,
					32'h021020a3,
					32'h00c00093,
					32'h02102123,
					32'h00400093,
					32'h021021a3,
					32'h00000093,
					32'h02102223,
					32'h00300093,
					32'h021022a3,
					32'h00b00093,
					32'h02102323,
					32'h00700093,
					32'h021023a3,
					// Sort the array
					32'h0000f093,	// andi x1, x1, 0
					32'h01408293,	// addi x5, x1, 20
					32'h0000a103,	// loop: lw x2, 0(x1)
					32'h0140a183,	// lw x3, 20(x1)
					32'h0221a423,	// sw x2, 40(x3)
					32'h00108093,	// addi x1, x1, 1
					32'h00508463,	// beq x1, x5, break
					32'hfedff26f	// jal x4, loop
									// break:
				};
			end
			default : no_program_selected error();
		endcase
	endgenerate

	read_only_memory #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_COUNT(INSTRUCTIONS)
	) rom1 (
		.data_list(data_list),
		.addr(addr),
		.data_out(data)
	);
endmodule
