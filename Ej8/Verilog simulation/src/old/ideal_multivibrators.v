
/* MODULO DE MULTIVIBRADORES IDEALES */


/* FLIP-FLOP D */

module FlipFlopD(d,clk,q, reset_n);

input d, clk, reset_n;
output reg q;

always @(posedge clk)
    q = d;

always @reset_n
if (reset_n)
    deassign q;    
else
    assign q = 0;

endmodule