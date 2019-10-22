/***************************************************************
* Comparator:                                                  *
*    *Parametros:                                              *
*          PERIOD: Periodo de la señal                         *                          
*          T_STOP: Tiempo en el que debe bajar la señal.       *
*    *Funcion: Devuelve señal emulada del comparador analogico *
****************************************************************/

module Comparator(comp);

parameter PERIOD = 100e3,
          T_STOP = 1e3;      //tiempo en el que debe pasar a 0
    
output wire comp;

ClockP #( 
    .PERIOD(PERIOD), 
    .T_ON(2*T_STOP), 
    .FIRST(0), 
    .T0(T_STOP)
  ) comparator(comp);

endmodule