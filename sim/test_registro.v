`timescale 1ns/1ps

module tb_registro;

reg CLK, EN, RESET;
reg [3:0] AA, BB, CTRL;

wire [3:0] Y, Q;
wire FLAG, FLAG_Q;
wire U, V, Cout;

integer errores;

// CONEXION CON EL CIRCUITO PRINCIPAL
DestinoFinal1 DUT (
    .A0(AA[0]), .A1(AA[1]),
    .A2(AA[2]), .A3(AA[3]),

    .B0(BB[0]), .B1(BB[1]),
    .B2(BB[2]), .B3(BB[3]),

    .A(CTRL[3]),
    .B(CTRL[2]),
    .C(CTRL[1]),
    .D(CTRL[0]),

    .CLK(CLK),
    .EN(EN),
    .RESET(RESET),

    .Y0(Y[0]), .Y1(Y[1]),
    .Y2(Y[2]), .Y3(Y[3]),
    .FLAG(FLAG),

    .Q0(Q[0]), .Q1(Q[1]),
    .Q2(Q[2]), .Q3(Q[3]),
    .FLAG_Q(FLAG_Q),

    .U(U), .V(V),
    .Cout(Cout)
);

// RELOJ DE SIMULACION
always #5 CLK = ~CLK;

initial begin

    $dumpfile("build/registro.vcd");
    $dumpvars(0, tb_registro);

    CLK = 0;
    EN = 0;
    RESET = 0;

    AA = 4'b0011;
    BB = 4'b0010;
    CTRL = 4'b0010;

    errores = 0;

    // ==============================
    // PRUEBA 1 - RESET ASINCRONO
    // ==============================

    #2 RESET = 1;
    #1;

    $display("\n=== PRUEBA 1: RESET ===");
    $display("Q=%04b FLAG_Q=%b", Q, FLAG_Q);

    if (Q !== 4'b0000 || FLAG_Q !== 1'b0)
        errores = errores + 1;

    // ==============================
    // PRUEBA 2 - CAPTURAR SUMA
    // ==============================

    #1 RESET = 0;
    EN = 1;

    @(posedge CLK);
    #1;

    $display("\n=== PRUEBA 2: CAPTURA ===");
    $display("A=%04b B=%04b", AA, BB);
    $display("EN=%b Y=%04b Q=%04b", EN, Y, Q);
    $display("FLAG=%b FLAG_Q=%b", FLAG, FLAG_Q);

    if (Q !== 4'b0101 || FLAG_Q !== 1'b0)
        errores = errores + 1;

    // ==============================
    // PRUEBA 3 - RETENCION
    // ==============================

    EN = 0;
    AA = 4'b1111;
    BB = 4'b0001;

    @(posedge CLK);
    #1;

    $display("\n=== PRUEBA 3: RETENCION ===");
    $display("EN=%b Y=%04b Q=%04b", EN, Y, Q);
    $display("FLAG=%b FLAG_Q=%b", FLAG, FLAG_Q);

    if (Q !== 4'b0101 || FLAG_Q !== 1'b0)
        errores = errores + 1;

    // ==============================
    // PRUEBA 4 - NUEVA CAPTURA
    // ==============================

    EN = 1;

    @(posedge CLK);
    #1;

    $display("\n=== PRUEBA 4: NUEVA CAPTURA ===");
    $display("A=%04b B=%04b", AA, BB);
    $display("EN=%b Y=%04b Q=%04b", EN, Y, Q);
    $display("FLAG=%b FLAG_Q=%b", FLAG, FLAG_Q);

    if (Q !== 4'b0000 || FLAG_Q !== 1'b1)
        errores = errores + 1;

    // ==============================
    // PRUEBA 5 - RESET SIN CLK
    // ==============================

    #2 RESET = 1;
    #1;

    $display("\n=== PRUEBA 5: RESET FINAL ===");
    $display("Q=%04b FLAG_Q=%b", Q, FLAG_Q);

    if (Q !== 4'b0000 || FLAG_Q !== 1'b0)
        errores = errores + 1;

    // ==============================
    // RESULTADO FINAL
    // ==============================

    $display("\n==========================");
    $display("TOTAL DE ERRORES: %0d", errores);

    if (errores == 0)
        $display("REGISTRO FUNCIONANDO CORRECTAMENTE");
    else
        $display("REGISTRO CON ERRORES");

    $display("==========================");

    $finish;

end

endmodule
