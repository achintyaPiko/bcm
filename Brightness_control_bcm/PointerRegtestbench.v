`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:08:16 02/19/2025
// Design Name:   pointerRegister
// Module Name:   /home/ise/Shared-Directory-ISE/Brightness_control_bcm/PointerRegtestbench.v
// Project Name:  Brightness_control_bcm
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

module PointerRegtestbench;

	// Inputs
	reg operation_dn;

	// Outputs
	wire [6:0] address;
	
	pointerRegister uut (
		.operation_dn(operation_dn), 
		.address(address)
	);
	
	initial begin
		
		#0 operation_dn = 0;
		#1 force operation_dn = 0;  // FORCE assignment for ISim

		// Generate pulses
		#20 operation_dn = 1;
		#10 operation_dn = 0;
		#10 operation_dn = 1;
		#10 operation_dn = 0;
		#10 operation_dn = 1;
		#10 operation_dn = 0;

		// End simulation
		#50 $finish;
	end
	
	// Optional toggling block (if needed)
	//always #5 operation_dn = ~operation_dn; // Only use if continuous toggling is needed
	
	// Instantiate the Unit Under Test (UUT)
	initial begin
		$monitor("Time=%0t, operation_dn=%b, address=%d", $time, operation_dn, address);
	end
	

	
      
endmodule	

		


	




