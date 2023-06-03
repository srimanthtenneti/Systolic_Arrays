// ************************************************************
// Design : Systolic Array 
// Date : Feb 28 2022 
// Author : Srimanth Tenneti 
// Description : Performs 2x2 Matrix Multiplication 
// Revision : 0.01
// Applications : Machine Learning, Deep Learning
// ************************************************************

// *********************************** Design *********************************************

// Array Processing Element 
module PE #(parameter W = 8)(
  input clk, 
  input rst, 
  input [W - 1 : 0] X, 
  input [W - 1 : 0] Y,
  output [2 * W : 0] Out, 
  output [W - 1 : 0] Xout, 
  output [W - 1 : 0] Yout
); 
  
  reg [2 * W : 0] O; 
  
  always @ (posedge clk or negedge rst)
    begin
      if (~rst)
        begin
           O <= 0; 
        end
      else 
        begin
           O <= O + X * Y; 
        end
    end
  
  assign Out = O; 
  assign Xout = X; 
  assign Yout = Y; 
  
endmodule

// 2x2 Systolic Array 
module Systolic_Array #(parameter W = 8)(
  
  input clk , 
  input rst , 
  
  input [W-1:0] a0, a1, b0, b1, 
  output [2*W:0] o1, o2, o3, o4
); 
  
  wire [W-1:0] a01, a23, b02, b13; 
  
  PE pe0 (clk, rst, a0, b0, o1, a01, b02); 
  PE pe1 (clk, rst, a01, b1, o2, , b13); 
  PE pe2 (clk, rst, a1, b02, o3, a23, ); 
  PE pe3 (clk, rst, a23, b13, o4, , ); 
  
endmodule

// *********************************** Test Bench *********************************************

// Matrix Multiplication Test 
module mattest #(parameter W = 8)(); 
  
  reg clk;
  reg rst; 
  reg [W-1:0] a0,a1,b0,b1; 
  wire [2*W:0] o1,o2,o3,o4; 
  
  initial 
    begin
       clk = 0; 
       rst = 0; 
       #10; 
       rst = 1; 
    end
  
  initial 
    begin
       forever #2 clk = ~clk; 
    end
  
  Systolic_Array sa0 (.*); 
  
  initial 
    begin
       #4 a0 = 1; b0 = 1 ; a1 = 0; b1 = 0; 
       #6 a0 = 1; b0 = 1 ; a1 = 1; b1 = 1; 
       #6 a0 = 0; b0 = 0 ; a1 = 1; b1 = 1; 
       #4 a0 = 0; b0 = 0 ; a1 = 0; b1 = 0; 
       #100; $finish;
    end
  
endmodule