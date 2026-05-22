
module relu(
input wire [5:0] dout_msb,
input wire [11:0] dout_lsb,
output reg [17:0] dout_relu
);





  always @(dout_msb, dout_lsb) begin
    if(dout_msb[5] == 1'b0) begin
      dout_relu <= {dout_msb,dout_lsb};
    end
    else begin
      dout_relu <= 18'b000000000000000000;
    end
  end


endmodule
