module extender_tb;

	// Parameters
	localparam CLOCK_PERIOD = 2000;
	parameter INPUT_WIDTH = 4;
	parameter OUTPUT_WIDTH = 32;

	// Signals
	reg [INPUT_WIDTH-1:0] data_in;
	wire [OUTPUT_WIDTH-1:0] data_out [1:0];

	// Instantiate the extender module
	extender #(
		.TYPE("ZERO"),
		.INPUT_WIDTH(INPUT_WIDTH),
		.OUTPUT_WIDTH(OUTPUT_WIDTH)
	) zero_ex (
		.data_in(data_in),
		.data_out(data_out[0])
	);

	extender #(
		.TYPE("SIGN"),
		.INPUT_WIDTH(INPUT_WIDTH),
		.OUTPUT_WIDTH(OUTPUT_WIDTH)
	) sign_ex (
		.data_in(data_in),
		.data_out(data_out[1])
	);



	// Clock generation
	reg clk;
	always #(CLOCK_PERIOD/2) clk = ~clk;

	// Test stimulus
	initial begin
		// Dump VCD file
		$dumpfile("testbench/extender_tb.vcd");
		$dumpvars(0, extender_tb);

		clk = 0;
		data_in = 4'b0;

		for (data_in = 4'b0; data_in < 4'b1111; data_in = data_in + 1) begin
			#CLOCK_PERIOD;
		end

		$finish;
	end

endmodule