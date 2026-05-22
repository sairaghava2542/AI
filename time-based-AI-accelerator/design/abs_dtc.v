
module abs_dtc(
input wire [7:0] din,
output wire din_sign,
output wire [7:0] dtc_in_unsigned
);





  assign dtc_in_unsigned = ( ( $signed(din) < 0 ) ? -$signed(din) : din );
  // '1' for positive and '0' for negative
  assign din_sign = din[7] == 1'b1 ? 1'b0 : 1'b1;

endmodule
