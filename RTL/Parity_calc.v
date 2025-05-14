
module Parity #(parameter Data_Width=8)
(
input wire [Data_Width-1:0] P_DATA,
input wire                  Data_Valid,
input wire                  PAR_TYP,
input wire                  PAR_EN,
input wire                  Busy,
input wire                  CLK,RST,
output reg                  PAR_Bit
);

reg  [Data_Width-1:0]    Data_C;

/*********************************** isolation  ***********************************/
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    Data_C <= 'b0 ;
   end
  else if(Data_Valid && !Busy)
   begin
    Data_C <= P_DATA ;
   end 
 end
 
/*********************************** Sequential Block ***********************************/
always @(posedge CLK or negedge RST)
     begin
        if (!RST)
            begin
              PAR_Bit<='b0;
            end
        else if (PAR_EN)
            begin
                 if (PAR_TYP)
                    PAR_Bit<= ~^Data_C;
                 else 
                    PAR_Bit<= ^Data_C;
            end
     end
endmodule 