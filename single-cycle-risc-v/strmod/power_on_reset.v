module power_on_reset #(
	parameter PULSE_WIDTH = 100

) (
	output reset;
);
	assign reset = 1'b1;
	initial begin
		#100 reset = 1'b0;
	end
endmodule