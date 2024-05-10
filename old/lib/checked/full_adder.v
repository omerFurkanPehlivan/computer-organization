module full_adder (
    input a, b, cin,
    output sum, cout
);
    wire sum_half, carry_half, carry_half_2;

    half_adder half_adder1 (.a(a), .b(b), .sum(sum_half), .carry(carry_half));
    half_adder half_adder2 (.a(sum_half), .b(cin), .sum(sum), .carry(carry_half_2));
    DelayOr or1(.a(carry_half), .b(carry_half_2), .out(cout));
endmodule