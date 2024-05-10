module d_flip_flop (input d, clk, output q, qbar);
	wire dbar;
	DelayNot not1 (.a(d), .out(dbar));
	sr_flip_flop sr_flip_flop1 (.s(d), .r(dbar), .clk(clk), .q(q), .qbar(qbar));
endmodule