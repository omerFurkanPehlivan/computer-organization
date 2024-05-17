module main_decoder (
	input [6:0]	op,
	input zero,
	output branch,
		jump,
	output [1:0] alu_op,
		[1:0] result_src,
	output mem_write,
		alu_src,
		imm_src,
		reg_write
);
	always @(*) begin
		case (op)
			7'b0000011: begin	//lw
				reg_write = 1'b1;
				imm_src = 2'b00;
				alu_src = 1'b1;
				mem_write = 1'b0;
				result_src = 2'b01;
				branch = 1'b0;
				alu_op = 2'b00;
				jump = 1'b0;
			end
			7'b0100011: begin	//sw
				reg_write = 1'b0;
				imm_src = 2'b01;
				alu_src = 1'b1;
				mem_write = 1'b1;
				result_src = 2'bxx;
				branch = 1'b0;
				alu_op = 2'b00;
				jump = 1'b0;
			end
			7'b0110011: begin	//R-type
				reg_write = 1'b1;
				imm_src = 2'bxx;
				alu_src = 1'b0;
				mem_write = 1'b0;
				result_src = 2'b00;
				branch = 1'b0;
				alu_op = 2'b10;
				jump = 1'b0;
			end
			7'b1100011: begin	//beq
				reg_write = 1'b0;
				imm_src = 2'b10;
				alu_src = 1'b0;
				mem_write = 1'b0;
				result_src = 2'bxx;
				branch = 1'b1;
				alu_op = 2'b01;
				jump = 1'b0;
			end
			7'b0010011: begin	//I-type
				reg_write = 1'b1;
				imm_src = 2'b00;
				alu_src = 1'b1;
				mem_write = 1'b0;
				result_src = 2'b00;
				branch = 1'b0;
				alu_op = 2'b10;
				jump = 1'b0;
			end
			7'b1100111: begin	//jal
				reg_write = 1'b1;
				imm_src = 2'b11;
				alu_src = 1'bx;
				mem_write = 1'b0;
				result_src = 2'b10;
				branch = 1'b0;
				alu_op = 2'bxx;
				jump = 1'b1;
			end
			default: begin
				reg_write = 1'bx;
				imm_src = 2'bxx;
				alu_src = 1'bx;
				mem_write = 1'bx;
				result_src = 2'bxx;
				branch = 1'bx;
				alu_op = 2'bxx;
				jump = 1'bx;
			end
		endcase
	end
endmodule 