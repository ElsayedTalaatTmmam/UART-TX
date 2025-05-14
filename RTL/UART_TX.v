
module UART_TX # (parameter Data_Width=8 ,Counter_Width=3 ) (
input wire [Data_Width-1:0] P_DATA,
input wire                  Data_Valid,
input wire                  PAR_TYP,
input wire                  PAR_EN,
input wire                  CLK,RST,
output wire                 busy,
output wire                 TX_OUT
);

/*********************************** Internal Signals ***********************************/
wire       Ser_done_tx;
wire       Ser_data_tx;
wire       Ser_EN_tx;
wire       PAR_Bit_tx;
wire [1:0] MUX_SEL_tx;

/*********************************** Serializer Module ***********************************/
Serializer # (.Data_Width(Data_Width), .Counter_Width(Counter_Width)) Serializer_TX (
.Ser_EN(Ser_EN_tx),
.P_DATA(P_DATA),
.Ser_done(Ser_done_tx),
.Ser_data(Ser_data_tx),
.Busy(busy),
.Data_Valid(Data_Valid), 
.CLK(CLK),
.RST(RST)
);

/*********************************** FSM Module ***********************************/
FSM FSM_TX (
.Data_Valid(Data_Valid),
.PAR_EN(PAR_EN),
.busy(busy),
.Ser_done(Ser_done_tx),
.Ser_EN(Ser_EN_tx),
.CLK(CLK),
.RST(RST),
.MUX_SEL(MUX_SEL_tx)
);

/*********************************** Parity Module ***********************************/
Parity  # (.Data_Width(Data_Width)) Parity_TX (
.P_DATA(P_DATA),
.Data_Valid(Data_Valid),
.PAR_TYP(PAR_TYP),
.PAR_Bit(PAR_Bit_tx),
.Busy(busy),
.PAR_EN(PAR_EN),
.CLK(CLK),
.RST(RST)
);

/*********************************** MUX Module ***********************************/
MUX MUX_TX (
.CLK(CLK),
.RST(RST),
.Ser_data(Ser_data_tx),
.PAR_Bit(PAR_Bit_tx),
.MUX_SEL(MUX_SEL_tx),
.TX_OUT(TX_OUT)
);

endmodule 