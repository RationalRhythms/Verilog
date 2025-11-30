`timescale 1ns / 1ps
`include "alu.v"
module alu_tb;
  // Inputs
  reg [15:0] a, b;
  reg [3:0] opcode;
  // Outputs
  wire [15:0] op;
  wire Sign, Zero, Parity, Overflow, Carry_fin;
  wire [15:0] Carry;

  // Instantiate the ALU module
  alu uut (
    .op(op),
    .Sign(Sign),
    .Zero(Zero),
    .Parity(Parity),
    .Overflow(Overflow),
    .Carry_fin(Carry_fin),
    .Carry(Carry),
    .a(a),
    .b(b),
    .opcode(opcode)
  );

  // Test vector procedure
  initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);
    // Initialize inputs
    a = 16'h0000;
    b = 16'h0000;
    opcode = 4'b0000;  // Addition opcode

    // Apply Test Cases
    $display("Testing ALU Operations...\n");

    // Test: Addition (opcode 0000)
    a = 16'hffff;
    b = 16'h0003;
    opcode = 4'b0000;
    #10;
    $display("Addition: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Subtraction (opcode 0001)
    a = 16'h0003;
    b = 16'h0005;  // Smaller to greater
    opcode = 4'b0001;
    #10;
    $display("Subtraction: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Multiplication (opcode 0010)
    a = 16'h0004;
    b = 16'h0003;
    opcode = 4'b0010;
    #10;
    $display("Multiplication: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Division (opcode 0011)
    a = 16'h0010;
    b = 16'h0002;
    opcode = 4'b0011;
    #10;
    $display("Division: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Bitwise AND (opcode 0100)
    a = 16'hF0F0;
    b = 16'h0F0F;
    opcode = 4'b0101;
    #10;
    $display("Bitwise AND: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Bitwise OR (opcode 0101)
    a = 16'hF0F0;
    b = 16'h0F0F;
    opcode = 4'b0110;
    #10;
    $display("Bitwise OR: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Bitwise XOR (opcode 0110)
    a = 16'hF0F0;
    b = 16'h0F0F;
    opcode = 4'b1001;
    #10;
    $display("Bitwise XOR: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Bitwise NOT (opcode 0111)
    a = 16'h0F0F;
    opcode = 4'b1010;
    #10;
    $display("Bitwise NOT: a = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Logical AND (opcode 1000)
    a = 16'h0001;
    b = 16'h0001;
    opcode = 4'b0111;
    #10;
    $display("Logical AND: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Logical OR (opcode 1001)
    a = 16'h0001;
    b = 16'h0000;
    opcode = 4'b1000;
    #10;
    $display("Logical OR: a = %h, b = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, b, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Logical NOT (opcode 1010)
    a = 16'h0000;
    opcode = 4'b1011;
    #10;
    $display("Logical NOT: a = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Right Shift (opcode 1011)
    a = 16'h8000;
    opcode = 4'b1100;
    #10;
    $display("Right Shift: a = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Left Shift (opcode 1100)
    a = 16'h4000;
    opcode = 4'b1101;
    #10;
    $display("Left Shift: a = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Increment (opcode 1110)
    a = 16'h0001;
    opcode = 4'b1110;
    #10;
    $display("Increment: a = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // Test: Decrement (opcode 1111)
    a = 16'h0001;
    opcode = 4'b1111;
    #10;
    $display("Decrement: a = %h, result = %h, Flags = {Sign=%b, Zero=%b, Parity=%b, Overflow=%b, Carry_fin=%b}", a, op, Sign, Zero, Parity, Overflow, Carry_fin);

    // End of tests
    $finish;
  end

endmodule
