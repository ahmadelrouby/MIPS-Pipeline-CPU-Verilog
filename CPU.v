// file: CPU.v
// author: @arefaat

`timescale 1ns/1ns

module CPU(clk,rst);

input clk,rst;




//DRAM
wire [31:0] data_from_mem;


// IRAM 
wire [31:0] instruction;




// CONTROL - DATAPATH 
wire reg RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemtoReg,jump;
wire reg[3:0] ALUControl;
wire [5:0] Funct, op;


// DATAPATH 
wire MemWriteOut;
wire [31:0]  pc;
wire [31:0]  mem_data_addr, data_to_mem;
datapath dp(
   // Outputs
   .pc(pc), .mem_data_addr(mem_data_addr), .data_to_mem(data_to_mem), .Op(op), .Funct(Funct),.MemWriteOUT(MemWriteOut),
   // Inputs
   .clk(clk), .rst(rst), .mem_to_reg_ctrl(MemtoReg), .alu_src_ctrl(ALUSrc), .reg_dst_ctrl(RegDst), .branch_ctrl(Branch),
   .reg_write_en(RegWrite), .jump_ctrl(jump), .alu_func_ctrl(ALUControl),
   .instr(instruction), .data_from_mem(data_from_mem), .mem_write_ctrl(MemWrite)
   );
   
   
ControlUnit cu(.RegWrite(RegWrite), .RegDst(RegDst), .ALUSrc(ALUSrc), .ALUControl(ALUControl),
.Branch(Branch), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .op(op), .Funct(Funct),.jump(jump));

ROM iram(.adr(pc),.dout(instruction));


RAM dram(.clk(clk),.adr(mem_data_addr),.din(data_to_mem),.we(MemWriteOut),.dout(data_from_mem));

endmodule