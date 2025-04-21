module RStrigger (
    output reg out,
    input x,    // S 
    input xdop  // R 
);
    always @(*) begin
        if (!xdop) 
            out = 1'b0;  // R=0
        else if (!x) 
            out = 1'b1;  // S=0
    end
endmodule

module Filter (
    output OutResult,
    input X, 
    input A, 
    input B
);
    wire o1, o2, o3, o4, Ainv, Binv;

	not not1 (Ainv, A);
	not not2 (Binv, B);

    RStrigger r1 (o1, X, A);    // S=X, R=A
    RStrigger r2 (o2, X, B);    // S=X, R=B
    RStrigger r3 (o3, X, Ainv);   // S=X, R=not A
    RStrigger r4 (o4, X, Binv);   // S=X, R=not B

    assign OutResult = o1 & o2 & o3 & o4;
endmodule