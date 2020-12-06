//if select line s=00101, out=a+b
//if s=00110, out= a-b;
//if s=01000, a*b
//01011 --> a/b


module alu (a,b,s,clk,out);
    input [39:0]a,b;
    input [4:0]s;
    input clk;
    // reg [39:0]c,d;    ---> no use
    output reg [39:0]out;   //    out should also be a register

    // reg i; ---> no use

    always @ (posedge clk)
    begin
        if (s==5'b00101)
            out = a+b;
        //begin     <---  this begin has no end and also for 1 statement we don't need begin-end
        else if (s==5'b01000)  //   what I concluded that 5'b01000 == 5'b1000
            out= a*b;
        else if (s==5'b00110)
            out = a-b;
        else if (s==5'b01011)
            out = a/b;
    end
endmodule


`timescale 1ns/1ps
module alu_test;

    reg [39:0]a,b;
    reg clk;
    reg [4:0]select;
    wire [39:0]out; // out is a bus therefore it must have [39:0]

    // alu uut (a,b,out,select);    --->   order is very important
    // alu uut (a,b,select, out);   --->   clock also has to be passed
    alu uut (a, b, select, clk, out);

    initial
    begin
        $dumpfile("alua.vcd");
        $dumpvars(0, alu_test);
        a= 40'h000000000b;
        b= 40'h0000000003;
        clk=0;
        // here there is no s, but an equivalent variable of s(of module alu) is select
        select= 5'b00101;
    end

    always
    begin
        #3 clk=~clk;
    end

    always
    begin


        //  replace s with select as explained earlier
        select = 5'b00111;// this is considered as a corner case...
        #10 select = 5'b00110;
        #10 select = 5'b01000;
        #10 select = 5'b01011;

    end

endmodule