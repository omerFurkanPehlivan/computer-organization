module n_input_or_tb;
	reg [31:0] a;
	wire out;
	
	n_input_or #(.N(32)) n_input_or_inst (.a(a), .out(out));
	
	integer i;

	initial begin
		$dumpfile("testbench/n_input_or_tb.vcd");
		$dumpvars(0, n_input_or_tb);

		for (i = 0; i < 2 ** 7; i = i + 1) begin
			a = i;
			#10;
		end

		a = 0;
		#10;
		$finish;
	end

endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/n_input_or_tb.vvp -y ../lib testbench/n_input_or_tb.v
// command: vvp testbench/n_input_or_tb.vvp