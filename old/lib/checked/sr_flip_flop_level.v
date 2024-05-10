// need to change egde trigger to level trigger
// in order to reduce complexity when using it as an array
// than add edge detector outside of the module

module sr_flip_flop_level (input s, r, en, output q, qbar);
	wire net1, net2;
	DelayAnd and1 (.a(s), .b(en), .out(net1));
	DelayAnd and2 (.a(r), .b(en), .out(net2));
	sr_latch sr_latch1 (.s(net1), .r(net2), .q(q), .qbar(qbar));
endmodul