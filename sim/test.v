

`timescale 1ns/1ps

module tb_destino;

reg [3:0] AA, BB, CTRL;

wire [3:0] Y;
wire U, V, FLAG, Cout;

// CONEXION CON EL CIRCUITO
DestinoFinal1 DUT (
    .A0(AA[0]), .A1(AA[1]),
    .A2(AA[2]), .A3(AA[3]),

    .B0(BB[0]), .B1(BB[1]),
    .B2(BB[2]), .B3(BB[3]),

    .A(CTRL[3]),
    .B(CTRL[2]),
    .C(CTRL[1]),
    .D(CTRL[0]),

    .Y0(Y[0]), .Y1(Y[1]),
    .Y2(Y[2]), .Y3(Y[3]),

    .U(U),
    .V(V),
    .FLAG(FLAG),
    .Cout(Cout)
);

// PROCEDIMIENTO PARA PROBAR
task probar;
    input [3:0] datoA;
    input [3:0] datoB;
    input [3:0] control;

    begin
        AA = datoA;
        BB = datoB;
        CTRL = control;

        #10;

        $display(
            "A=%04b B=%04b ABCD=%04b VU=%b%b Y=%04b FLAG=%b COUT=%b",
            AA, BB, CTRL, V, U, Y, FLAG, Cout
        );
    end
endtask

initial begin

    $dumpfile("build/test.vcd");
    $dumpvars(0, tb_destino);

    $display("====================================");
    $display("       PRUEBAS EN BINARIO");
    $display("====================================");

    // SUMA: VU = 10
    $display("\n=== SUMA ===");
    probar(4'b0011, 4'b0010, 4'b0010);
    probar(4'b1111, 4'b0001, 4'b0010);
    probar(4'b0111, 4'b0101, 4'b0010);

    // RESTA: VU = 00
    $display("\n=== RESTA ===");
    probar(4'b0011, 4'b0010, 4'b0000);
    probar(4'b1000, 4'b0011, 4'b0000);
    probar(4'b0000, 4'b0001, 4'b0000);

    // XOR: VU = 11
    $display("\n=== XOR ===");
    probar(4'b0011, 4'b0010, 4'b0101);
    probar(4'b1111, 4'b0000, 4'b0101);
    probar(4'b0111, 4'b0000, 4'b0101);

    $display("\n=== FIN DE SIMULACION ===");

    $finish;
end

endmodule
