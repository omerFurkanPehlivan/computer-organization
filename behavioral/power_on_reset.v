module power_on_reset #(
	parameter PULSE_WIDTH = 20

) (
	output reg reset
);
	initial begin
		reset = 1'b0;
		#PULSE_WIDTH reset <= 1'b1;
		#PULSE_WIDTH reset <= 1'b0;
	end
endmodule