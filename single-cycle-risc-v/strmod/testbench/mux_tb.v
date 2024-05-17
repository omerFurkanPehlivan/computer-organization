`timescale 1ns/1ns

module mux_tb;
	// Parameters
	parameter SELECT_BITS = 3;
	parameter DATA_WIDTH = 8;
	parameter DELAY = 2000;
	
	// Inputs
	//reg [DATA_WIDTH-1:0] data_list [(1 << SELECT_BITS) - 1:0];
	reg [SELECT_BITS-1:0] select;
	reg [(DATA_WIDTH * (1 << SELECT_BITS)) - 1:0] flattened_data_list;

	// Wires
	//wire [(DATA_WIDTH * (1 << SELECT_BITS)) - 1:0] flattened_data_list;

	// Flatten the data_list
	/*generate
		genvar i, j;
		for (i = 0; i < (1 << SELECT_BITS); i = i + 1) begin: flatten_data_list
			assign flattened_data_list[i * DATA_WIDTH +: DATA_WIDTH] = data_list[i];
		end
	endgenerate*/
	
	// Outputs
	wire [DATA_WIDTH-1:0] data_out;
	
	// Instantiate the mux module
	mux #(
		.SELECT_BITS(SELECT_BITS),
		.DATA_WIDTH(DATA_WIDTH)
	) dut (
		.data_list(flattened_data_list),
		.select(select),
		.data_out(data_out)
	);
	
	
	// Test stimulus
	integer iter;
	initial begin
		// Dump VCD file
		$dumpfile("testbench/mux_tb.vcd");
		$dumpvars(0, mux_tb);

		flattened_data_list = {8'hAB, 8'hCD, 8'hEF, 8'h01, 8'h23, 8'h45, 8'h67, 8'h89};
		select = 0;
		
		#(DELAY/4);

		for (iter = 0; iter < (1 << SELECT_BITS); iter = iter + 1) begin
			select = iter;
			#DELAY;
		end

		$finish;
	end
	
endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/mux_tb.vvp -y ../lib testbench/mux_tb.v
// command: vvp testbench/mux_tb.vvp
