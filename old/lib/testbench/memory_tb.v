`timescale 1ns / 1ns
module memory_tb;
    reg [31:0] data_in;
    reg clk;
    wire [31:0] data_out;

	parameter delay = 2000;

    // Instantiate the memory module
    memory_1x32bit dut (
        .data_in(data_in),
        .clk(clk),
        .data_out(data_out)
    );

    // Clock generation
    always #(delay/2) clk = ~clk;

    // Stimulus
    initial begin
		//dump vcd file
		$dumpfile("testbench/memory_tb.vcd");
		$dumpvars(0, memory_tb);

        // Initialize inputs
        data_in = 32'h00000000;
        clk = 0;
		
		#(delay/4);

        // Apply test vectors
        #delay data_in = 32'h12345678;
        #delay data_in = 32'hABCDEF01;
        #delay data_in = 32'h87654321;
		#delay;

        // Add more test vectors as needed

        // Finish simulation
    	$finish;
    end

endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/memory_tb.vvp -y ../lib testbench/memory_tb.v
// command: vvp testbench/memory_tb.vvp