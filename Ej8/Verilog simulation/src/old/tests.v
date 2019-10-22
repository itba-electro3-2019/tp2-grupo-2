`timescale 100ns / 100ns

/*ARMAR MULTIVIBRADORES IDEALES*/
/*ARMAR MULTIVIBRADORES REALES*/

module simulation(comp);

  parameter WIDTH = 7;
  
  input comp;
  // My signal definitions
  wire clk1, clk2, clk3;

  ClockD #( 
    .PERIOD(1e3) 
  ) clock1(clk1);  //clock del contador, 10kHz

  ClockD #( 
    .PERIOD(200e3) , 
    .FIRST(1) 
  ) clock2(clk2);     //clock con la frecuencia de la triangular(50Hz) resetea el contador, arranca en 1 (triangular en subida)

  ClockT #(
    .T_ON( 494e3 ), // f = 20Hz -> T=50ms, con la mayoria del tiempo encendido
    .T_OFF( 6e3 ),
    .FIRST(1),  
    .T0( 100 )  //Para que no este en fase, ya que no tiene por que estarlo
  ) clock3(clk3);

  wire[WIDTH - 1 :0] count;
  RealNot #( .DELAY(15) ) resetCounter(reset, clk2); //La NOT tiene un delay maximo de 15ns http://www.ti.com/lit/ds/symlink/sn54ls04-sp.pdf
  SincCounter #( .WIDTH(WIDTH) ) my_counter ( count, 
                                              clk1, 
                                              reset, //cuando la triangular esta en bajada (clk2 = 0) el contador se resetea.
                                              comp); //si el comparador ya tiene un valor valido (comp = 0), se deshabilita el contador

  
  wire clkReg;
  wire[WIDTH-1:0] validCount; //aca estaran los valores finales de cada periodo. Valores que se pueden mostrar en el refresh
  RealNot #( .DELAY(15) ) clkRegister(clkReg, comp);  //
  SincRegister #( .WIDTH(WIDTH) ) sincReg( validCount,
                                           count,  //mostrara valores del contador
                                           clkReg, //cuando el comparador pase a 0 (la triangular paso al joystick)
                                           1'b1 );    //nunca queremos que se resetee porque siempre debe tener valores validos para mostrar

wire [WIDTH-1:0] showedCount; //aca estara el valor que se debe mostrar todo el tiempo
AsincRegister #( .WIDTH(WIDTH) ) asincReg( showedCount, 
                                           validCount, //entran valores validos de la cuenta
                                           clk3); //cambian siempre excepto cuando toque refreshear (clk3 = 0 por una corta ventana de tiempo)

wire [WIDTH-1:0] SevenSegOut;
AsincRegister #( .WIDTH(WIDTH) ) bcd7segment( SevenSegOut,
                                             showedCount,
                                             ~clk3); //solo cambia cuando clk3 vale 0

integer countInt, validCountInt, showedCountInt, SevenSegOutInt;  //Para poder ver la cuenta y la salida del registro en decimal en GTKWave
always@(count)
  countInt = count;
always@(validCount)
  validCountInt = validCount;  
always@(showedCount)
  showedCountInt = showedCount;  
always@(SevenSegOut)
  SevenSegOutInt = SevenSegOut;   

initial begin
     compare(60e3,200e3);
     compare(120e3,200e3);
    $finish;
  end

  // Additional documentation on $dumpfile and $dumpvars: http://referencedesigner.com/tutorials/verilog/verilog_62.php
  // Setup to allow us to pass an output path for $dumpfile
  reg dummy;
  reg[8*64:0] dumpfile_path = "output.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0, registers_test);
  end
 
  
  task compare;
    input integer t_on, period;
    //output reg comp;
    begin
      comp = 1;
      #(t_on/2);
      comp = 0;
      #(period - t_on);
      comp = 1;
      #(t_on/2);
    end
  endtask 

endmodule

/*
module not_test;

  //My signal definitions
  wire out;
  reg in;
  RealNot #(.DELAY(15)) r_not(out,in);  //La NOT tiene un delay maximo de 15ns http://www.ti.com/lit/ds/symlink/sn54ls04-sp.pdf
  initial
  begin
    in = 0;
    #5;
    in = 1;
    #3;
    $finish;
  end

  // Additional documentation on $dumpfile and $dumpvars: http://referencedesigner.com/tutorials/verilog/verilog_62.php
  // Setup to allow us to pass an output path for $dumpfile
  reg dummy;
  reg[8*64:0] dumpfile_path = "output.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0,not_test);
  end

endmodule
*/

// PRUEBA COUNTER Y SINCRONIZACION

/*
module count_test;

  // My signal definitions
  wire clk1, clk2, comp;

  ClockD #( 
    .PERIOD(1e3) 
  ) clock1(clk1);  //clock del contador, 10kHz

  ClockD #( 
    .PERIOD(200e3) , 
    .FIRST(1) 
  ) clock2(clk2);     //clock con la frecuencia de la triangular(50Hz) resetea el contador, arranca en 1 (triangular en subida)

  Comparator #(
    .PERIOD(200e3),
    .T_STOP(60e3)
  ) compare(comp);    //simulacion de la salida del comparador de la triangular con el joystick

  wire[6:0] count;
  not(reset, clk2); //IMPLEMENTAR ACA UNA NOT REAL
  SincCounter #(.WIDTH(7)) my_counter (count, clk1, reset, comp);

  integer count_int;  //Para poder ver la cuenta en decimal en GTKWave
  always@(count)
    count_int = count;

  initial begin
    #800;  // cuenta hasta 100 o hasta que lo frenen
    $finish;
  end

  // Additional documentation on $dumpfile and $dumpvars: http://referencedesigner.com/tutorials/verilog/verilog_62.php
  // Setup to allow us to pass an output path for $dumpfile
  reg dummy;
  reg[8*64:0] dumpfile_path = "output.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0,count_test);
  end

endmodule   // End of count_test module 
*/


/*  PRUEBA CLOCKS

module clocks_tests;

  // My signal definitions
  wire clkd, clkt, clkp;
  
  ClockD #(
    .PERIOD(3),
    .FIRST(1),  
    .DUTY(0.7),
    .T0(2)
  ) clock1(clkd);

  ClockT #( 
    .T_ON(4), 
    .T_OFF(5), 
    .FIRST(1), 
    .T0(6) 
  ) clock2(clkt);
  
  ClockP #( 
    .PERIOD(5), 
    .T_ON(4), 
    .FIRST(0), 
    .T0(0) 
  ) comparator(clkp);

  initial begin
    #100;
    $finish;    
  end

  reg dummy;
  reg[8*64:0] dumpfile_path = "output.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0,clocks_tests);
  end

endmodule // End of module clocks_tests */


//PRUEBA DELAYS

/*module hello_world;

  // My signal definitions
  reg signal;
  wire delayed;

  delay mydelay(signal, delayed);

  initial begin

    signal = 0;
    #1;
    signal = 1;
    #1;
    signal = 0;
    #1;
    $finish;

  end

  // Additional documentation on $dumpfile and $dumpvars: http://referencedesigner.com/tutorials/verilog/verilog_62.php
  // Setup to allow us to pass an output path for $dumpfile
  reg dummy;
  reg[8*64:0] dumpfile_path = "output.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0,hello_world);
  end

endmodule // End of Module hello_world
*/