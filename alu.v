module alu(
           a         ,  //input
           b         ,  //input
           select    ,  //input
           zero      ,  //zero flag
           carry     ,  //carry flag
           sign      ,  //sign flag
           parity    ,  //parity flag
           overflow  ,  //overflow flag
           out          //output
           )         ;

input [3:0]a, b                                 ;
input [1:0] select                              ;
output reg [3:0]out                             ;
output reg zero, carry, sign, parity, overflow  ;

always @ (a or b)
   begin
      case (select)
         0 : {carry, out} = a + b   ;
         1 : {carry, out} = a - b   ;
         2 : {carry, out} = a * b   ;
         3 : {carry, out} = a / b   ;
      endcase

      zero     =  ~|out                                              ;
      sign     =  out[3]                                             ;
      parity   =  ~^out                                              ;
      overflow =  (a[3] & b[3] & ~out[3]) | (~a[3] & ~b[3] & out[3]) ;

   end
 
endmodule




testbench for ALU

module alu_tb                             ;  
reg [3:0]a, b                             ;  //register declaration for a & b
reg [1:0]select                           ;  //register declaration for select
wire [3:0]out                             ;  //wire declaration for out
wire zero, carry, sign, parity, overflow  ;  //wire declaration for zero, carry, sign, parity, overflow
reg [3:0]new_out                          ;  //register declaration for new output

// instantiation

alu dut (
         .a(a)              ,  
         .b(b)              ,  
         .select(select)    ,  
         .zero(zero)        ,  
         .carry(carry)      ,  
         .sign(sign)        ,  
         .parity(parity)    ,  
         .overflow(overflow),  
         .out(out)             
          )                 ;

initial begin
   repeat(200)
      begin
         stimulus();#5;
         
         if (new_out == out)
            $display("a = %b, b = %b, select = %b, out = %b, new_out = %b, zero = %b, carry = %b, sign = %b, parity = %b, overflow = %b, Testcase Passed", a, b, select, out, new_out, zero, carry, sign, parity, overflow);

         else
            $display("a = %b, b = %b, select = %b, out = %b, new_out = %b, zero = %b, carry = %b, sign = %b, parity = %b, overflow = %b Testcase Failed", a, b, select, out, new_out, zero, carry, sign, parity, overflow);

      end

end

task stimulus;
reg [3:0]A, B;
reg [1:0]Sl  ;  


begin
   A        = $random   ;
   B        = $random   ;
   Sl       = $random   ;
   a        = A         ;
   b        = B         ;
   select   = Sl        ;

end
endtask

endmodule
