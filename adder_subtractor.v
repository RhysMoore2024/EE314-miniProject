// ============================================================
// Module  : adder_subtractor
// Purpose : 10-bit signed adder/subtractor
//           for FPGA calculator project (BASYS3 / NEXYS4)
//
// Ports
//   A        - First operand  (8-bit signed)
//   B        - Second operand (8-bit signed)
//   op_sel encoding:
//   00 -> Add
//   01 -> Subtract
//   10 -> Divide
//   11 -> Multiply
//   result   - 8-bit signed result
//   overflow - Signed overflow flag
//
// OVERFLOW EXPLANATION
// In 10-bit signed arithmetic the valid range is -1023 to +1023.
// If a result exceeds this range it wraps around to the opposite
// sign, which is physically incorrect. Overflow detects this by
// comparing the sign bits of the inputs and result (bit 9).
//
// It can only trigger when both inputs share the same sign:
//   - pos + pos = negative result  => overflow
//   - neg + neg = positive result  => overflow
// A positive and negative input can never overflow since the
// result always moves closer to zero.
//
// Example of why the overflow is needed:
// 900 + 200 = 1100  => exceeds +999, result wraps to a wrong negative number
// -900 + (-200) = -1100  => exceeds -999, result wraps to a wrong positive number
// ============================================================
// Author  : Rhys Moore,
// Date    : April 2026
// ============================================================

module adder_subtractor_divider (
    input  wire signed [9:0] A,
    input  wire signed [9:0] B,
    input  wire [1:0]        mode, // 00=ADD, 01=SUB, 10=DIV, 11=MLT
    output reg  signed [9:0] result,
    output reg               overflow,
    output reg               div_by_zero
);

    always @(*) 
    begin
        result      = 10'sd0;
        overflow    = 1'b0;
        div_by_zero = 1'b0;

    // ADDING MULTIPLICATION AND DIVISION
    // To extend this module or add alongside it, note the following:
    // Select the method with the mode variable, 
    // maybe change from if to case statements for Mult and Div? because we have no if-else statements?
    //   Multiplication:
    //   - 10-bit x 10-bit signed produces up to a 20-bit result.
    //     Decide whether to truncate back to 10-bit or
    //     widen the result bus across all modules before starting.
    //   - Overflow detection is simpler: just check if the upper
    //     10 bits of the 20-bit result are all zeros or all ones.
    //
    //   Division:
    //   - Replace the overflow flag with a div_by_zero flag since
    //     dividing by zero is the only error case to handle.
    //   - Integer division will drop the remainder, so consider
    //     whether a remainder output is needed for the display.
        
    //
    //   Both:
    //   - Keep input ports as signed [9:0] to stay consistent with
    //     this module, otherwise the top level mux will have type
    //     mismatches which can cause errors in Vivado.

        
    case (mode)

// ---------------- ADD ----------------
        2'b00:
        begin
            result   = A + B;
            // Overflow if two positives produce a negative, or two negatives produce a positive
            overflow = (~A[9] & ~B[9] & result[9]) | 
                       ( A[9] &  B[9] & ~result[9]); 
        end 
        
       
// ---------------- SUB ----------------
        2'b01:
        begin
            result   = A - B;
            // Overflow if positive minus negative gives negative, or negative minus positive gives positive
            overflow = (~A[9] &  B[9] & result[9]) | ( A[9] & ~B[9] & ~result[9]);
        end


// ---------------- DIV ----------------
            2'b10: begin
                if (B == 0) begin
                    result      = 10'sd0;
                    div_by_zero = 1'b1;
                end else begin
                    result = A / B;   // signed division
                end
            end

// -------------- DEFAULT --------------
            default: begin
                result = 10'sd0;
            end

        endcase
    end


endmodule
