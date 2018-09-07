// file: datapath.v
// author: @arefaat

`timescale 1ns/1ns

module datapath(/*AUTOARG*/
   // Outputs
   zero_flg, pc, mem_data_addr, data_to_mem, Op, Funct, MemWriteOUT,
   // Inputs
   clk, rst, mem_to_reg_ctrl, pc_src_ctrl, alu_src_ctrl, reg_dst_ctrl, branch_ctrl,
   reg_write_en, jump_ctrl, alu_func_ctrl, instr, data_from_mem, mem_write_ctrl
   );
   //clock signal 
   input          clk;
   //active-high reset
   input 	      rst;
   input          mem_to_reg_ctrl,mem_write_ctrl,branch_ctrl;
   input 	      pc_src_ctrl;
   input          alu_src_ctrl;
   input          reg_dst_ctrl;
   input          reg_write_en;
   input 	      jump_ctrl;
   input  [3:0]   alu_func_ctrl;
   output         zero_flg;
   output [31:0]  pc;
   input  [31:0]  instr;
   output [31:0]  mem_data_addr, data_to_mem;
   input  [31:0]  data_from_mem;
   output [5:0]   Op, Funct;
   output MemWriteOUT;
   
   assign MemWriteOUT = MemWriteM;
   
   
   ///////////////////////////////////////////
   /// Fetch stage
   ///////////////////////////////////////////
   
   wire [31:0] 	 PC_Next_dp;
   wire [31:0] 	 PC_F_dp;
   wire [31:0] 	 PCPlus4_F_dp;
   
   
   //Next PC adder
    assign PCPlus4_F_dp = PC_F_dp + 4;
   //Mux to choose between PCBranch and PCPlus4
    assign PC_Next_dp = (PCSrcM)? PCBranchM : PCPlus4_F_dp; // YOU MUST DECLARE PCSrcM AND PCBranchM
   //PC register
    reg [31:0] PC_Reg;
    assign PC_F_dp = PC_Reg;
    assign pc = PC_Reg;
    
   ///////////////////////////////////////////
   /// decoder register
   ///////////////////////////////////////////
    reg [31:0] InstrD, PCPlus4D;
    
   ///////////////////////////////////////////
   /// decoder stage
   ///////////////////////////////////////////
    
    // REGISTER FILE
    reg [31:0] rf [0:31];
    
   // Output For Control Unit
   assign Op = InstrD[31:26];
   assign Funct = InstrD[5:0];
       
    // Declaration for these wires
    wire [4:0] A1, A2, Rt_D, Rd_D;
    wire [15:0] Imm_before_D;
    wire [31:0] SignImmD;
    wire [31:0] RD1, RD2;
    
    //All fields
    assign A1 = InstrD[25:21];
    assign A2 = InstrD[20:16];
    assign Imm_before_D = InstrD[15:0];
    
    // USED By Next Buffer
    assign Rt_D = InstrD[20:16];
    assign Rd_D = InstrD[15:11];
    assign SignImmD = {{16{Imm_before_D[15]}}, Imm_before_D[15:0]};
  
    // assign RD1 = rf[A1];
    // assign RD2 = rf[A2];
    
   ///////////////////////////////////////////
   /// Execute register
   ///////////////////////////////////////////
    
    reg RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUSrcE, RegDstE;
    reg [3:0] ALUControlE;
    reg [31:0] RD1_E, RD2_E, SignImmE, PCPlus4E;
    reg [4:0] Rt_E, Rd_E, Rs_E;
    
	 //////////////////////////////////////////
   /// Execute stage
   ///////////////////////////////////////////
    
    // Declaration of wires 
    wire   ZFlag_E_dp;
    wire [31:0] srcAE, srcBE, shifted_Immediate_E, PCBranchE, ALU_Result;
    wire [4:0] WriteRegE;
    reg [31:0] srcA_after1, srcB_after1, writeDataE;
    
    
    assign srcAE = RD1_E;
    assign srcBE = (ALUSrcE)? SignImmE : srcB_after1;
    // assign writeDataE = RD2_E;
    assign shifted_Immediate_E = (SignImmE << 2);
    assign PCBranchE = shifted_Immediate_E + PCPlus4E;
    assign WriteRegE = (RegDstE)? Rd_E : Rt_E;
    
    always@(*) begin 
    case(forwardaE)  
    
    2'b00:  srcA_after1 <= srcAE;
    
    2'b01:  srcA_after1 <= ResultW;
    
    2'b10:  srcA_after1 <= ALUOutM;
    
    endcase
    
    case(forwardbE)  
    
    2'b00:  begin 
    srcB_after1 <= RD2_E;
    writeDataE <= RD2_E;
    end 
    
    2'b01: begin
    srcB_after1 <= ResultW;
    writeDataE <= ResultW;
    end 
    2'b10: begin
    srcB_after1 <= ALUOutM;
    writeDataE <= ALUOutM;
    end 
    endcase
    
    end 
    
    alu32 alu(.a(srcA_after1),.b(srcBE),.f(ALUControlE),.shamt(5'b0),.y(ALU_Result),.zero(ZFlag_E_dp));
    
	 //////////////////////////////////////////
   /// Memory register
   ///////////////////////////////////////////
    reg RegWriteM, MemtoRegM, MemWriteM, BranchM, ZeroM;
    reg [31:0] ALUOutM, WriteDataM, PCBranchM;
    reg [4:0] WriteRegM;
	 //////////////////////////////////////////
   /// Memory stage
   ///////////////////////////////////////////
    
    // Declaration wires 
    wire PCSrcM;
    
    assign mem_data_addr =  ALUOutM;
    assign data_to_mem = (WriteRegM == WriteRegW)? ResultW : WriteDataM;
    // assign data_to_mem = WriteDataM;
    assign PCSrcM = (BranchM & ZeroM);
    
	 //////////////////////////////////////////
   /// Write register
   ///////////////////////////////////////////
    
    reg RegWriteW, MemtoRegW;
    reg [31:0] ALUOutW, ReadDataW;
    reg [4:0] WriteRegW;
        
	 //////////////////////////////////////////
	 /// Write stage
	 ///////////////////////////////////////////
    wire [31:0] ResultW;
    
    assign ResultW = (MemtoRegW) ? ReadDataW : ALUOutW;
    
    ////////////////////
    // HAZARD Unit
    ////////////////////
    
    wire [1:0] forwardaE, forwardbE;
    wire stallF, stallD, flushE;
    
    hazard hz(
    .rsD(A1), .rtD(Rt_D), .rsE(Rs_E), .rtE(Rt_E),
    .writeregM(WriteRegM), .writeregW(WriteRegW),
    .regwriteM(RegWriteM), .regwriteW(RegWriteW), .regwriteE(RegWriteE),
    .memtoregE(MemtoRegE),
    .forwardaE(forwardaE), .forwardbE(forwardbE),
    .stallF(stallF), .stallD(stallD), .flushE(flushE)
    );
    

   
    reg[31:0] rd1_reg, rd2_reg;
        integer i;

    always @(negedge clk) begin 
    
    

    if(rst) begin 
  
     for (i = 0 ; i < 31; i = i + 1)
        rf[i] <= 0;
    end
    else begin 
    
     if (RegWriteW) begin 
        rf[WriteRegW] <= ResultW;
        end 
    
    end 
    
    end 
    
    
    always @(posedge clk)begin
    
    
    if(rst)begin
     
     
     // IF-ID 
     PC_Reg <= 0;
     InstrD <= 0 ;
     PCPlus4D <= 0 ;
    
     // ID-EX
     RegWriteE <= 0 ;
     MemtoRegE <= 0 ;
     MemWriteE<= 0 ;
     BranchE<= 0 ;
     ALUSrcE<= 0 ;
     RegDstE<= 0 ;
     ALUControlE<= 0 ;
     RD1_E<= 0 ;
     RD2_E<= 0 ;
     SignImmE<= 0 ;
     PCPlus4E<= 0 ;
     Rt_E<= 0 ;
     Rd_E<= 0 ;
     Rs_E <= 0;
    
     // EX-MEM
     RegWriteM <= 0 ;
     MemtoRegM<= 0 ;
     MemWriteM<= 0 ;
     BranchM<= 0 ;
     ZeroM<= 0 ;
     ALUOutM<= 0 ;
     WriteDataM<= 0 ;
     PCBranchM<= 0 ;
     WriteRegM<= 0 ;
    
     // MEM-WB
     RegWriteW <= 0 ;
     MemtoRegW <= 0 ;
     ALUOutW <= 0 ; 
     ReadDataW <= 0 ;
     WriteRegW <= 0 ;
    
    
   end
    
    else begin 
    
    // IF-ID 
    if(!stallF) begin 
     PC_Reg <= PC_Next_dp;
     end 
     
    if(!stallD) begin 
     InstrD <= instr ;
     PCPlus4D <= PCPlus4_F_dp ;
    end 
    
    
    if(!flushE) begin 
    // ID-EX
     RegWriteE <= reg_write_en ;
     MemtoRegE <= mem_to_reg_ctrl ;
     MemWriteE<= mem_write_ctrl ;
     BranchE<= branch_ctrl ;
     ALUSrcE<= alu_src_ctrl ;
     RegDstE<= reg_dst_ctrl ;
     ALUControlE<= alu_func_ctrl ;
     SignImmE<= SignImmD ;
     PCPlus4E<= PCPlus4D ;
     Rt_E  <= Rt_D ;
     Rd_E  <= Rd_D ;
     Rs_E  <= A1 ;
     RD1_E <= rf[A1] ;
     RD2_E <= rf[A2];
     end 
     else begin 
     RegWriteE <= 0 ;
     MemtoRegE <= 0 ;
     MemWriteE<= 0 ;
     BranchE<= 0 ;
     ALUSrcE<= 0 ;
     RegDstE<= 0 ;
     ALUControlE<= 0 ;
     RD1_E<= 0 ;
     RD2_E<= 0 ;
     SignImmE<= 0 ;
     PCPlus4E<= 0 ;
     Rt_E<= 0 ;
     Rd_E<= 0 ;
     Rs_E <= 0;
     
     
     end 
     // EX-MEM
     RegWriteM <= RegWriteE ;
     MemtoRegM<= MemtoRegE ;
     MemWriteM<= MemWriteE ;
     BranchM<= BranchE ;
     ZeroM<= ZFlag_E_dp ;
     ALUOutM<= ALU_Result ;
     WriteDataM<= writeDataE ;
     PCBranchM<= PCBranchE ;
     WriteRegM<= WriteRegE ;
    
     // MEM-WB
     RegWriteW <= RegWriteM ;
     MemtoRegW <= MemtoRegM ;
     ALUOutW <= ALUOutM ; 
     ReadDataW <= data_from_mem ;
     WriteRegW <= WriteRegM ;
    
   
    
    end 
    
    

    
    end
    
endmodule // datapath
