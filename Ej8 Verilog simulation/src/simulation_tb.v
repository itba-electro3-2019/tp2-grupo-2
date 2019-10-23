//Dependencies: sim_count.v / sim_display.v
`timescale 100ns / 100ns

module simulation_tb;

    parameter WIDTH = 7, PERIOD = 200e3;

    reg comp; 
    wire [WIDTH-1:0] validCount, sevenSegOut;
    integer countInt, sincRegInt, asincRegInt, displayInt;  //Variables para poder ver los valores en decimal en GTKWave
    simCount #( .PERIOD(1e3) ) numObtainer(validCount, comp);
    simDisplay displayer(sevenSegOut, validCount);

    always@(numObtainer.count)
        countInt = numObtainer.count;
    always@(validCount)
        sincRegInt = validCount;  
    always@(displayer.showedCount)
        asincRegInt = displayer.showedCount;  
    always@(sevenSegOut)
        displayInt = sevenSegOut;   

    integer i;

    initial
    begin
        for( i=0; i<100 ; i=i+1 )   //simulamos para tensiones del joystick aumentando de 0 a 5V de, para salida de 0 a 99
        begin
            compare(i*2e3, PERIOD);    
        end
        $finish;
    end
    

    // Additional documentation on $dumpfile and $dumpvars: http://referencedesigner.com/tutorials/verilog/verilog_62.php
    // Setup to allow us to pass an output path for $dumpfile
    reg dummy;
    reg[8*64:0] dumpfile_path = "output.vcd";

    initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0, comp, countInt, sincRegInt, asincRegInt, displayInt, numObtainer.clkCount, numObtainer.clkTriang, displayer.clkDisp );
    end

    /* Funcion para simular la salida del comparador. t_on en la realidad depende de la tension que tenga el joytick */
    task compare;
        input integer t_on, period;
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