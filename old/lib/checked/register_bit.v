// This register bit doesn't use a read enable
// while memory bit uses a read enable

module register_bit (
	input data_in, 
	input en,
	output data_out
);	
	d_flip_flop_level dff(.d(data_in), .en(en), .q(data_out), .qbar());
endmodule