// `timescale 100ns / 100ns


// module simulation(comp, validCount, showedCount, SevenSegOut);

//   parameter PERIOD = 1e3;
//   parameter WIDTH = 7;

//   input comp;
//   output wire [WIDTH-1:0] count, 
//                           validCount,  //aca estaran los valores finales de cada periodo. Valores que se pueden mostrar en el refresh
//                           showedCount, //aca estara el valor que se debe mostrar todo el tiempo
//                           SevenSegOut; //aca va a estar lo que se muestra en el display 7 segmentos

//   // My signal definitions
//   wire clk1, clk2, clk3;

//   ClockD #( 
//     .PERIOD(PERIOD) 
//   ) clock1(clk1);  //clock del contador, 10kHz

//   ClockD #( 
//     .PERIOD(200*PERIOD), //este clock debe ser 200 veces mas lento que el otro, para contar de 0 a 99 y despues bajar 
//     .FIRST(1) 
//   ) clock2(clk2);     //clock con la frecuencia de la triangular(50Hz) resetea el contador, arranca en 1 (triangular en subida)

//   ClockT #(
//     .T_ON( 494e3 ), // f = 20Hz -> T=50ms, con la mayoria del tiempo encendido
//     .T_OFF( 6e3 ),
//     .FIRST(1),  
//     .T0( 100 )  //Para que no este en fase, ya que no tiene por que estarlo
//   ) clock3(clk3);

//   // wire[WIDTH - 1 :0] count;
//   RealNot #( .DELAY(15) ) resetCounter(reset, clk2); //La NOT tiene un delay maximo de 15ns http://www.ti.com/lit/ds/symlink/sn54ls04-sp.pdf
//   SincCounter #( .WIDTH(WIDTH) ) my_counter ( count, 
//                                               clk1, 
//                                               reset, //cuando la triangular esta en bajada (clk2 = 0) el contador se resetea.
//                                               comp); //si el comparador ya tiene un valor valido (comp = 0), se deshabilita el contador

  
//   wire clkReg;
//   // wire[WIDTH-1:0] validCount; //aca estaran los valores finales de cada periodo. Valores que se pueden mostrar en el refresh
//   RealNot #( .DELAY(15) ) clkRegister(clkReg, comp);  //
//   SincRegister #( .WIDTH(WIDTH) ) sincReg( validCount,
//                                            count,  //mostrara valores del contador
//                                            clkReg, //cuando el comparador pase a 0 (la triangular paso al joystick)
//                                            1'b1 );    //nunca queremos que se resetee porque siempre debe tener valores validos para mostrar

//   // wire [WIDTH-1:0] showedCount; //aca estara el valor que se debe mostrar todo el tiempo
//   AsincRegister #( .WIDTH(WIDTH) ) asincReg( showedCount, 
//                                             validCount, //entran valores validos de la cuenta
//                                             clk3); //cambian siempre excepto cuando toque refreshear (clk3 = 0 por una corta ventana de tiempo)

//   // wire [WIDTH-1:0] SevenSegOut; //aca va a estar lo que se muestra en el display 7 segmentos
//   AsincRegister #( .WIDTH(WIDTH) ) bcd7segment( SevenSegOut,
//                                               showedCount,
//                                               ~clk3); //solo cambia cuando clk3 vale 0



//   // initial begin
//   //      compare(60e3,PERIOD);
//   //      compare(120e3,PERIOD);
//   //     $finish;
//   //   end

//   // Additional documentation on $dumpfile and $dumpvars: http://referencedesigner.com/tutorials/verilog/verilog_62.php
//   // Setup to allow us to pass an output path for $dumpfile
//   // reg dummy;
//   // reg[8*64:0] dumpfile_path = "output.vcd";

//   // initial begin
//   //   dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
//   //   $dumpfile(dumpfile_path);
//     // #1;
//     // $dumpvars(1, clk1, clk2, clk3);
//   // end
 
  

// endmodule