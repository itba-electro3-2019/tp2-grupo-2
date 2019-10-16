module counter(out, clk, reset, enable);

  parameter WIDTH = 8;

  output [WIDTH-1 : 0] out;
  input            clk, reset, enable;

  reg [WIDTH-1 : 0]   out = 0;
  wire            clk, reset;


  always @(posedge clk)
    if(enable)
      out <= out + 1;

  always @reset
    if (reset)
      assign out = 0;
    else
      deassign out;

endmodule // counter