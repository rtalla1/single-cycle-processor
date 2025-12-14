module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input  [63:0] BusW;
    input  [4:0]  RA; // these need to be 5 bits
    input  [4:0]  RB; // to accomodate for 32
    input  [4:0]  RW; // possible registers
    input  RegWr;
    input  Clk;

    // declare 32, 64-bit registers
    reg [63:0] registers [31:0];
     
    // always return 0 when reading XZR
    // otherwise write to the corresponding register
    assign #2 BusA = (RA == 5'd31) ? 64'b0 : registers[RA];
    assign #2 BusB = (RB == 5'd31) ? 64'b0 : registers[RB];
     
    always @ (negedge Clk) begin
        // prevent write to XZR
        if (RegWr && (RW != 5'd31))
            registers[RW] <= #3 BusW;
    end
endmodule
