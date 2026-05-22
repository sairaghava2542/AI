
module dtc_wabs(
input wire [7:0] din,
output wire dtc_out,
output wire din_sign,
input wire trig,
input wire clk,
input wire rst
);




wire [7:0] s_dtc_in;

  abs_dtc abs_dtc_instant(
      .din(din),
    .din_sign(din_sign),
    .dtc_in_unsigned(s_dtc_in));

  dtc dtc_instant(
      .dtc_in(s_dtc_in),
    .dtc_out(dtc_out),
    .trig(trig),
    .clk(clk),
    .rst(rst));


endmodule
