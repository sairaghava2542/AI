
module bias_and_quantize(
input wire [17:0] dout_relu,
input wire [7:0] bias,
output wire [7:0] dout
);




reg [17:0] s_dout;
wire [7:0] s_abias;

  // Absolute Value of Bias
  assign s_abias = ( ( $signed(bias) < 0 ) ? -$signed(bias) : bias );
  always @(dout_relu, bias) begin
    if(bias == 8'b00000000) begin
      s_dout <= dout_relu;
    end
    else begin
      // -ve Bias
      if(bias[7] == 1'b1) begin
        s_dout <= (dout_relu) + ({10'b1111111111,s_abias});
        // +ve Bias
      end
      else begin
        s_dout <= (dout_relu) + ({10'b0000000000,s_abias});
      end
    end
  end

  // Bit Quantization
  assign dout = s_dout >> 10;

endmodule
