`timescale 1ns / 1ns

module register_tb;
	parameter WORD_SIZE = 32;
	localparam CLOCK_PERIOD = 1000;

    // Inputs
    reg [WORD_SIZE-1:0] data_in;
    reg enable;
    reg clk;
    
    // Outputs
    wire [WORD_SIZE-1:0] data_out [1:0];
	wire data_out_1;
    
    // Instantiate the register module
    register #(
        .TRIGGER("LEVEL"),
        .WORD_SIZE(WORD_SIZE)
	) reg_level (
        .data_in(data_in),
        .enable(enable),
        .clk(clk),
        .data_out(data_out[0])
    );
    
    register #(
        .TRIGGER("EDGE"),
        .WORD_SIZE(WORD_SIZE)
	) reg_edge (
        .data_in(data_in),
        .enable(enable),
        .clk(clk),
        .data_out(data_out[1])
    );
    
    register #(
        .TRIGGER("LEVEL"),
        .WORD_SIZE(1)
	) reg_bit (
        .data_in(data_in[0]),
        .enable(enable),
        .clk(clk),
        .data_out(data_out_1)
    );
    
    // Clock generation
    always begin
        #(CLOCK_PERIOD) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Dump VCD file
		$dumpfile("testbench/register_tb.vcd");
		$dumpvars(0, register_tb);

		clk = 0;
		#(CLOCK_PERIOD/4);
        
		data_in = 32'h00000000;
		enable = 1;
		#CLOCK_PERIOD;

		data_in = 32'hABABABAB;
		enable = 0;
		#CLOCK_PERIOD;

		data_in = 32'hCDCDCDCD;
		enable = 1;
		#CLOCK_PERIOD;

		data_in = 32'hEFEFEFEF;



        $finish;
    end
endmodule