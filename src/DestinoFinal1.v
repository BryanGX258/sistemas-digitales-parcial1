module DestinoFinal1 ( input A0, A1, A2, A3,
    input B0, B1, B2, B3,
    input SA, SB, SC, SD, // entradas de control del mux 4x1
    input M,              // M=0 suma, M=1 resta(inversion de las xor del sumador)
    output S0, S1, S2, S3, // (colocar decodificador pendiente)
    output Cout
    // ojo queda pendiente colocar un mux 4x1 el cual va elegir la salidas sm/res y una tabla de verdad el cual la controlara
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

// ================= SUMADOR 2 =================
// Entradas: A1, BX1, C1

not notA1 (cable[10], A1);
not notB1 (cable[11], BX1);
not notC1 (cable[12], C1);

and andc2_1 (cable[13], BX1, C1);
and andc2_2 (cable[14], A1, C1);
and andc2_3 (cable[15], A1, BX1);
or  orc2    (C2, cable[13], cable[14], cable[15]);

and ands2_1 (cable[16], cable[10], cable[11], C1);
and ands2_2 (cable[17], cable[10], BX1, cable[12]);
and ands2_3 (cable[18], A1, cable[11], cable[12]);
and ands2_4 (cable[19], A1, BX1, C1);
or  ors2    (S1, cable[16], cable[17], cable[18], cable[19]);

// ================= SUMADOR 3 =================
// Entradas: A2, BX2, C2

not notA2 (cable[20], A2);
not notB2 (cable[21], BX2);
not notC2 (cable[22], C2);

and andc3_1 (cable[23], BX2, C2);
and andc3_2 (cable[24], A2, C2);
and andc3_3 (cable[25], A2, BX2);
or  orc3    (C3, cable[23], cable[24], cable[25]);

and ands3_1 (cable[26], cable[20], cable[21], C2);
and ands3_2 (cable[27], cable[20], BX2, cable[22]);
and ands3_3 (cable[28], A2, cable[21], cable[22]);
and ands3_4 (cable[29], A2, BX2, C2);
or  ors3    (S2, cable[26], cable[27], cable[28], cable[29]);

// ================= SUMADOR 4 =================
// Entradas: A3, BX3, C3

not notA3 (cable[30], A3);
not notB3 (cable[31], BX3);
not notC3 (cable[32], C3);

and andc4_1 (cable[33], BX3, C3);
and andc4_2 (cable[34], A3, C3);
and andc4_3 (cable[35], A3, BX3);
or  orc4    (Cout, cable[33], cable[34], cable[35]);

and ands4_1 (cable[36], cable[30], cable[31], C3);
and ands4_2 (cable[37], cable[30], BX3, cable[32]);
and ands4_3 (cable[38], A3, cable[31], cable[32]);
and ands4_4 (cable[39], A3, BX3, C3);
or  ors4    (S3, cable[36], cable[37], cable[38], cable[39]);



endmodule