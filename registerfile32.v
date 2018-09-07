// file: registerfile32.v
// author: @arefaat

`timescale 1ns/1ns

module registerfile32(ra1,ra2,wa,wd,we,clk,rd1,rd2,rst);


input [4:0] ra1,ra2,wa;
input [31:0] wd;
input clk,we,rst;

output [31:0] rd1,rd2;

reg [31:0] regs [0:31];
assign rd1 = regs[ra1];
assign rd2 = regs[ra2];
integer i;

always @(posedge clk) begin

if(rst)begin
	for(i = 0; i < 32; i = i+1) begin
		regs[i] <= 0;
		end
		
	//regs[11] <= 1'b1;
end

else begin 

	if(we) regs[wa] <= wd;

end 


end



endmodule