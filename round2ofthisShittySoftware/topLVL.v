`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:13 04/03/2025 
// Design Name: 
// Module Name:    topLVL 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module topLVL(
	output reg R1,R2,CLK_75,LAT,OE,G1,G2,B1,B2,
	output [2:0] ADDRESS,
	output led1,
	input clk, probe	 
	);
	

	
	/*
		BitPlaneUpperSegmentIndexer will have same address as the output [2:0] address
		BitPlaneLowerSegmentIndexer will have BitPlaneUpperSegmentIndexer address + 8 
		After each overflow ie BitPlaneUpperSegmentIndexer reaching 7 the next region to address will be the next bitplane ie.
		the bitPlaneOffsetIndexer will increment by 16. bitPlaneIndexer will act as the offset point for the bitplanes.
		You will understand based on below diagram.(note distance between upper bound and lower bound is 16 [15 if u want to be pedantic])
		the bound distance of 16 will be covered in half by BitPlaneUpperSegmentIndexer & BitPlaneLowerSegmentIndexer
		
		0(0+0*16)		16(0+1*16)		32(0+2*16)	.....		96(0+6*16)		112(0+7*16)
		.					.					.				.....		.					.
		.					.					.				.....		.					.
		15(15+0*16)		31(15+1*16)		47(15+2*16)	.....		111(15+6*16)	127(15+7*16)
	
	
	*/
	
	/*
		STATES DISCUSSION:
		
		
		clean the registers
		
		display the contents of the entire bit plane
				-clock out the 64 data in both the segments
				-lat and hold oe for the bit plane duration
				-change address get new data
				-repeat until the local counters of one doesnt reach 8
		
		change offset addresses to reflect the next bitplane of the same frame so that the data from the ROM is right
	
	
	
	
	*/
	parameter cleanReg = 3'd0;
	parameter GetDataClocked = 3'd1;
	parameter LatchAndHoldOEForDuration = 3'd2; //Do not change the bitplanemultiplier here at any cost. Refer to the bit plane 
															  //multiplier to know how long to hold. it will be 2^bitplane
	parameter changeAddress = 3'd3; //change the indexers here no touching the bit plane multiplier. But before changing the indexer check if the
											  //indexer is not already 7 or 15. if it is then change the bitplanemultipier here.
	parameter bufferForNewRomdata = 3'd4;//keep control in this state until and unless we are confirm that the 
													 //bitplaneindexers are not 7 or 15. if they are then change bitplane multiplier and
													 //and keep control for another ROM cycle to adjust for read latency
	
	
	 
	reg clkRom;		
	
	reg [2:0] BitPlaneUpperSegmentIndexer;//is the one that loops over from 0-7
	reg [2:0] bitPlaneOffsetMultiplier;  //also acts as the bitplane identifier
	reg [7:0] BCMCounter;
	
	/*(* keep = "true" *)reg [2:0] BitPlaneUpperSegmentIndexer;//is the one that loops over from 0-7
	(* keep = "true" *)reg [2:0] bitPlaneOffsetMultiplier;  //also acts as the bitplane identifier
	(* keep = "true" *)reg [7:0] BCMCounter;*/
	
	//reg [2:0] BitPlaneLowerSegmentIndexer;//is the one that loops over from 8-15
	
	
	
	
	wire [6:0] addressForROMsegment1Access; // => BitPlaneUpperSegmentIndexer + bitPlaneOffsetMultiplier*16;
	wire [6:0] addressForROMsegment2Access; // => BitPlaneLowerSegmentIndexer + bitPlaneOffsetMultiplier*16;
	
	wire [63:0] R1data;
	wire [63:0] R2data;
	wire [63:0] G1data;
	wire [63:0] G2data;
	wire [63:0] B1data;
	wire [63:0] B2data;
	
	
	wire [7:0] requiredBCMValue;
	
	reg [6:0] columnCounter;
	
	reg [1:0] clockPulseCounter;
	reg [2:0] state;
	reg [2:0] delayCounter;
	
	reg clk_out;
	
	reg [2:0] counter;
	
	always @(posedge clk) begin
        if (counter == 3'd7) begin
           counter <= 3'd0; // Reset counter after 8 clock cycles
           clk_out <= ~clk_out; // Toggle the divided clock signal
        end else begin
           counter <= counter + 1'b1; // Increment the counter
        end
   end
	
	initial begin
	
		clkRom = 1'b0;		
		BitPlaneUpperSegmentIndexer = 3'd0;
		//BitPlaneLowerSegmentIndexer = 3'd8;		///!!!!!!!!!!!!!!!THIS IS A PROBLEM.LOOK AT THIS PROBLEM IN THE ADDRESS SEGMENT OF THE CODE !!!!!!!!!!
															//problem sorted i believe. need to remove all traces of bitplanelowerindexer.
		
		bitPlaneOffsetMultiplier = 3'd0;
		columnCounter = 7'd0;
		clockPulseCounter = 2'd0;
		state = 3'd0;
		delayCounter = 3'd0;
		BCMCounter = 8'd0;
		
		R1 =1'b0;
		R2 = 1'b0;
		G1 =1'b0;
		G2 = 1'b0;
		B1 =1'b0;
		B2 = 1'b0;
		CLK_75 = 1'b0;
		LAT = 1'b0;
		OE = 1'b1;
		
		
	end
	
	assign addressForROMsegment1Access = BitPlaneUpperSegmentIndexer + (bitPlaneOffsetMultiplier << 4);
	assign addressForROMsegment2Access = BitPlaneUpperSegmentIndexer + (bitPlaneOffsetMultiplier << 4) + 4'd8;
	
	
	assign requiredBCMValue = 1 << bitPlaneOffsetMultiplier;
	assign led1 = probe;
	
	assign ADDRESS = BitPlaneUpperSegmentIndexer;
	
	 
	 
	ROM_core RedPlane (
	  .clka(clkRom), // input clka
	  .addra(addressForROMsegment1Access), // input [6 : 0] addra
	  .douta(R1data), // output [63 : 0] douta
	  .clkb(clkRom), // input clkb
	  .addrb(addressForROMsegment2Access), // input [6 : 0] addrb
	  .doutb(R2data) // output [63 : 0] doutb
	);
	
	ROM_core_green Green (
	  .clka(clkRom), // input clka
	  .addra(addressForROMsegment1Access), // input [6 : 0] addra
	  .douta(G1data), // output [63 : 0] douta
	  .clkb(clkRom), // input clkb
	  .addrb(addressForROMsegment2Access), // input [6 : 0] addrb
	  .doutb(G2data) // output [63 : 0] doutb
	);
	
	ROM_core_Blue Blue (
	  .clka(clkRom), // input clka
	  .addra(addressForROMsegment1Access), // input [6 : 0] addra
	  .douta(B1data), // output [63 : 0] douta
	  .clkb(clkRom), // input clkb
	  .addrb(addressForROMsegment2Access), // input [6 : 0] addrb
	  .doutb(B2data) // output [63 : 0] doutb
	);


	//column counter is a point of contentino i do not like it being 1 bit longer than needed

	always@(posedge clk_out) begin
	
		case(state)
		
			cleanReg:begin
						R1 <= 1'b0;
						R2 <= 1'b0;
						G1 <= 1'b0;
						G2 <= 1'b0;
						B1 <= 1'b0;
						B2 <= 1'b0;
						if(columnCounter < 7'd64) begin
							if(clockPulseCounter < 2'd3) begin
								clockPulseCounter <= clockPulseCounter + 1'b1;
								CLK_75 <= 1'b1;
							end
							else begin
								CLK_75 <= 1'b0;
								clockPulseCounter <= 2'd0;
								columnCounter <= columnCounter + 1'b1;
							end
						end
						else begin
							columnCounter <= 7'd0;
							state <= GetDataClocked;
						end
						end
						
			GetDataClocked:begin
										if(columnCounter < 7'd64) begin
											R1 <= R1data[6'd63 - columnCounter];
											R2 <= R2data[6'd63 - columnCounter];
											G1 <= G1data[6'd63 - columnCounter];
											G2 <= G2data[6'd63 - columnCounter];
											B1 <= B1data[6'd63 - columnCounter];
											B2 <= B2data[6'd63 - columnCounter];
											if(clockPulseCounter < 2'd3) begin
												clockPulseCounter <= clockPulseCounter + 1'b1;
												CLK_75 <= 1'b1;
											end
											else begin
												CLK_75 <= 1'b0;
												clockPulseCounter <= 2'd0;
												columnCounter <= columnCounter + 1'b1;
											end
										end
										else begin
											columnCounter <= 7'd0;
											state <= LatchAndHoldOEForDuration;
										end
								end
			LatchAndHoldOEForDuration:begin
													LAT <= 1'b1;
													if (delayCounter == 3'd7) begin
														OE <= 1'b0;
														LAT <= 1'b0;
														if(BCMCounter == requiredBCMValue) begin
															BCMCounter <= 8'd0;
															state <= changeAddress;
															delayCounter <= 4'd0;
														end
														else begin
															BCMCounter <= BCMCounter + 8'b1;
															state <= LatchAndHoldOEForDuration;
															OE <= 1'b1;
														end
													end
													else begin
														delayCounter <= delayCounter + 1'b1;
														state <= LatchAndHoldOEForDuration;
													end												
											  end
			changeAddress:begin
									if(BitPlaneUpperSegmentIndexer == 3'd7) begin
										BitPlaneUpperSegmentIndexer <= 3'd0;
										bitPlaneOffsetMultiplier <= bitPlaneOffsetMultiplier + 1'd1;
									end
									else
										BitPlaneUpperSegmentIndexer <= BitPlaneUpperSegmentIndexer + 1'd1;
									state <= bufferForNewRomdata;							  
							  end
							  
							  
										//pulse clkROM twice to get new data from ROM. 1st = actual address data fetching
										//2nd to account for ready latency
			bufferForNewRomdata:begin
											if(delayCounter < 3'd6) begin
												clkRom <= ~clkRom;
												delayCounter <= delayCounter + 1'd1;
												state <= bufferForNewRomdata;												
											end
											else begin
												clkRom <= 1'b0;
												delayCounter <= 3'd0;
												state <= GetDataClocked;											
											end								  
									  end
										
		
		endcase
		

	
	end



endmodule
