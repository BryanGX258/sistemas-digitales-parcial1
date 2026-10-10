module result_register (
    input CLK, EN, RESET,
    input Y0, Y1, Y2, Y3,
    input FLAG,
    output reg Q0, Q1, Q2, Q3,
    output reg FLAG_Q
);

// REGISTRO DE 5 BITS
always @(posedge CLK or posedge RESET) begin

    if (RESET) begin
        Q0 <= 1'b0;
        Q1 <= 1'b0;
        Q2 <= 1'b0;
        Q3 <= 1'b0;
        FLAG_Q <= 1'b0;
    end

    else if (EN) begin
        Q0 <= Y0;
        Q1 <= Y1;
        Q2 <= Y2;
        Q3 <= Y3;
        FLAG_Q <= FLAG;
    end

end

endmodule
// descanso porque la mente es lo primero, y la mente es lo que me hace falta ( ͡° ͜ʖ ͡° )
