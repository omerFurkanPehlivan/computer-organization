module alu_decoder (
	input op_5,
	input [2:0] funct3,
	input funct7_5,
	output reg [1:0] alu_op,
	output reg [2:0] alu_control
);
	always @(*) begin
		case (alu_op)
			2'b00: alu_control = 3'b000;	//sw, lw (add)
			2'b01: alu_control = 3'b001;	//beq (sub)
			2'b10: begin
				case (funct3)
					3'b000: begin
						case ({op_5, funct7_5})
							2'b00, 2'b01, 2'b10: alu_control = 3'b000;	//add
							2'b11: alu_control = 3'b001;	//sub
							default: alu_control = 3'bxxx;
						endcase
					end
					3'b010: alu_control = 3'b010;	//slt
					3'b110: alu_control = 3'b011;	//or
					3'b111: alu_control = 3'b100;	//and
					default: alu_control = 3'bxxx;
				endcase
			end
			default: alu_control = 3'bxxx;
		endcase
	end
endmodule