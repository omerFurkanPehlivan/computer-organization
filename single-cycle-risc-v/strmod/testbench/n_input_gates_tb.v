`timescale 1ns / 1ns

module n_input_gates_tb;
	reg [7:0] a;
	wire out_and_4, out_and_8, out_or_4, out_or_8;

	// Test case for TYPE = "AND", N = 4
	n_input_gates #(.TYPE("AND"), .N(4)) dut_and_4 (
		.a(a[3:0]),
		.out(out_and_4)
	);
	
	// Test case for TYPE = "AND", N = 8
	n_input_gates #(.TYPE("AND"), .N(8)) dut_and_8 (
		.a(a),
		.out(out_and_8)
	);
	
	// Test case for TYPE = "OR", N = 4
	n_input_gates #(.TYPE("OR"), .N(4)) dut_or_4 (
		.a(a[3:0]),
		.out(out_or_4)
	);
	
	// Test case for TYPE = "OR", N = 8
	n_input_gates #(.TYPE("OR"), .N(8)) dut_or_8 (
		.a(a),
		.out(out_or_8)
	);

	initial begin
		$dumpfile("testbench/n_input_gates_tb.vcd");
		$dumpvars(0, n_input_gates_tb);

		for (a = 0; a < (1 << 8) - 1 ; a = a + 1) begin
			#100;
		end

		#100;
		$finish;
	end



endmodule