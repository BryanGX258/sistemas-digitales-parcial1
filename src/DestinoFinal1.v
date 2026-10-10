module DestinoFinal1 ( 
    input A0, A1, A2, A3,
    input B0, B1, B2, B3,
    input A, B, C, D, // selector de operacion SUMA,RESTA,COMPARADOR, XOR
    output Cout,
    output Y0, Y1, Y2, Y3, //salidas del mux 4x1
    output FLAG, //carry mux
    output U, V,
    input CLK, EN, RESET,
    output Q0, Q1, Q2, Q3,
    output FLAG_Q 
    
);


wire [120:0] cable;
wire BX0, BX1, BX2, BX3;
wire C1, C2, C3;
wire M;
wire S0, S1, S2, S3;
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


 
 // XOR DE 4 BITS ENTRE A Y B

xor xor0 (cable[73], A0, B0);
xor xor1 (cable[74], A1, B1);
xor xor2 (cable[75], A2, B2);
xor xor3 (cable[76], A3, B3);

// PARIDAD DE XOR
xor xor4 (cable[77], cable[73], cable[74]);
xor xor5 (cable[78], cable[75], cable[76]);
xor xor6 (cable[79], cable[77], cable[78]);

//U Y V LOGICA SELECTORA PARA MUX

not notV (cable[71], V);
not notU (cable[72], U);

and andM (M, cable[71], cable[72]); //V,U = 0 M SERA 1 Y ACTIVARA RESTA

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

and and7  (cable[51], S0, cable[50], cable[49]); // RESTA
and and8  (cable[52], MAX0, cable[50], U);
and and9  (cable[53], S0, V, cable[49]); // SUMA
and and10 (cable[54], cable[73], V, U); // XOR

or or3 (Y0, cable[51], cable[52], cable[53], cable[54]);

// =====================================
// MUX 2 - SALIDA Y1
// =====================================

and and11 (cable[55], S1, cable[50], cable[49]);
and and12 (cable[56], MAX1, cable[50], U);
and and13 (cable[57], S1, V, cable[49]);
and and14 (cable[58], cable[74], V, U); // XOR

or or4 (Y1, cable[55], cable[56], cable[57], cable[58]);

// =====================================
// MUX 3 - SALIDA Y2
// =====================================

and and15 (cable[59], S2, cable[50], cable[49]);
and and16 (cable[60], MAX2, cable[50], U);
and and17 (cable[61], S2, V, cable[49]);
and and18 (cable[62], cable[75], V, U); // XOR

or or5 (Y2, cable[59], cable[60], cable[61], cable[62]);

// =====================================
// MUX 4 - SALIDA Y3
// =====================================

and and19 (cable[63], S3, cable[50], cable[49]);
and and20 (cable[64], MAX3, cable[50], U);
and and21 (cable[65], S3, V, cable[49]);
and and22 (cable[66], cable[76], V, U); // XOR

or or6 (Y3, cable[63], cable[64], cable[65], cable[66]);

// =====================================
// MUX 5 - CARRY / FLAG
// =====================================

and and23 (cable[67], Cout, cable[50], cable[49]);
and and24 (cable[68], B4, cable[50], U);
and and25 (cable[69], Cout, V, cable[49]);
and and26 (cable[70], cable[79], V, U); // PARIDAD XOR

or or7 (FLAG, cable[67], cable[68], cable[69], cable[70]);


 // =====================================
 // COMPARADOR MAYOR DE 4 BITS
 // =====================================

wire MAX0, MAX1, MAX2, MAX3;
wire B4;

// INVERSORES DE B
not notCompB3 (cable[81], B3);
not notCompB2 (cable[82], B2);
not notCompB1 (cable[83], B1);
not notCompB0 (cable[84], B0);

// COMPARACION DE IGUALDAD POR BIT
xnor xnorComp3 (cable[85], A3, B3);
xnor xnorComp2 (cable[86], A2, B2);
xnor xnorComp1 (cable[87], A1, B1);
xnor xnorComp0 (cable[88], A0, B0);

// COMPROBAR SI A ES MAYOR QUE B
and andMayor3 (cable[89], A3, cable[81]);

and andMayor2 (cable[90],
    cable[85], A2, cable[82]);

and andMayor1 (cable[91],
    cable[85], cable[86], A1, cable[83]);

and andMayor0 (cable[92],
    cable[85], cable[86], cable[87], A0, cable[84]);

or orMayor (cable[93],
    cable[89], cable[90], cable[91], cable[92]);

// IGUALDAD A = B
and andIgual (B4,
    cable[85], cable[86], cable[87], cable[88]);

// INVERSOR DEL COMPARADOR
not notMayor (cable[94], cable[93]);

// =====================================
// SELECCION DEL NUMERO MAYOR
// =====================================

// BIT 0
and andMax0A (cable[95], A0, cable[93]);
and andMax0B (cable[96], B0, cable[94]);
or orMax0 (MAX0, cable[95], cable[96]);

// BIT 1
and andMax1A (cable[97], A1, cable[93]);
and andMax1B (cable[98], B1, cable[94]);
or orMax1 (MAX1, cable[97], cable[98]);

// BIT 2
and andMax2A (cable[99], A2, cable[93]);
and andMax2B (cable[100], B2, cable[94]);
or orMax2 (MAX2, cable[99], cable[100]);

// BIT 3
and andMax3A (cable[101], A3, cable[93]);
and andMax3B (cable[102], B3, cable[94]);
or orMax3 (MAX3, cable[101], cable[102]);


endmodule