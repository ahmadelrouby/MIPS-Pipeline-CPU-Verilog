// file: ROM.v
// author: @arefaat

`timescale 1ns/1ns

module ROM(adr,dout);

parameter n = 32 ;
parameter m = 32 ;

input [n-1:0]adr;
output [m-1:0]dout;

reg [m-1:0]mem[127:0];

initial begin
// mem[0]<=32'h214A0001;
// mem[0]<=32'h21490001; // addi t1 t2 1
// mem[4]<=32'h21290001;   // addi t1 t1 1
// mem[8]<=32'h21290001;   // addi t1 t1 1
// mem[12]<=32'h21290001;  // addi t1 t1 1
// mem[16]<=32'h21290001;  // addi t1 t1 1
// mem[20]<=32'h08000007; // Jump to addr 4
// // mem[20]<=32'h21290001; // addi t1 t1 1
// mem[24]<=32'h21290001; // addi t1 t1 1

// mem[28]<=32'h214A0002;  // addi t2 t2 2
// mem[32]<=32'h01495824; // and t3 t2 t1
// mem[36]<=32'h01495825; // or t3 t2 t1

// mem[40]<=32'h012A5822; // sub t3 t1 t2
// mem[44]<=32'h012A582A; // slt t3 t1 t2
// mem[48]<=32'h0149582A; // slt t3 t2 t1

// mem[52]<=32'h210A0001;  // addi t2 t0 1
// mem[56]<=32'h116A0001; // beq t3 t2 offset = 1

// mem[64]<=32'h21290001;   // addi t1 t1 1

// mem[68]<=32'h214A0002;  // addi t2 t2 2  ===> T2 = 2 AND t1 = 6
// mem[72]<=32'hAD490010;   // sw t1 0x10 t2 -- Memory[18] = 6
// mem[76]<=32'h8D4B0010;   // lw t3 0x10 t2 -- t3 = Memory[18] = 6
// mem[80]<=32'h012B5820;   // add t3 t1 t3 --- t3 = 12

// 	addi $2, $0, 5 		# initialize $2 = 5
// 	addi $3, $0, 12 	# initialize $3 = 12
// 	addi $7, $3, âˆ’9 	# initialize $7 = 3
// 	or $4, $7, $2 		# $4 = (3 OR 5) = 7
// 	and $5, $3, $4 		# $5 = (12 AND 7) = 4
// 	add $5, $5, $4 		# $5 = 4 + 7 = 11 14
// 	beq $5, $7, end 	# shouldn't be taken
// 	slt $4, $3, $4 		# $4 = 12 < 7 = 0
// 	beq $4, $0, around 	# should be taken
// 	addi $5, $0, 0 		# shouldnâ€™ t happen
// around: slt $4, $7, $2 		# $4 = 3 < 5 = 1
// 	add $7, $4, $5 		# $7 = 1 + 11 = 12
// 	sub $7, $7, $2 		# $7 = 12 âˆ’ 5 = 7
// 	sw $7, 68($3) 		# [80] = 7
// 	lw $2, 80($0) 		# $2 = [80] = 7
// 	j end 			# should be taken
// 	addi $2, $0, 1 		# shouldn't happen
// end: 	sw $2, 84($0)		# write mem[84] = 7

// mem[0] <= 32'h20090001; //  addi t1 zero 0x1
// mem[4] <= 32'h200A0002; //  addi t2 zero 0x2
// mem[8] <= 32'h200B0003; //  addi t3 zero 0x3
// mem[12] <= 32'h200C0004; //  addi t4 zero 0x4
// mem[16] <= 32'h200D0005; //  addi t4 zero 0x5
// mem[20] <= 32'h00000000;
// mem[24] <= 32'hAD2A0000; // sw t2, 0(t1)


//////////////////////
// LAST ONE TO DO 
////////////////////
// mem[0] <= 32'h20090001; //  addi t1 zero 0x1
// mem[4] <= 32'h212A0001; //  addi t2 t1 0x1
// mem[8] <= 32'h21290001; //  addi t1 t1 0x1
// mem[12] <= 32'h214A0001; //  addi t2 t2 0x1
// mem[16] <= 32'h214A0001; //  addi t2 t2 0x1
// mem[20] <= 32'h21290001; //  addi t1 t1 0x1
// mem[24] <= 32'h214A0001; //  addi t2 t2 0x1


//////////////////////
//BEFORE LAST
//////////////////////

        mem[0] = 32'h20100005; //ADDI s0 zero 5
        mem[4] = 32'h2011000a; //ADDI s1 zero 10
        mem[8] = 32'h02114020; //ADD t0 s0 s1
        mem[12] = 32'h02114020; //ADD t0 s0 s1
        mem[16]= 32'hAE310000; //sw s1 0x0 s1
        mem[20]= 32'h8E290000; //lw t1 0x0 s1   
        mem[24]= 32'h01095022; //sub t2 t0 t1
        mem[28]= 32'h014A5824; //and t3 t2 t2
       

// mem[0] <= 32'h20020005;
// mem[4] <= 32'h2003000c;
// mem[8] <= 32'h2067fff7;
// mem[12] <= 32'h00e22025;
// mem[16] <= 32'h00642824;
// mem[20] <= 32'h00a42820;
// mem[24] <= 32'h10a7000a;
// mem[28] <= 32'h0064202a;
// mem[32] <= 32'h10800001;
// mem[36] <= 32'h20050000;
// mem[40] <= 32'h00e2202a;
// mem[44] <= 32'h00853820;
// mem[48] <= 32'h00e23822;
// mem[52] <= 32'hac670044;
// mem[56] <= 32'h8c020050;
// mem[60] <= 32'h08000011;
// mem[64] <= 32'h20020001;
// mem[68] <= 32'hac020054;

// mem[0] <= 32'h

end

assign dout = mem[adr];

endmodule