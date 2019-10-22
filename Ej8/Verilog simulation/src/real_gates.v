`timescale 1ns / 1ns

/*   IMPLEMENTACION DE COMPUERTAS REALES CON RETARDO   */

/***************************************************************
* RealNot:                                                     *
*    *Parametros:                                              *
*          
*    *Funcion: Devuelve señal emulada del comparador analogico *
****************************************************************/

module RealNot(out,in);

output out;
input in;

parameter DELAY = 15;

assign #(DELAY) out = ~in;  

endmodule