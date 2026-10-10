
`timescale 1ns/1ps

module tb_destino;

reg [3:0] A, B;
reg [3:0] CONTROL;

wire [3:0] Y;
wire U, V, FLAG, Cout;

// CONEXION CON TU CIRCUITO
DestinoFinal1 DUT (
    .A0(A[0]), .A1(A[1]),
    .A2(A[2]), .A3(A[3]),

    .B0(B[0]), .B1(B[1]),
    .B2(B[2]), .B3(B[3]),

    .A(CONTROL[3]),
    .B(CONTROL[2]),
    .C(CONTROL[1]),
    .D(CONTROL[0]),

    .Y0(Y[0]), .Y1(Y[1]),
    .Y2(Y[2]), .Y3(Y[3]),

    .U(U),
    .V(V),
    .FLAG(FLAG),
    .Cout(Cout)
);

initial begin

    $dumpfile("build/test.vcd");
    $dumpvars(0, tb_destino);

    A = 4'd3;
    B = 4'd2;

    // PRUEBA SUMA
    CONTROL = 4'b0010;
    #10;
    $display("SUMA: %d + %d = %d", A, B, Y);

    // PRUEBA RESTA
    CONTROL = 4'b0000;
    #10;
    $display("RESTA: %d - %d = %d", A, B, Y);

    // PRUEBA XOR
    CONTROL = 4'b0101;
    #10;
    $display("XOR: %b XOR %b = %b", A, B, Y);

    $finish;

end

endmodule
