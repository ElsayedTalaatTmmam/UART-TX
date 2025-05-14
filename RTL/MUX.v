module MUX (
input       Ser_data,
input       PAR_Bit,
input       CLK,RST,
input [1:0] MUX_SEL,
output reg  TX_OUT
);

reg       mux_out ;
/*********************************** Combinationl Block ***********************************/
always @(*)
      begin
         case(MUX_SEL)
             2'b00 : mux_out = 1'b0;
             2'b01 : mux_out = Ser_data;
             2'b10 : mux_out = PAR_Bit;
             2'b11 : mux_out = 1'b1;
         endcase
      end
	  
/*********************************** OUT_MUX ***********************************/


always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    TX_OUT <= 'b0 ;
   end
  else
   begin
    TX_OUT <= mux_out ;
   end 
 end  
 
endmodule 
