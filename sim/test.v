`timescale 1ns/1ps

module tb_destino;

reg [3:0] AA, BB, CTRL;

wire [3:0] Y;
wire U, V, FLAG, Cout;

integer i, j, k;
integer total, errores;
integer erroresU, erroresV, erroresY, erroresFLAG;

reg esperadoU, esperadoV;
reg [3:0] esperadoY;
reg esperadoFLAG;

// =====================================
// CONEXION CON TU CIRCUITO
// =====================================

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

    .U(U), .V(V),
    .FLAG(FLAG),
    .Cout(Cout)
);

// =====================================
// FUNCIONES DE REFERENCIA
// MINTERMS DEL PROFESOR
// =====================================

function ref_u;
    input [3:0] ctrl;
    begin
        case (ctrl)
            3,5,7,8,9,10,11,13,15:
                ref_u = 1'b1;
            default:
                ref_u = 1'b0;
        endcase
    end
endfunction

function ref_v;
    input [3:0] ctrl;
    begin
        case (ctrl)
            2,4,5,6,7,10,11,14,15:
                ref_v = 1'b1;
            default:
                ref_v = 1'b0;
        endcase
    end
endfunction

// =====================================
// MOSTRAR PRUEBAS EN BINARIO
// =====================================

task mostrar;
    input [3:0] datoA, datoB, control;
    begin
        AA = datoA;
        BB = datoB;
        CTRL = control;
        #5;

        $display(
          "A=%04b B=%04b ABCD=%04b VU=%b%b Y=%04b FLAG=%b COUT=%b",
          AA, BB, CTRL, V, U, Y, FLAG, Cout
        );
    end
endtask

// =====================================
// SIMULACION
// =====================================

initial begin

    $dumpfile("build/test.vcd");
    $dumpvars(0, tb_destino);

    total = 0;
    errores = 0;
    erroresU = 0;
    erroresV = 0;
    erroresY = 0;
    erroresFLAG = 0;

    $display("\n========== SUMA ==========");
    mostrar(4'b0011, 4'b0010, 4'b0010);
    mostrar(4'b1111, 4'b0001, 4'b0010);
    mostrar(4'b0111, 4'b0101, 4'b0010);

    $display("\n========== RESTA ==========");
    mostrar(4'b0011, 4'b0010, 4'b0000);
    mostrar(4'b1000, 4'b0011, 4'b0000);
    mostrar(4'b0000, 4'b0001, 4'b0000);

    $display("\n========== MAYOR ==========");
    mostrar(4'b1001, 4'b0011, 4'b0011);
    mostrar(4'b0011, 4'b1001, 4'b0011);
    mostrar(4'b0111, 4'b0111, 4'b0011);

    $display("\n========== XOR ==========");
    mostrar(4'b0011, 4'b0010, 4'b0101);
    mostrar(4'b1111, 4'b0000, 4'b0101);
    mostrar(4'b0111, 4'b0000, 4'b0101);

    // =====================================
    // 4096 PRUEBAS AUTOMATICAS
    // =====================================

    $display("\n===== VERIFICACION AUTOMATICA =====");

    for (k = 0; k < 16; k = k + 1) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin

                CTRL = k;
                AA = i;
                BB = j;

                esperadoU = ref_u(CTRL);
                esperadoV = ref_v(CTRL);

                case ({esperadoV, esperadoU})

                    2'b00: begin
                        esperadoY = AA - BB;
                        esperadoFLAG = (AA < BB);
                    end

                    2'b01: begin
                        esperadoY = (AA >= BB) ? AA : BB;
                        esperadoFLAG = (AA == BB);
                    end

                    2'b10: begin
                        esperadoY = AA + BB;
                        esperadoFLAG =
                            ({1'b0,AA} + {1'b0,BB}) > 5'd15;
                    end

                    2'b11: begin
                        esperadoY = AA ^ BB;
                        esperadoFLAG = ^(AA ^ BB);
                    end

                endcase

                #2;
                total = total + 1;

                if (U !== esperadoU)
                    erroresU = erroresU + 1;

                if (V !== esperadoV)
                    erroresV = erroresV + 1;

                if (Y !== esperadoY)
                    erroresY = erroresY + 1;

                if (FLAG !== esperadoFLAG)
                    erroresFLAG = erroresFLAG + 1;

                if ((U !== esperadoU) ||
                    (V !== esperadoV) ||
                    (Y !== esperadoY) ||
                    (FLAG !== esperadoFLAG)) begin

                    errores = errores + 1;

                    if (errores <= 12)
                        $display(
                        "ERROR: A=%04b B=%04b ABCD=%04b VU=%b%b Y=%04b ESP_Y=%04b FLAG=%b ESP_FLAG=%b",
                        AA, BB, CTRL, V, U,
                        Y, esperadoY, FLAG, esperadoFLAG
                        );
                end

            end
        end
    end

    $display("\n========== RESULTADO ==========");
    $display("Vectores probados: %0d", total);
    $display("Comparaciones: %0d", total * 4);
    $display("Vectores con errores: %0d", errores);
    $display("Errores U: %0d", erroresU);
    $display("Errores V: %0d", erroresV);
    $display("Errores Y: %0d", erroresY);
    $display("Errores FLAG: %0d", erroresFLAG);

    if (errores == 0)
        $display("RESULTADO: TODAS LAS PRUEBAS CORRECTAS");
    else
        $display("RESULTADO: HAY ERRORES POR CORREGIR");

    $finish;
end

endmodule
