// file: ControlUnit.v
// author: @arefaat

`timescale 1ns/1ns

module ControlUnit(RegWrite, RegDst, ALUSrc, ALUControl, Branch, MemWrite, MemtoReg, op, Funct,jump);

output reg RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemtoReg,jump;
output reg[3:0] ALUControl;
input [5:0] Funct, op;


always @(*) begin 
		/* defaults */
		ALUControl	<= 4'b0001;
		ALUSrc		<= 1'b0;
		Branch	    <= 1'b0;
		MemWrite	<= 1'b0;
		MemtoReg	<= 1'b0;
		RegDst		<= 1'b1;
		RegWrite	<= 1'b1;
        jump        <= 1'b0;
		case (op)
		    6'b000000: begin
		    
		    	
	        	ALUSrc		<= 1'b0;
	        	Branch	    <= 1'b0;
	        	MemWrite	<= 1'b0;
	        	MemtoReg	<= 1'b0;
	        	RegDst		<= 1'b1;
	        	RegWrite	<= 1'b1;
	        	
		    case(Funct)
		   
		    6'b100000: //add
		    ALUControl	<= 4'b0000;
            6'b100101: //or
            ALUControl	<= 4'b0011;
            6'b100100://and
            ALUControl	<= 4'b0010;
            6'b100010: //sub
            ALUControl	<= 4'b0001;
            6'b101010://Slt
            ALUControl	<= 4'b1001;
		    endcase
		    
		    
		    end 
			6'b100011: begin	/* lw */
				MemWrite    <= 1'b0;
				RegDst      <= 1'b0;
				MemtoReg    <= 1'b1;
				ALUControl  <= 4'b0;
				ALUSrc      <= 1'b1;
			end
			
			6'b101011: begin	/* sw */
				MemWrite     <= 1'b1;
				ALUControl   <= 4'b0;
				ALUSrc       <= 1'b1;
				RegWrite     <= 1'b0;
			end
			
			
			6'b001000: begin	/* addi */
				RegDst       <= 1'b0;
				ALUControl   <= 4'b0;
				ALUSrc       <= 1'b1;
			end
			
			6'b000100: begin	/* beq */
			    Branch    <= 1'b1;
				RegWrite  <= 1'b0;
			end
			
		
		    6'b000010: begin	/* J */
                jump      <= 1'b1;
			end
		
		
		endcase
	end


endmodule