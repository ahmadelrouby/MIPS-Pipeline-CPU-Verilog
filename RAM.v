// file: RAM.v
// author: @arefaat

`timescale 1ns/1ns

module RAM(clk,adr,din,we,dout);

parameter n = 32 ;
parameter m = 32 ;
input clk,we;
input [n-1:0]adr;
input [m-1:0]din;
output [m-1:0]dout;

reg [m-1:0]mem[127:0];
assign dout=mem[adr];

always @(posedge clk)
begin
if(we)
mem[adr]<=din;
end

endmodule