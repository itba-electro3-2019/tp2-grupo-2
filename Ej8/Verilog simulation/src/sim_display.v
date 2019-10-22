//Dependencies: clock_lib.v / real_gates.v / registers.v
`timescale 100ns / 100ns

/*  SIMULACION DEL MODULO CON EL DISPLAY 7 SEGMENTOS:
      Funcionamiento: Recibe los valores validos para mostrar que va obteniendo el otro modulo y los muestra
        cuando el clock de refresh lo solicite.
      Recibe: Comp: salida del registro asociado al contador  
      Devuelve: sevenSegOut: valor que se muestra en el display 7 segmentos  */
      

module simDisplay(sevenSegOut, validCount);

  parameter WIDTH = 7;

  input [WIDTH-1:0] validCount;
  output [WIDTH-1:0] sevenSegOut; //aca esta lo que se muestra en el display 7 segmentos

  // My signal definitions
  wire clk3;

  ClockT #(
    .T_ON( 494e3 ), // f = 20Hz -> T=50ms, con la mayoria del tiempo encendido
    .T_OFF( 6e3 ),
    .FIRST(1),  
    .T0( 100 )  //Para que no este en fase, ya que no tiene por que estarlo
  ) clock3(clk3);

  wire [WIDTH-1:0] showedCount; //aca estara el valor que se debe mostrar todo el tiempo
  AsincRegister #( .WIDTH(WIDTH) ) asincReg( showedCount, 
                                            validCount, //entran valores validos de la cuenta
                                            clk3); //cambian siempre EXCEPTO cuando toque refreshear (clk3 = 0 por una corta ventana de tiempo)

  AsincRegister #( .WIDTH(WIDTH) ) bcd7segment( sevenSegOut,
                                              showedCount,
                                              ~clk3); //solo cambia cuando clk3 vale 0



endmodule
