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

// ================= SUMADOR 1 =================
// Entradas: A0, BX0, M

not notA0 (cable[0], A0);
not notB0 (cable[1], BX0);
not notC0 (cable[2], M);

and andc1_1 (cable[3], BX0, M);
and andc1_2 (cable[4], A0, M);
and andc1_3 (cable[5], A0, BX0);
or  orc1    (C1, cable[3], cable[4], cable[5]);

and ands1_1 (cable[6], cable[0], cable[1], M);
and ands1_2 (cable[7], cable[0], BX0, cable[2]);
and ands1_3 (cable[8], A0, cable[1], cable[2]);
and ands1_4 (cable[9], A0, BX0, M);
or  ors1    (S0, cable[6], cable[7], cable[8], cable[9]);


endmodule