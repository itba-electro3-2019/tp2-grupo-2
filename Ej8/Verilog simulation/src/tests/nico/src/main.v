`timescale 100ns / 100ns

/*module count_test;

  // My signal definitions
  wire clk1;
  wire clk2;
  wire comp;
  ClockD #( .PERIOD(1e3) ) clock1(clk1);  //clock del contador, 10kHz
  ClockD #( .PERIOD(200e3) , .FIRST(1) ) clock2(clk2);     //clock con la frecuencia de la triangular, 50Hz, 
                                                           //resetea el contador, arranca en 1 (triangular en subida)
  ClockP #( .PERIOD(200e3) , .T_ON(100e3), .FIRST(1), .T0(100e3) ) comparator(comp);  //comparador, habilita el contador
  //  T_ON 100e3 -> deberia contar hasta 50

  wire[6:0] count;
  not(reset, clk2);
  counter #(.WIDTH(7)) my_counter (count, clk1, clk2, comp);

  initial begin
    #100;  // cuenta hasta 100 o hasta que lo frenen
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


module clocks_tests;

  // My signal definitions
  //wire clkd, clkt, clkp;
  wire clkd;
  //ClockD #( .PERIOD(10), .FIRST(1), .DUTY(0.5), .T0(0) ) clock1(clkd);
  ClockD clock1(clkd);
  
  //ClockT #( .T_ON(500), .T_OFF(500), .FIRST(0), .T0(1000) ) clock3(clkt);

  //ClockP #( .PERIOD(100), .T_ON(90), .FIRST(1), .T0(1000) ) comparator(clkp);

  initial begin
    #15;
    $finish;
  end

  reg dummy;
  reg[8*64:0] dumpfile_path = "output.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0,clocks_tests);
  end


endmodule // End of module clocks_tests

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
