`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:42:49 02/19/2025
// Design Name:   pointerRegister
// Module Name:   /home/ise/brightnessControlBCM/pointerTB.v
// Project Name:  brightnessControlBCM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pointerRegister
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk,rst_n;
	
	// Outputs
	wire [7:0] address;

	always #10 clk = ~clk;
	always #6000 rst_n = ~rst_n;
	
	
	pointerRegister dut(
		.clk(clk),
		.rst_n(rst_n),
		.address(address)
	);

	initial begin

		clk = 0;
		rst_n = 1;
		
		
        
		

	end
      
endmodule


