// I wish i could make this at gate level,
// I had no time :'(
// It would be just like main decoder

module alu_decoder (
	input [1:0] alu_op,
	input [2:0] funct3,
	input op_5,
	input funct7_5,
	output [2:0] alu_control
);
	case (alu_op)
		2'b00: assign alu_control = 3'b000; // lw, sw
		2'b01: assign alu_control = 3'b001; // beq
		/*2'b10: begin
			case (funct3)
				3'b000: begin
					case ({op_5, funct7_5})
						2'b00: assign alu_control = 3'b000; // add
						2'b01: assign alu_control = 3'b000; // add
						2'b10: assign alu_control = 3'b000; // add
						2'b11: assign alu_control = 3'b001; // sub
					endcase
				end
				3'b010: assign alu_control = 3'b101; // slt
				3'b110: assign alu_control = 3'b011; // or
				3'b111: assign alu_control = 3'b010; // and
				default: assign alu_control = 3'bxxx;
			endcase
		end*/
		default: assign alu_control = 3'bxxx;
	endcase

endmodule