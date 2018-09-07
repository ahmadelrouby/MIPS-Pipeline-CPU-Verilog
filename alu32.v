// file: alu32.v
// author: @arefaat

`timescale 1ns/1ns

module alu32(a,b,f,shamt,y,zero);

parameter n = 32;

input [n-1:0] a,b;
input [3:0] f;
input [4:0] shamt;

output reg[n-1:0] y;
output zero;

wire Cout;
wire Cin;
assign Cin = (f == 4'b0001)? 1'b1:1'b0;
wire [n-1:0] adderOut;

assign zero = (y == 0)? 1:0;

always @ (a,b,f,shamt) begin

case(f)

4'b0000:
y = a + b;

4'b0001:
y = a - b;

4'b0010:
y = a & b;

4'b0011:
y = a | b;

4'b0100:
y = a ^ b;

4'b0101:
y = a << shamt;

4'b0110:
y = a >> shamt;

4'b0111:
y = a << shamt;

4'b1000:
y = a >>> shamt;

4'b1001:
y = (a < b)? (1) : (0);
endcase;

end
endmodule