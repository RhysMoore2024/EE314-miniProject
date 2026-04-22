`timescale 1ns / 1ps

module tb_adder_subtractor;

    // Declare inputs as reg, outputs as wire
    reg  signed [7:0] A;
    reg  signed [7:0] B;
    reg               mode;
    wire signed [7:0] result;
    wire              overflow;

    // Instantiate DUT
    adder_subtractor uut (
        .A        (A),
        .B        (B),
        .mode     (mode),
        .result   (result),
        .overflow (overflow)
    );

    initial begin
        // Initialise all inputs at t=0 to avoid Z
        A = 0; B = 0; mode = 0;

        //  ADDITION 
        // TC1: 15 + 10 = 25
        #10; A = 8'd15;   B = 8'd10;   mode = 0;
        // TC2: 0 + 42 = 42
        #10; A = 8'd0;    B = 8'd42;   mode = 0;
        // TC3: -20 + 50 = 30
        #10; A = -8'd20;  B = 8'd50;   mode = 0;
        // TC4: -10 + -15 = -25
        #10; A = -8'd10;  B = -8'd15;  mode = 0;
        // TC5: 127 + 1 = overflow
        #10; A = 8'sd127; B = 8'sd1;   mode = 0; // sd = signed decimal

        //  SUBTRACTION 
        // TC6: 30 - 10 = 20
        #10; A = 8'd30;   B = 8'd10;   mode = 1;
        // TC7: 55 - 55 = 0
        #10; A = 8'd55;   B = 8'd55;   mode = 1;
        // TC8: 5 - 20 = -15
        #10; A = 8'd5;    B = 8'd20;   mode = 1;
        // TC9: (-10) - (-30) = 20
        #10; A = -8'd10;  B = -8'd30;  mode = 1;
        // TC10: 127 - -1 = overflow
        #10; A = 8'sd127; B = -8'sd1;  mode = 1; // sd = signed decimal

        #10; $finish;
    end

endmodule