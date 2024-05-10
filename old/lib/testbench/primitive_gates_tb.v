`timescale 1ns/1ns

module primitive_gates_tb;
	reg a, b;
	wire [8:0]out;

	DelayAnd and_gate (a, b, out[0]);
	DelayOr or_gate (a, b, out[1]);
	DelayNand nand_gate (a, b, out[2]);
	DelayNor nor_gate (a, b, out[3]);
	DelayXor xor_gate (a, b, out[4]);
	DelayXnor xnor_gate (a, b, out[5]);
	DelayNot not_gate (a, out[6]);
	DelayBuf buf_gate (a, out[7]);
	DelayBufIf1 bufif1_gate (a, b, out[8]);

	initial begin
		$dumpfile("testbench/primitive_gates_tb.vcd");
		$dumpvars(0, primitive_gates_tb);
		a = 0; b = 0;
		#20 a = 0; b = 1;
		#20 a = 1; b = 0;
		#20 a = 1; b = 1;
		#20 $finish;
	end
endmodule

// current directory: 21011056/Q1/lib/
// command: iverilog -o testbench/primitive_gates_tb.vvp primitive_gates.v testbench/primitive_gates_tb.v
// command: vvp testbench/primitive_gates_tb.vvp