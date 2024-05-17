`timescale 1ns / 1ns

module alu_decoder_tb;
    reg [1:0] alu_op;
    reg [2:0] funct3;
    reg op_5;
    reg funct7_5;
    wire [2:0] alu_control;

	localparam DELAY = 500;

    alu_decoder dut (
        .alu_op(alu_op),
        .funct3(funct3),
        .op_5(op_5),
        .funct7_5(funct7_5),
        .alu_control(alu_control)
    );

    initial begin
		$dumpfile("testbench/alu_decoder_tb.vcd");
		$dumpvars(0, alu_decoder_tb);

        // lw
        alu_op = 2'b00;
        funct3 = 3'bx;
        op_5 = 1'bx;
        funct7_5 = 1'bx;
        #DELAY;

        // beq
        alu_op = 2'b01;
        funct3 = 3'bxxx;
        op_5 = 1'bx;
        funct7_5 = 1'bx;
        #DELAY;

        // add
        alu_op = 2'b10;
        funct3 = 3'b000;
        op_5 = 1'b0;
        funct7_5 = 1'b0;
        #DELAY;

        // add
        alu_op = 2'b10;
        funct3 = 3'b000;
        funct7_5 = 1'b1;
        #DELAY;

        // add
        alu_op = 2'b10;
        funct3 = 3'b000;
        op_5 = 1'b1;
        funct7_5 = 1'b0;
        #DELAY;

        // sub
        funct7_5 = 1'b1;
        #DELAY;

		// slt
		funct3 = 3'b010;
		op_5 = 1'bx;
		funct7_5 = 1'bx;
		#DELAY;

		// or
		funct3 = 3'b110;
		#DELAY;

		// and
		funct3 = 3'b111;
		#DELAY;

        $finish;
    end
endmodule