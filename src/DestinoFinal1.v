module DestinoFinal1 ( input A0, A1, A2, A3,
    input B0, B1, B2, B3,
    input M,              // M=0 suma, M=1 resta(inversion de las xor del sumador)
    output S0, S1, S2, S3, // (colocar decodificador pendiente)
    output Cout
);

wire [120:0] cable;
wire BX0, BX1, BX2, BX3;
wire C1, C2, C3;

// XOR para invertir B cuando M=1
xor xorb0 (BX0, B0, M);
xor xorb1 (BX1, B1, M);
xor xorb2 (BX2, B2, M);
xor xorb3 (BX3, B3, M);


endmodule