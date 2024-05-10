`timescale 1ns/1ns

module decoder_tb;
    // Parameters
    parameter WIDTH = 3;
	parameter DELAY = 200;
    
    // Inputs
    reg [WIDTH-1:0] a;
    reg en;
    
    // Outputs
    wire [2**WIDTH-1:0] out;
    
    // Instantiate the decoder module
    decoder #(.WIDTH(WIDTH)) decoder_1 (.a(a), .en(en), .out(out));
    
	// Integer for loop
    integer i;

    // Test stimulus
    initial begin
		// Dump VCD file
		$dumpfile("testbench/decoder_tb.vcd");
		$dumpvars(0, decoder_tb);

        // Initialize inputs
        a = 0;
        en = 0;
        
        // Apply test vectors
		for (i = 0; i < 2 ** WIDTH; i = i + 1) begin
			en = 0;
			a = i;

			#DELAY;
			en = 1;
			#DELAY;
		end
        // Add more test vectors as needed
        
        // End simulation
        #10 $finish;
    end
endmodule

// current directory: 21011056/Q1/lib
// command: iverilog -o testbench/decoder_tb.vvp -y ../lib testbench/decoder_tb.v
// command: vvp testbench/decoder_tb.vvp