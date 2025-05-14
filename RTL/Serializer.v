
module Serializer
/************************************* paramaters ***************************************/
#(parameter Data_Width=8 , parameter Counter_Width=3) 

/************************************* Declaration **************************************/
(
input wire [Data_Width-1:0] P_DATA,
input wire                  Ser_EN,
input wire                  CLK,RST,
input wire                  Busy,
input wire                  Data_Valid,
output reg                  Ser_done,
output reg                  Ser_data
);
/*********************************** Internal Signals ***********************************/
reg [Data_Width-1:0]    Register;
reg [Counter_Width-1:0] Counter;


always @ (posedge CLK or negedge RST)
    begin
      if (!RST)
          begin
              Register<='b0;
          end

      else if(Data_Valid && !Busy)
          begin
             Register<=P_DATA;
          end

      else if(Ser_EN)
          begin
             Register<= Register>>1;
          end
    end

always @ (posedge CLK or negedge RST)
    begin
      if (!RST)
          begin
              Counter <='b0;
          end

      else if(Ser_EN)
          begin
             Counter <= Counter+1;
          end

      else
          begin
             Counter <= 'b0;
          end
    end

always @(*)
   begin
         Ser_data=Register[0];
      if(Counter==3'b111)
          Ser_done='b1;
      else
          Ser_done='b0;
   end
endmodule 