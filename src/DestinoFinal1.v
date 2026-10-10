module DestinoFinal1 ( 
    input A0, A1, A2, A3,
    input B0, B1, B2, B3,
    input M,   // M=0 suma, M=1 resta(inversion de las xor del sumador)
    input A, B, C, D, // selector de operacion SUMA,RESTA,COMPARADOR, XOR
    output S0, S1, S2, S3, // (colocar decodificador pendiente)
    output Cout,
    output Y0, Y1, Y2, Y3, //salidas del mux 4x1
    output FLAG, //carry mux
    output U, V, 
    
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

//U Y V LOGICA SELECTORA PARA MUX




module SISTEMA_MUX (
    
    input A0, B0, C0, D0,
    input A1, B1, C1, D1,
    input A2, B2, C2, D2,
    input A3, B3, C3, D3,
    input A4, B4, C4, D4,

    
);

wire [70:0] cable;

// =====================================
// CONTROL LOGIC - KARNAUGH
// =====================================

// INVERSORES
not notB (cable[40], B);
not notD (cable[41], D);
not notA (cable[42], A);

// U = AB' + CD + BD
and and1 (cable[43], A, cable[40]);
and and2 (cable[44], C, D);
and and3 (cable[45], B, D);

or or1 (U, cable[43], cable[44], cable[45]);

// V = CD' + A'B + AC
and and4 (cable[46], C, cable[41]);
and and5 (cable[47], cable[42], B);
and and6 (cable[48], A, C);

or or2 (V, cable[46], cable[47], cable[48]);

// =====================================
// SELECTORES
// SEL0 = U
// SEL1 = V
// =====================================

not notSEL0 (cable[49], U);
not notSEL1 (cable[50], V);

// =====================================
// MUX 1 - SALIDA Y0
// =====================================

and and7  (cable[51], S0, cable[50], cable[49]); //suma
and and8  (cable[52], B0, cable[50], U);
and and9  (cable[53], S0, V, cable[49]); //suma pero con m=1 osea resta
and and10 (cable[54], D0, V, U);

or or3 (Y0, cable[51], cable[52], cable[53], cable[54]);

// =====================================
// MUX 2 - SALIDA Y1
// =====================================

and and11 (cable[55], S0, cable[50], cable[49]);
and and12 (cable[56], B1, cable[50], U);
and and13 (cable[57], S0, V, cable[49]);
and and14 (cable[58], D1, V, U);

or or4 (Y1, cable[55], cable[56], cable[57], cable[58]);

// =====================================
// MUX 3 - SALIDA Y2
// =====================================

and and15 (cable[59], S0, cable[50], cable[49]);
and and16 (cable[60], B2, cable[50], U);
and and17 (cable[61], S0, V, cable[49]);
and and18 (cable[62], D2, V, U);

or or5 (Y2, cable[59], cable[60], cable[61], cable[62]);

// =====================================
// MUX 4 - SALIDA Y3
// =====================================

and and19 (cable[63], S0, cable[50], cable[49]); 
and and20 (cable[64], B3, cable[50], U);
and and21 (cable[65], S0, V, cable[49]);
and and22 (cable[66], D3, V, U);

or or6 (Y3, cable[63], cable[64], cable[65], cable[66]);

// =====================================
// MUX 5 - CARRY
// =====================================

and and23 (cable[67], Cout, cable[50], cable[49]);
and and24 (cable[68], B4, cable[50], U);
and and25 (cable[69], Cout, V, cable[49]);
and and26 (cable[70], D4, V, U);

or or7 (FLAG, cable[67], cable[68], cable[69], cable[70]);

endmodule





endmodule