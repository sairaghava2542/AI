module neuron_wxor(
input wire tac_in,
input wire sign_x,
input wire sign_w,
input wire [7:0] win,
input wire [7:0] bias,
output wire [7:0] dout,
input wire clk,
input wire rst
);




wire [11:0] s_tac_lsb;
wire [5:0] s_tac_msb;
wire [17:0] s_dout_relu;

  tac_signed_wxor tac_instant(
      .tac_w(win),
    .tac_in(tac_in),
    .tac_lsb(s_tac_lsb),
    .tac_msb(s_tac_msb),
    .sign_x(sign_x),
    .sign_w(sign_w),
    .clk(clk),
    .rst(rst));

  relu relu_instant(
      .dout_msb(s_tac_msb),
    .dout_lsb(s_tac_lsb),
    .dout_relu(s_dout_relu));

  bias_and_quantize bias_instant(
      .dout_relu(s_dout_relu),
    .bias(bias),
    .dout(dout));


endmodule
