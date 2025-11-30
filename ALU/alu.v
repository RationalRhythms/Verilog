// Multiplexer module
module mux(output reg [15:0] out, input [15:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, input [3:0] sel);
  always @(*)
  begin  
    case (sel)  
      4'b0000: out = in0;
      4'b0001: out = in1;
      4'b0010: out = in2;
      4'b0011: out = in3;
      4'b0100: out = in4;
      4'b0101: out = in5;
      4'b0110: out = in6;
      4'b0111: out = in7;
      4'b1000: out = in8;
      4'b1001: out = in9;
      4'b1010: out = in10;
      4'b1011: out = in11;
      4'b1100: out = in12;
      4'b1101: out = in13;
      4'b1110: out = in14;
      4'b1111: out = in15;
      default: out = 8'bXXXXXXXX;
    endcase
  end
endmodule

module addition(
  output reg [15:0] result,
  input [15:0] a, b,
  input operation,  // 0: Add, 1: Subtract
  output reg Carry
);
  reg [16:0] full_sum;  // 17 bits to capture carry/borrow

  always @(*) begin
    if (operation == 0) begin
      // Addition
      full_sum = a + b;
      Carry = full_sum[16];  // Carry indicates overflow in addition
    end else begin
      // Subtraction (a - b)
      full_sum = {1'b0, a} + {1'b0, ~b} + 1'b1;  // a + (~b + 1)
      Carry = ~full_sum[16];  // Borrow occurred if Carry is 1
      full_sum= (Carry == 0)?full_sum:(~full_sum+1);

    end
    result = full_sum[15:0];  // Lower 16 bits as result
  end
endmodule



module multiplication(output [15:0] result, input [15:0] a, b);
assign result = a * b;
endmodule

module division(output [15:0] result, input [15:0] a, b);
assign result = a / b;
endmodule

module logical_and(output [15:0] result, input [15:0] a, b);
assign result = a && b;
endmodule

module logical_or(output [15:0] result, input [15:0] a, b);
assign result = a || b;
endmodule

module logical_not(output [15:0] result, input [15:0] a);
assign result = !a;
endmodule

module bitwise_and(output [15:0] result, input [15:0] a, b);
assign result = a & b;
endmodule

module bitwise_or(output [15:0] result, input [15:0] a, b);
assign result = a | b;
endmodule

module bitwise_xor(output [15:0] result, input [15:0] a, b);
assign result = a ^ b;
endmodule

module bitwise_not(output [15:0] result, input [15:0] a);
assign result = ~a;
endmodule

module right_shift(output [15:0] result, input [15:0] a);
assign result = a >> 1;
endmodule

module left_shift(output [15:0] result, input [15:0] a);
assign result = a << 1;
endmodule

module flags(
    output Sign, Zero, Parity, Overflow, 
    input [3:0] opcode, 
    input [15:0] a, b, Carry_in,op, output reg Carry_fin
);
  assign Sign = op[15]; 
  assign Zero = ~|op; 
  assign Parity = ~^op; 
  assign Overflow = (a[15] & b[15] & ~op[15]) | (~a[15] & ~b[15] & op[15]);
   always @(*) begin
    if (opcode == 4'b0000) begin
      Carry_fin=Carry_in[0]; // Addition
    end else if (opcode == 4'b0001) begin
      Carry_fin=Carry_in[1]; // Subtraction
    end else if (opcode == 4'b1110) begin
      Carry_fin=Carry_in[2]; // Inc
    end else if (opcode == 4'b1111) begin
       Carry_fin=Carry_in[3];// Dec
    end else begin
       Carry_fin= 1'b0; // Default result value
    end
  end

endmodule




module alu(output [15:0] op, 
           output Sign, Zero, Parity, Overflow, Carry_fin,
           input [15:0] a, b, 
           input [3:0] opcode);
  
  wire [15:0] add_result, sub_result, mul_result, div_result;
  wire [15:0] and_result, or_result, not_result;
  wire [15:0] bw_and_result, bw_or_result, bw_xor_result, bw_not_result;
  wire [15:0] rs_result, ls_result, inc_result, dec_result;
  
  wire [15:0] Carry;

  // Perform operations
  addition add(.result(add_result), .a(a), .b(b),.Carry(Carry[0]),.operation(1'b0));
  addition sub(.result(sub_result), .a(a), .b(b),.Carry(Carry[1]),.operation(1'b1));
  addition inc(.result(inc_result), .a(a),.b(16'h01),.Carry(Carry[2]),.operation(1'b0));
  addition dec(.result(dec_result), .a(a),.b(16'h01),.Carry(Carry[3]),.operation(1'b1));
  multiplication mul(.result(mul_result), .a(a), .b(b));
  division div(.result(div_result), .a(a), .b(b));

  logical_and land(.result(and_result), .a(a), .b(b));
  logical_or lor(.result(or_result), .a(a), .b(b));
  logical_not lnot(.result(not_result), .a(a));

  bitwise_and bwand(.result(bw_and_result), .a(a), .b(b));
  bitwise_or bwor(.result(bw_or_result), .a(a), .b(b));
  bitwise_xor bwxor(.result(bw_xor_result), .a(a), .b(b));
  bitwise_not bwnot(.result(bw_not_result), .a(a));

  right_shift rs(.result(rs_result), .a(a));
  left_shift ls(.result(ls_result), .a(a));

  // Multiplexer to select output
  mux result_mux(
    .out(op),
    .in0(add_result),
    .in1(sub_result),
    .in2(mul_result),
    .in3(div_result),
    .in4(16'b0),  // Placeholder for unused inputs
    .in5(bw_and_result),
    .in6(bw_or_result),
    .in7(and_result),
    .in8(or_result),
    .in9(bw_xor_result),
    .in10(bw_not_result),
    .in11(not_result),
    .in12(rs_result),
    .in13(ls_result),
    .in14(inc_result),
    .in15(dec_result),
    .sel(opcode)
  );

  // Flag logic
 flags flag_unit(.Carry_in(Carry),.Sign(Sign), .Zero(Zero), .Parity(Parity), .Overflow(Overflow), .op(op), .a(a), .b(b),.opcode(opcode),.Carry_fin(Carry_fin));

endmodule

