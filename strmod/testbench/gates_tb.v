module gates_tb;
	reg a, b;
	wire [8:0] out;

	gates #(.TYPE("AND"), .DELAY(10)) and_gate (.a(a), .b(b), .out(out[0]));
	gates #(.TYPE("OR"), .DELAY(10)) or_gate (.a(a), .b(b), .out(out[1]));
	gates #(.TYPE("NAND"), .DELAY(10)) nand_gate (.a(a), .b(b), .out(out[2]));
	gates #(.TYPE("NOR"), .DELAY(10)) nor_gate (.a(a), .b(b), .out(out[3]));
	gates #(.TYPE("XOR"), .DELAY(10)) xor_gate (.a(a), .b(b), .out(out[4]));
	gates #(.TYPE("XNOR"), .DELAY(10)) xnor_gate (.a(a), .b(b), .out(out[5]));
	gates #(.TYPE("NOT"), .DELAY(10)) not_gate (.a(a), .out(out[6]));
	gates #(.TYPE("BUF"), .DELAY(10)) buf_gate (.a(a), .out(out[7]));
	gates #(.TYPE("BUFIF1"), .DELAY(10)) bufif1_gate (.a(a), .b(b), .out(out[8]));

	initial begin
		// Dump VCD file
		$dumpfile("testbench/gates_tb.vcd");
		$dumpvars(0, gates_tb);
		
		#20 a = 0; b = 0;
		#20 a = 0; b = 1;
		#20 a = 1; b = 0;
		#20 a = 1; b = 1;
		#20;

		$finish;
	end

endmodule