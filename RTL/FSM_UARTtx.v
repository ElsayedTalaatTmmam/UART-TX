
module FSM (
/************************************* Declaration **************************************/
input wire        PAR_EN,
input wire        Data_Valid,
input wire        Ser_done,
input wire        CLK,RST,
output reg        Ser_EN,
output reg        busy,
output reg [1:0]  MUX_SEL
);
/************************************* paramaters ***************************************/
localparam IDEAL = 3'b000,
           START = 3'b001,
           DATA  = 3'b010,
           PARITY= 3'b011,
           ST0P  = 3'b100;

/*********************************** Internal Signals ***********************************/
reg [2:0] next_state;
reg [2:0] current_state;
reg       busy_FSM;

/*********************************** Sequential Block ***********************************/
always @(posedge CLK or negedge RST)
       begin
           if(!RST)
              current_state<=IDEAL;
           else
              current_state<=next_state;
       end

always @(*)
       begin
           case(current_state)
             IDEAL: begin
                        if(Data_Valid)
                           next_state=START;
                        else
                           next_state=IDEAL;
                    end

             START: begin
                           next_state=DATA;
                    end

             DATA : begin
                        if(!Ser_done)
                           next_state=DATA;
                        else if(PAR_EN)
                           next_state=PARITY;
                        else 
                           next_state=ST0P;
                    end

             PARITY: begin
                           next_state=ST0P;
                    end

             ST0P : begin
                        if(Data_Valid)
                           next_state=START;
                        else
                           next_state=IDEAL;
                    end
             default : begin next_state=IDEAL; end

           endcase
       end

always @(*)
       begin
	        Ser_EN = 1'b0 ;
            MUX_SEL = 2'b00 ;	
            busy_FSM = 1'b0 ;
          case(current_state)
             IDEAL : begin 
			          MUX_SEL=2'b11;
				      Ser_EN = 1'b0 ;	
                      busy_FSM = 1'b0 ;
					end 
					
             START : begin 
			          MUX_SEL=2'b00;
				      Ser_EN = 1'b0 ;	
                      busy_FSM = 1'b1 ;
					end   
					
             DATA  :  begin 
			          MUX_SEL=2'b01;
				      Ser_EN = 1'b1 ;	
                      busy_FSM = 1'b1 ;
			if(Ser_done)
			 Ser_EN = 1'b0 ;  
			else
 			 Ser_EN = 1'b1 ; 
					end   
					
             PARITY:  begin 
			          MUX_SEL=2'b10;	
                      busy_FSM = 1'b1 ;
					end   
					
		      ST0P:  begin 
			          MUX_SEL=2'b11;
                      busy_FSM = 1'b1 ;
					end   

           default :  begin 
			          MUX_SEL=2'b00;
				      Ser_EN = 1'b0 ;	
                      busy_FSM = 1'b0 ;
					end   
          endcase

       end
	   
 always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    busy <= 1'b0 ;
   end
  else
   begin
    busy <= busy_FSM ;
   end
 end
  
endmodule 