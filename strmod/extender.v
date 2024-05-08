module extender #(
	parameter TYPE = "ZERO",
	parameter INPUT_WIDTH = 1,
	parameter OUTPUT_WIDTH = 32
) (
	input [INPUT_WIDTH-1:0] data_in,
	output [OUTPUT_WIDTH-1:0] data_out
);

	// Generate the extender logic based on the specified TYPE
	generate
		case (TYPE)
			"ZERO": begin
				assign data_out = {{(OUTPUT_WIDTH-INPUT_WIDTH){1'b0}} ,data_in};
			end
			"SIGN": begin
				assign data_out = {{(OUTPUT_WIDTH-INPUT_WIDTH){data_in[INPUT_WIDTH-1]}} ,data_in};
			end
			default: begin
				// Throw an error for invalid configuration
				invalid_parameter_value error();
			end
		endcase
	endgenerate
endmodule