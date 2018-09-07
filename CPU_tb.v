// file: CPU_tb.v
// author: @arefaat
// Testbench for CPU

`timescale 1ns/1ns

module CPU_tb;

	//Inputs
	reg clk;
	reg rst;


	//Outputs


	//Instantiation of Unit Under Test
	CPU uut (
		.clk(clk),
		.rst(rst)
	);


	initial begin
	//Inputs initialization
		clk = 0;
		rst = 1;
        
        #5
        clk = 1;
        #5
        clk = 0;
        rst = 0;
        
        
        
	//Wait for the reset
		#100;

	end
always #10 clk = ~clk;

endmodule