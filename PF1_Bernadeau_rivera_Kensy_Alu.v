

///////////////////////////////arithmetix Logic unit/////////////////////////////
module alu(
           input signed [31:0] A,B,  // 32-bit Inputs                 
           input [5:0] M_sel,// Op Code
           input Cin,  ///carry in
               shift,
           output signed [31:0] Out, // ALU 32-bit Output
            //conditions codes
           output Z,//Zero flag
                  N,//Negative flag
                  C,// Carry Out Flag
                  V// sign change flag
    );
    
    reg signed [31:0] Result;
    reg Zi;
    reg Ni;
    reg Co;
    reg Vi;
    
    wire [32:0] tmp;
    wire [31:0] Ntmp;
   
    
   
    ////////////output///////////////
    assign Out = Result; 
    /////////used for /carry out flag/////////
    assign tmp = {1'b0,A} + {1'b0,B};

    ///////used for negative fag//////////
    assign Ntmp = {1'b0,Out};
   
   
   assign Z=Zi;
  assign  N=Ni;
   assign C=Co;
  assign  V=Vi;
    
    always @(*)
    begin
        case(M_sel)
      
         ////////////Basic Arithmetic instructions////////////  
         6'b000000://add
         begin
            Result = A+B;
            end
         6'b010000://addcc
         begin 
            Result = $signed(A)+$signed(B);   
             Co = tmp[32]; 
             Ni = Ntmp[31]==1;
             Zi= (Result==0);
             Vi= ((A>0&&B>0)&&((A+B)<0))||((A<0&&B<0)&&(A+B)>0);
            
          end 
          
           6'b001000://addx
         begin 
            Result = A + B + Cin;   
             
        
          end 
          6'b011000://addxcc
         begin 
            Result = $signed(A)+$signed(B)+Cin;   
            Co = tmp[32]; //carry out
            Ni = Ntmp[31]==1;
            Zi= (Result==0);
            Vi= ((A>0&&B>0)&&((A+B)<0))||((A<0&&B<0)&&(A+B)>0);
           
          end 
          
          6'b000100://sub
         begin 
            Result = A - B;   
    
          end 
          6'b010100://subcc
         begin 
            Result = $signed(A) - $signed(B);   
            Co = tmp[32]; 
             Ni = Ntmp[31]==1;
            Zi= (Result==0);
             Vi= (A>0&&B<0)&&((A-B)>0)||((A>0&&B<0)&&(A-B)<0);
            
          end 
          6'b010000://subx
         begin 
            Result = $signed(A) -$signed(B)- Cin;   
            
          end 
          6'b011100://subxcc
         begin 
            Result = A - B - Cin;   
            Co= tmp[32]; 
             Ni = Ntmp[31]==1;
            Zi= (Result==0);
            Vi= (A>0&&B<0)&&((A-B)>0)||((A>0&&B<0)&&(A-B)<0);
            
          end 
          /////////////////////////////////////////////////
          ////////////////Logical instructions////////////
          6'b000001: //and 
          begin
           Result =(A & B);
           end
            6'b000001: //andcc 
          begin
           Result = (A & B);
             Co = tmp[32]; 
             Ni = Ntmp[31]==1;
            Zi= (Result==0);
           end
            6'b000101: //andn 
          begin
           Result = (A & ~B);
           end
             6'b000101: //andncc 
          begin
           Result = (A & ~B);
             Co = tmp[32]; 
            Ni = Ntmp[31]==1;
            Zi= (Result==0);
           end
          6'b000010: //or 
          begin
           Result =(A |B);
           end
           6'b010010: //orcc 
          begin
           Result =(A |B);
           Co= tmp[32]; 
             Ni = Ntmp[31]==1;
           Zi= (Result==0);
           end
           6'b000110: //orn 
          begin
           Result =(A |~B);
           end
           6'b010110: //orncc 
          begin
           Result =(A |~B);
            Co = tmp[32]; 
             Ni = Ntmp[31]==1;
           Zi= (Result==0);
           end
           6'b000110: //orn 
          begin
           Result =(A |~B);
           end
            6'b000011: //xor 
          begin
            Result = A ^ B;
           end
             6'b010011: //xorcc 
          begin
            Result = A ^ B;
            Co = tmp[32]; 
            Ni = Ntmp[31]==1;
            Zi= (Result==0);
           end
          6'b000111: //xorn 
          begin
           Result = ~(A ^ B);
           end
            6'b000111: //xorncc 
          begin
           Result = ~(A ^ B);
           Co = tmp[32]; 
            Ni = Ntmp[31]==1;
             Zi= (Result==0);
           end
           
        /////////////////////////////////////////////////////////   
          
         //////////////////////Shift instructions///////////////
         
         
            6'b100101: // logical shift left
            begin
           Result = A<<B;
           end
         6'b100110: // logical shift right
         begin
           Result = A>>B;
            end
            
        6'b100111: // Arithmetic shift right
         begin
           Result = $signed(A)>>>B;
            end
        //////////////////////////////////////////////////// 
        
          default: Result = A + B ; 
        endcase
    end
  
   
endmodule
///////////////////////tester//////////////////////


 `timescale 1ns / 1ps  

module tb_alu;
//Inputs
 reg[31:0] A,B;
 reg[5:0] op_Sel;
 reg[0:0] Cinn;
  
//Outputs
 wire[31:0] Out;
// wire Cin;
 wire shift;
 wire CarryOut;
 wire Z,N,C,V;
   
 // Verilog code for ALU
 integer i;
 alu test_unit(
            A,B,  //  Inputs                 
           op_Sel,// Selection
           Cinn,//carry in
           shift,//shift count
            Out, // ALU 32-bit Output
         ////conditional codes/////
            Z,
            N,
           C, 
           V
         ////////////////////
     );
    initial begin
  
       // Cinn[0]=1;
        Cinn=1'b0;
      
     // op_Sel= 6'b000000;//add
     //  op_Sel= 6'b010000;//addcc
      // op_Sel=  6'b001000;//addx
      // op_Sel= 6'b011000;//addxcc
       //op_Sel= 6'b000100;//sub
     // op_Sel= 6'b010100;//subcc
      // op_Sel= 6'b010000;//subx
      // op_Sel= 6'b011100;//subxcc
      //op_Sel= 6'b000001; //and
      // op_Sel= 6'b000001; //andcc
      // op_Sel=  6'b000010; //or
     //  op_Sel=  6'b010010; //orcc
      // op_Sel= 6'b000110; //orn 
      // op_Sel= 6'b000011; //xor
      // op_Sel=  6'b010011; //xorcc 
     //  op_Sel= 6'b000111; //xorncc
       
       //flag test
      //A = 32'b01111111111111111111111111111111;
      //B = 32'b01111111111111111111111111111111;
     
     // A=32'b11111111111111111111111111100000;//-32
     // B=32'b11111111111111111111111111111011;//-5
      
      
      A=  32'b00000000000000000000000111110100;
      B=  32'b10000000000000000000000000000000;
     
    // A=32'b00000000000000000000000000000000;
   // B=32'b00000000000000000000000000000000;
 
 //or
   
      
     
    end
    initial begin

 $display(" Result                                flags: Z  N  C  V ");
 $monitor("  %b            %b  %b  %b  %b ",Out,Z,N,C,V );
 end
endmodule





module main;


endmodule
