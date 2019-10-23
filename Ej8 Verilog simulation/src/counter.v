/*******************************************************************************
* SincCounter:                                                                 *
*    *Recibe:                                                                  *
*       - Clk: señal de clock                                                  *                         
*       - Reset: en 1 vuelve la cuenta a 0.                                    *
*       - Enable: en 1 habilita el contador, en 0 la salida conserva su valor. *
*    *Devuelve:                                                                *
*       - Out: arreglo de WIDTH bits que contienen el valor de la cuenta.      *
*    *Funcion: contador sincronico de WIDTH Bits                               *
********************************************************************************/

module SincCounter(out, clk, reset, enable);

  parameter WIDTH = 8;

  output [WIDTH-1 : 0] out;
  input            clk, reset, enable;

  reg [WIDTH-1 : 0]   out = 0;
  wire            clk, reset;


  always @(posedge clk)
    if(enable)
    begin
      $display("Counting");
      out <= out + 1;      
    end

  always @reset
    if (reset)
      assign out = 0;
    else
      deassign out;

endmodule // counter
