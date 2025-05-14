
`timescale 1us/1ns
module UART_TX_TB #(parameter Data_Width=8 ) ();

/************************************* paramater ****************************************/
parameter CLK_Period =8.680555555;
///integer I;

/************************************ DUT Signals ***************************************/
reg [Data_Width-1:0] P_DATA_TB;
reg                  Data_Valid_TB;
reg                  PAR_TYP_TB;
reg                  PAR_EN_TB;
reg                  CLK_TB;
reg                  RST_TB;
wire                 busy_TB;
wire                 TX_OUT_TB;

/*********************************** Internal Signals ***********************************/
/*reg [10:0] Frame_Parity;
reg [9:0]  Frame_NoParity;

/*********************************** UART_TX Module ***********************************/
/*********************************** Instantiations ***********************************/
UART_TX  DUT (
.Data_Valid(Data_Valid_TB),
.P_DATA(P_DATA_TB),
.PAR_TYP(PAR_TYP_TB),
.PAR_EN(PAR_EN_TB),
.CLK(CLK_TB),
.RST(RST_TB),
.busy(busy_TB),
.TX_OUT(TX_OUT_TB)
);

/*********************************** CLOCK Generator ***********************************/
always #(CLK_Period/2) CLK_TB = ~CLK_TB;

/****************************************************************************************************///////
/************************************************** initial block **************************************************/ 
/****************************************************************************************************///////
initial
 begin
 // Initialization
 Initialization() ;
 // Reset
 RESET() ; 
 
 /************************************************** Test Case 1 (No Parity) **************************************************/
 // UART Configuration (Parity Enable = 0)
 UART_CONFG (1'b0,1'b0);
 // Load Data 
 DATA_IN(8'hA3);  
 // Check Output
 CHECKED(8'hA3,0) ;
 #200
 
/*********************************** Test Case 2 (Even Parity) **************************************************/

 // UART Configuration (Parity Enable = 1 && Parity Type = 0)
 UART_CONFG (1'b1,1'b0);
 // Load Data 
 DATA_IN(8'hB4);  
 // Check Output
 CHECKED(8'hB4,1) ;
 #200
 
/*********************************** Test Case 3 (Even Parity) **************************************************/

 // UART Configuration (Parity Enable = 1 && Parity Type = 0)
 UART_CONFG (1'b1,1'b0);
 // Load Data 
 DATA_IN(8'hA0);  
 // Check Output
 CHECKED(8'hA0,2) ;
 #200
 
 ////////////// Test Case 4 (Odd Parity) **************************************************/
 // UART Configuration (Parity Enable = 1 && Parity Type = 1)
 UART_CONFG (1'b1,1'b1);
 // Load Data 
 DATA_IN(8'hD2);  
 // Check Output
 CHECKED(8'hD2,3) ; 
  #200

/*********************************** Test Case 5 (no Parity With Type Parity) **************************************************/
 // UART Configuration (Parity Enable = 0 && Parity Type = 1)
 UART_CONFG (1'b0,1'b1);
 // Load Data 
 DATA_IN(8'h7F);  
 // Check Output
 CHECKED(8'h7F,4) ; 
  #200

$stop ;

end
 
 
/*initial 
   begin
     $dumpfile("UART_TX.cdv");
     $dumpvars;
     Initialization();
     RESET();
    $display (" Test DATA With EVEN Parity");
     DATA_EVEN_Parity(8'b00111000 , 1);
     CHECK_DATA_Parity(11'b0_00011100_0_1);
     #CLK_Period;
    $display (" Test DATA With ODD Parity");
     DATA_ODD_Parity(8'b00101001 , 1);
     CHECK_DATA_Parity(11'b0_10010100_1_1);
     #CLK_Period;
    $display (" Test DATA __ NO Parity");
     DATA_NO_Parity(8'b01101001 , 1);
     CHECK_DATA_NO_Parity(10'b0_10010110_1);
    $display (" Test DATA With EVEN Parity __2");
     DATA_EVEN_Parity(8'b00110101 , 1);
     CHECK_DATA_Parity(11'b0_10101100_1_1);
     #100
     $finish;
   end


/*************************************** TASKS ****************************************/
/*********************************** Initialization ***********************************/
task Initialization;
  begin
    CLK_TB='b0;
    RST_TB='b1;
    P_DATA_TB='h0;
    Data_Valid_TB='b0;
    PAR_TYP_TB='b0;
    PAR_EN_TB='b0;
  end
endtask 

/*************************************** RESET ***************************************/
task RESET;
  begin
    #CLK_Period;
     RST_TB='b0;
    #CLK_Period;
     RST_TB='b1;
    #CLK_Period;
  end
endtask

/*********************************** EVEN Parity *************************************/
/*task DATA_EVEN_Parity;
 input [Data_Width-1:0] P_DATA;
 input                  Data_Valid;
  begin
    P_DATA_TB = P_DATA;
    Data_Valid_TB = Data_Valid;
    PAR_EN_TB ='b1;
    PAR_TYP_TB ='b0; //even=0
    #(CLK_Period*2)
    for (I=10;I>=0;I=I-1)
      begin
        #CLK_Period;
        Frame_Parity[I]= TX_OUT_TB;
      end
  end
endtask

/*********************************** ODD Parity **************************************/
/*task DATA_ODD_Parity;
 input [Data_Width-1:0] P_DATA;
 input                  Data_Valid;
  begin
    P_DATA_TB = P_DATA;
    Data_Valid_TB = Data_Valid;
    PAR_EN_TB ='b1;
    PAR_TYP_TB ='b1; //odd=1
    #(CLK_Period*2)
    for (I=10;I>=0;I=I-1)
      begin
        #CLK_Period;
        Frame_Parity[I]= TX_OUT_TB;
      end
  end
endtask

/*********************************** NO Parity ***************************************/
/*task DATA_NO_Parity;
 input [Data_Width-1:0] P_DATA;
 input                  Data_Valid;
  begin
    P_DATA_TB = P_DATA;
    Data_Valid_TB = Data_Valid;
    PAR_EN_TB ='b0;
    #(CLK_Period*2)
    for (I=9;I>=0;I=I-1)
      begin
        #CLK_Period;
        Frame_NoParity[I]= TX_OUT_TB;
      end
  end
endtask	

/*********************************** CHECKING ***************************************/
/*********************************** PARITY ***************************************/
/*task CHECK_DATA_Parity;
 input CHECK_Frame_Parity;
  begin
    // wait(!busy_TB);
       if(CHECK_Frame_Parity==Frame_Parity)
        $display (" Test DATA  Parity is PASSED");
       else
        $display (" Test DATA  Parity is FAILD");
   $display ("%b",Frame_Parity);
  end
endtask

/*********************************** NO Parity ***************************************/
/*task CHECK_DATA_NO_Parity;
 input CHECK_Frame_NoParity;
  begin
    // wait(!busy_TB);
       if(CHECK_Frame_NoParity==Frame_NoParity)
        $display (" Test DATA __ NO Parity is PASSED");
       else
        $display (" Test DATA __ NO Parity is FAILD");
   $display ("%b",Frame_NoParity);
  end
endtask*/


/************************************************** Configuration **************************************************/
task UART_CONFG ;
  input                   PAR_EN ;
  input                   PAR_TYP ;

  begin
	PAR_EN_TB  = PAR_EN   ;
	PAR_TYP_TB    = PAR_TYP   ;
  end
endtask

/************************************************** Data IN **************************************************/
task DATA_IN ;
 input  [Data_Width-1:0]  DATA ;

 begin
	P_DATA_TB         = DATA  ;
	Data_Valid_TB     = 1'b1   ;
	#CLK_Period
	Data_Valid_TB     = 1'b0   ;
 end
endtask

/************************************* Check Output  **************************************************/
task CHECKED ;
 input  [Data_Width-1:0]  		DATA    ;
 input  [3:0]                   count;
 
 reg    [10:0]  checked_out ,expected_out;     //longest frame = 11 bits (1-start,1-stop,8-data,1-parity)
 reg    [9:0]   checked_out_n ,expected_out_n;  
 reg            parity_bit;
 
 integer   i  ;

 begin
 
	@(posedge busy_TB)
	for(i=0; i<11; i=i+1)
		begin
		@(negedge CLK_TB)
begin	
if(PAR_EN_TB)
		checked_out[i] = TX_OUT_TB ;
	else
		expected_out_n[i] = TX_OUT_TB ;
		
end
		end
		
    if(PAR_EN_TB)
		if(PAR_TYP_TB)
			parity_bit = ~^DATA ;
		else
			parity_bit = ^DATA ;
	else
			parity_bit = 1'b1 ;	
	
    if(PAR_EN_TB)
		expected_out = {1'b1,parity_bit,DATA,1'b0} ;
	else
		expected_out_n = {1'b1,DATA,1'b0} ;
		
if	(PAR_EN_TB)
  begin	
	if(checked_out == expected_out) 
		begin
		    $display("                                             ");
			$display(" Case %d is PASSED",count);
			$display(" INput= %b ",DATA);
			$display(" Output= %b ",expected_out);
			$display(" /////////////////////////////////////////// ");
		end
	else
		begin
	     	$display("                                             ");
			$display(" Case %d is FAILD", count);
			$display(" INput= %b ",DATA);
			$display(" Output= %b", expected_out);
			$display(" /////////////////////////////////////////// ");	
		end
  end
else 
  begin	
	if(expected_out_n == expected_out_n) 
		begin
	    	$display("                                             ");
			$display(" Case %d is PASSED",count);
			$display(" INput= %b ",DATA);
			$display(" Output= %b ",expected_out_n);
			$display(" /////////////////////////////////////////// ");
		end
	else
		begin
		    $display("                                             ");
			$display(" Case %d is FAILD", count);
			$display(" INput= %b ",DATA);
			$display(" Output= %b", expected_out_n);	
			$display(" /////////////////////////////////////////// ");		
		end
  end
  
 end
endtask


endmodule 