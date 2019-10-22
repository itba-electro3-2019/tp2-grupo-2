`timescale 100ns / 100ns

/* MODULO DE CLOCKS CON DIFERENTES PARAMETROS */

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

integer delay1 = 0, delay2 = 0, to=T0;

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
        clk <= ~FIRST; 
    end

always
    begin: CLOCK_DRIVER
        begin
            if(to > 0)
                begin
                    #(to);
                    to = 0;
                end
            clk <= FIRST;  
            #(delay1);     
            clk <= ~FIRST;
            #(delay2);    
        end
    end  

endmodule

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

output wire clk;

ClockT #(               //arma el ClockT con los parametros que recibe
    .T_ON( PERIOD*DUTY ),
    .T_OFF( PERIOD*(1-DUTY) ),
    .FIRST(FIRST),
    .T0(T0)
)auxclock(clk);

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
          T_ON = PERIOD/2,   // tiempo en alto
          FIRST = 0,         // estado inicial
          T0 = 0;            // el usuario puede modificar el tiempo en el que arranca

output wire clk;

ClockT #(
    .T_ON(T_ON),
    .T_OFF(PERIOD - T_ON),
    .FIRST(FIRST),
    .T0(T0)
)auxclock(clk);

endmodule
