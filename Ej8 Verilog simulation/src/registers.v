`timescale 10ns / 10ns

/* MODULO DE REGISTROS */


/*  REGISTRO SINCRONICO: Su salida solo cambia con flancos ascendentes de clk 
*           -Si reset_n = 0, la salida es 0     */

module SincRegister(out, in, clk, reset_n);

parameter WIDTH = 8, DELAY = 0;

output reg [WIDTH-1:0]out;
input [WIDTH-1:0]in;
input clk, reset_n;


always @(posedge clk)
begin
    #(DELAY) out <= in;
end

always @(reset_n)
begin
    if(reset_n)
        deassign out;
    else
        assign out = 0;    
end

endmodule

/*  REGISTRO ASINCRONICO: Su salida refleja su entrada mientras strobe = 1   */

module AsincRegister(out, in, str);

parameter WIDTH = 8, DELAY = 0;

output reg [WIDTH-1:0]out;
input [WIDTH-1:0]in;
input str;

always @(str)
begin
    if(str)
    begin
        #(DELAY) assign out = in;    
    end
    else
        deassign out;
end

endmodule