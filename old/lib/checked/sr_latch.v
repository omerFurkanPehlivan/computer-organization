module sr_latch (input s, r, output q, qbar);
	DelayNor nor1 (.a(r), .b(qbar), .out(q));
	DelayNor nor2 (.a(s), .b(q), .out(qbar));
endmodule