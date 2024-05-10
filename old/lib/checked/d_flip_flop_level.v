module d_flip_flop_level (input d, en, output q, qbar);
	wire dbar;
	DelayNot not1 (.a(d), .out(dbar));
	sr_flip_flop_level sr_flip_flop_level1 (.s(d), .r(dbar), .en(en), .q(q), .qbar(qbar));
endmodule