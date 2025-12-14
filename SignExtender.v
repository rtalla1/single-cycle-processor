module SignExtender(
	output reg [63:0] imm64,
	input [25:0] instr,
	input [2:0]  ctrl   // need to handle MOVZ
); 

	wire [11:0] imm12 = instr[21:10]; // I-type
	wire [8:0]  imm9  = instr[20:12]; // D-type
	wire [25:0] imm26 = instr[25:0];  // B-type
	wire [18:0] imm19 = instr[23:5];  // CB-type
   
	always @(*) begin
		case (ctrl)
			// I-type: zero-extend (since immediate is always unsigned)
			3'b000:   imm64 = {52'b0, imm12};
			// D-type: sign-extend
			3'b001:   imm64 = {{55{imm9[8]}}, imm9};
			// B-type: sign-extend
			3'b010:   imm64 = {{38{imm26[25]}}, imm26};
			// CB-type: sign-extend
			3'b011:   imm64 = {{45{imm19[18]}}, imm19};
			// MOVZ
			3'b100:
            begin
                case(instr[22:21]) // halfword selector bits
                    2'b00: 		   // shift 2^0
                        imm64 = {48'b0, instr[20:5]};
                    2'b01:         // shift 2^16
                        imm64 = {32'b0, instr[20:5], 16'b0};
                    2'b10:         // shift 2^32
                        imm64 = {16'b0, instr[20:5], 32'b0};
                    2'b11:         // shift 2^48
                        imm64 = {instr[20:5], 48'b0};
					
					default: imm64 = 64'b0;
                endcase
            end

			default: imm64 = 64'b0;
		endcase
	end
endmodule
