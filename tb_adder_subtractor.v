`timescale 1ns / 1ps

module tb_adder_subtractor;

    // Declare inputs as reg, outputs as wire
    reg  signed [9:0] A;
    reg  signed [9:0] B;
    reg         [1:0] mode;
    wire signed [9:0] result;
    wire              overflow;
    wire              div_by_zero;

    // Instantiate DUT
    adder_subtractor_divider uut (
        .A        (A),
        .B        (B),
        .mode     (mode),
        .result   (result),
        .overflow (overflow),
        .div_by_zero(div_by_zero)
    );

    initial begin
        // Initialise all inputs at t=0 to avoid Z
        A = 0; B = 0; mode = 0;

        //  ADDITION 
        // TC1: 15 + 10 = 25
        #10; A = 10'd15;   B = 10'd10;   mode = 0;
        // TC2: 0 + 42 = 42
        #10; A = 10'd0;    B = 10'd42;   mode = 0;
        // TC3: -20 + 50 = 30
        #10; A = -10'd20;  B = 10'd50;   mode = 0;
        // TC4: -10 + -15 = -25
        #10; A = -10'd10;  B = -10'd15;  mode = 0;
        // TC5: 127 + 1 = overflow
        #10; A = 10'sd127; B = 10'sd1;   mode = 0; // sd = signed decimal

        //  SUBTRACTION 
        // TC6: 30 - 10 = 20
        #10; A = 10'd30;   B = 10'd10;   mode = 1;
        // TC7: 55 - 55 = 0
        #10; A = 10'd55;   B = 10'd55;   mode = 1;
        // TC8: 5 - 20 = -15
        #10; A = 10'd5;    B = 10'd20;   mode = 1;
        // TC9: (-10) - (-30) = 20
        #10; A = -10'd10;  B = -10'd30;  mode = 1;
        // TC10: 127 - -1 = overflow
        #10; A = 10'sd127; B = -10'sd1;  mode = 1; // sd = signed decimal
        
        
        // DIVISION 
        #10; A = 10'sd40;  B = 10'sd5;   mode = 2'b10; // 40 / 5 = 8
        #10; A = -10'sd30; B = 10'sd3;   mode = 2'b10; // -10
        #10; A = 10'sd25;  B = -10'sd5;  mode = 2'b10; // -5
        #10; A = 10'sd10;  B = 10'sd0;   mode = 2'b10; // div by zero


        #10; $finish;
    end

endmodule
