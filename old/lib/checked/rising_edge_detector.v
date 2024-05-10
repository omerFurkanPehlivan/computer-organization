module rising_edge_detector (input clk, output out);
	wire net1, net2, net3;
	DelayNot not1 (.a(clk), .out(net1));
	DelayNot not2 (.a(net1), .out(net2));
	DelayNot not3 (.a(net2), .out(net3));
	DelayAnd and1 (.a(clk), .b(net3), .out(out));
endmodule