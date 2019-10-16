`timescale 100ns / 100ns      //mucha precision para los retardos

/* MODULO DE CLOCKS CON PARAMETROS DISTINTOS */

/****************************************************
* Clock_d:                                          *
*    *Parametros:                                   *
*          PERIOD: periodo en multiplos de ticks    *                         
*          FIRST: estado inicial del clock          *
*          DUTY CYCLE: t_on/t_off del clock, <1     *
*          T0: corrimiento inicial en el tiempo     *
*****************************************************/
module ClockD(clk);

parameter PERIOD = 10e6,     // periodo
          FIRST = 0,        // estado inicial
          DUTY = 0.5,       // duty cycle
          T0 = 0;           // el usuario de esta libreria puede modificar el tiempo en el que arranca

output reg clk;

reg init = 0;   // determina si es la primera vuelta para hacer el delay T0
//reg delay1 = 0, delay2 = 0;

/*initial
    begin       //configura los delays dependiendo de cual sea el primer estado
        if(FIRST == 0)
            begin
                delay1 = PERIOD*(1-DUTY);
                delay2 = PERIOD*DUTY;
            end
        else
            begin
                delay1 = PERIOD*DUTY;
                delay2 = PERIOD*(1-DUTY);
            end    
    end
*/

always
    begin: CLOCK_DRIVER
        //clk <= FIRST;  
        /*if( !init & (T0 > 0) )    // la primera vez debe haber un delay de T0 (no funcionaba metiendolo en un bloque initial)
        begin
            $display("Pre delay T0");
            #(T0);
            $display("Post delay T0");
            init = 1;
        end    
        else
            init = 1;
        */    
        $display("Starting delay1");   
        //#(delay1);     
        //#(PERIOD*DUTY);
        //#(10);
        //clk <= ~FIRST;
        $display("Starting delay2");   
        clk <= 1'b0;
        //#(delay2);                        
        #10;
    end  

endmodule

/****************************************************
* Clock_t:                                          *
*    *Parametros:                                   *
*          T_ON: tiempo en el estado alto           *                         
*          T_OFF: tiempo en el estado bajo          *
*          FIRST: estado inicial del clock          *
*          T0: corrimiento inicial en el tiempo     *
*****************************************************/
module ClockT(clk);


parameter T_ON = 5e6,        // tiempo en alto 
          T_OFF = 5e6,       // tiempo en bajo
          FIRST = 0,        // estado inicial
          T0 = 0;            // el usuario puede modificar el tiempo en el que arranca

output reg clk;

reg init = 0;      

reg delay1, delay2;

initial
    begin       //configura los delays dependiendo de cual sea el primer estado
        if(FIRST == 0)
            begin
                delay1 = T_OFF;
                delay2 = T_ON;
            end
        else
            begin
                delay1 = T_ON;
                delay2 = T_OFF;
            end    
    end


always
    begin: CLOCK_DRIVER
        begin
            clk <= FIRST;  
            if(!init & (T0 > 0))
                begin
                    #(T0);
                    init = 1;
                end
            else
                begin
                    init = 1;
                end          
            #(delay1);     
            clk <= ~FIRST;
            #(delay2);    
        end
    end  

endmodule

/*****************************************************
* Clock_p:                                           *
*    *Parametros:                                    *
*          PERIOD: periodo en multiplos de ticks     *                         
*          T_ON: tiempo en el estado alto, <= PERIOD *
*          FIRST: estado inicial del clock          *
*          T0: corrimiento inicial en el tiempo      *
*****************************************************/
module ClockP(clk);

parameter PERIOD = 10e6,     // periodo
          T_ON = PERIOD/2,  // tiempo en alto
          FIRST = 0,        // estado inicial
          T0 = 0;           // el usuario puede modificar el tiempo en el que arranca

output reg clk;

reg init = 0;

reg delay1, delay2;

initial
    begin       //configura los delays dependiendo de cual sea el primer estado
        if(FIRST == 0)
            begin
                delay1 = PERIOD - T_ON;
                delay2 = T_ON;
            end
        else
            begin
                delay1 = T_ON;
                delay2 = PERIOD - T_ON;
            end    
    end


always
    begin: CLOCK_DRIVER
        begin
            clk <= FIRST;  
            if(!init & (T0 > 0))
                begin
                    #(T0);
                    init = 1;
                end
            else
                begin
                    init = 1;
                end          
            #(delay1);     
            clk <= ~FIRST;
            #(delay2);    
        end
    end  


endmodule