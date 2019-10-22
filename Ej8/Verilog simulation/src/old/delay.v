`timescale 100us / 100us
module delay(in, out);
input in;
output wire out;

assign #(2,3) out = in; // If in = 1, out will propagate after 2 ticks. If in = 0, out will propagate after 3 ticks.

endmodule