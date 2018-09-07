// file: hazard.v
// author: @arefaat

`timescale 1ns/1ns

module hazard(
input [4:0] rsD, rtD, rsE, rtE,
input [4:0] writeregM, writeregW,
input regwriteM, regwriteW, regwriteE,
input memtoregE,
output reg [1:0] forwardaE, forwardbE,
output reg stallF, stallD, flushE
);

always @(*) begin 
    
    forwardaE <= 0;
    forwardbE <= 0;
    
    //  stallF <= (regwriteM & ((rsE == writeregM)|(rtE == writeregM)) & memtoregM);
    //  stallD <= (regwriteM & ((rsE == writeregM)|(rtE == writeregM)) & memtoregM);
    
         stallF <=        (memtoregE && ((rtE==rsD)||(rtE==rtD)) && regwriteE);
         stallD <=        (memtoregE && ((rtE==rsD)||(rtE==rtD)) && regwriteE);
         flushE <=        (memtoregE && ((rtE==rsD)||(rtE==rtD)) && regwriteE);
        
        
        
        if ((rsE != 0) && regwriteM && (writeregM == rsE))
                forwardaE <= 2'b10;
        else if((rsE != 0)&&regwriteW && (writeregW == rsE))
                forwardaE <= 2'b01;
           
            
        if((rsE != 0) && regwriteM && (writeregM == rtE))
                forwardbE <= 2'b10;
        else if((rsE != 0) && regwriteW && (writeregW == rtE))
                forwardbE <= 2'b01;
            
    // if(regwriteM)begin 
    //     if(rsE == writeregM) begin  
    //          forwardaE <=1;
    //     end 
    //     if (rtE == writeregM) begin 
    //          forwardbE <= 1;
    //     end 
    // end 
    
    // if(regwriteW)begin 
    //     if(rsE == writeregW)begin 
    //          forwardaE <= 2;
    //     end 
    //     if (rtE == writeregW) begin 
    //          forwardbE <= 2;
    //     end 
    // end 
    
end 
endmodule