`timescale 100us / 100ns

/*ARMAR COMPUERTAS REALES*/
/*ARMAR MULTIVIBRADORES IDEALES*/
/*ARMAR MULTIVIBRADORES REALES*/

// PRUEBA COUNTER Y SINCRONIZACION

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