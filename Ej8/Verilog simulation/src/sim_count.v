//Dependencies: clock_lib.v / real_gates.v / registers.v
`timescale 100ns / 100ns

/*  SIMULACION DEL MODULO CON EL CONTADOR:
      Funcionamiento: Mientras comp sea 1, el contador aumenta su valor. Cuando comp pasa a 0, se frena
        y el registro sincronico muestra el valor de la cuenta. 
      Recibe: Comp: salida del comparador de la triangular con el joysitick. comp=1 cuando joytick > triangular  
      Devuelve: validCount: valor que tiene el registro sincronico en todo momento  */

module simCount(validCount, comp);

  parameter PERIOD = 1e3, WIDTH = 7;

  input comp;
  output wire [WIDTH-1:0] validCount;  //aca estaran los valores finales de cada periodo. Valores que se pueden mostrar en el refresh

  // My signal definitions
  wire clk1, clk2;

  ClockD #( 
    .PERIOD(PERIOD) 
  ) clock1(clk1);  //clock del contador, 10kHz

  ClockD #( 
    .PERIOD(200*PERIOD), //este clock debe ser 200 veces mas lento que el otro, para contar de 0 a 99 y despues bajar 
    .FIRST(1) 
  ) clock2(clk2);     //clock con la frecuencia de la triangular(50Hz) resetea el contador, arranca en 1 (triangular en subida)

  wire[WIDTH - 1 :0] count; //aca se lleva la cuenta
  RealNot #( .DELAY(15) ) resetCounter(reset, clk2); //La NOT tiene un delay maximo de 15ns http://www.ti.com/lit/ds/symlink/sn54ls04-sp.pdf
  SincCounter #( .WIDTH(WIDTH) ) my_counter ( count, 
                                              clk1, 
                                              reset, //cuando la triangular esta en bajada (clk2 = 0) el contador se resetea.
                                              comp); //si el comparador ya tiene un valor valido (comp = 0), se deshabilita el contador

  wire clkReg;
  RealNot #( .DELAY(15) ) clkRegister(clkReg, comp); 
  SincRegister #( .WIDTH(WIDTH) ) sincReg( validCount,
                                           count,  //mostrara valores del contador
                                           clkReg, //cuando el comparador pase a 0 (la triangular paso al joystick) cambia su valor porque tiene una entrada valida
                                           1'b1 );    //nunca queremos que se resetee porque siempre debe tener valores validos para mostrar

endmodule