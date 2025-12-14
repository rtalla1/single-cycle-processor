module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
	input [63:0] CurrentPC, SignExtImm64; 
	input Branch, ALUZero, Uncondbranch; 
	output [63:0] NextPC; 

	// if the instruction is an unconditional branch, we should jump to the branch target
	// we should also do this if the instruction is conditional and true
	// otherwise, we should just increment the PC by 4
	assign NextPC = (Uncondbranch | (Branch & ALUZero)) ? (CurrentPC + (SignExtImm64 << 2)) : (CurrentPC + 64'd4);

endmodule
