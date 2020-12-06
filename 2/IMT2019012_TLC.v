`timescale 1ns/1ps

// This is a modified Traffic Light controller
module TLC(LaG,LaY,LaR,LbG,LbY,LbR,Ta,Tb,clk,reset);

    output reg LaG,LaY,LaR,LbG,LbY,LbR;
    input Ta,Tb,clk,reset;
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;

    reg [2:0] currState,nextState;
    reg out;

    always @(posedge clk, posedge reset)
    begin

        if(reset == 1'b 1)
    
        begin
            currState <= S0;
            LaG<=1;
            LaY<=0;
            LaR<=0;
            LbG<=0;
            LbY<=0;
            LbR<=1;
        end
    
        else    
            currState <= nextState;
    end

    always @(currState)
    begin
        if(currState == S0)
        begin
            LaG <= 1;
            LbR <= 1;
            LaR <= 0;
            LbY <= 0;
        end
        else if(currState == S1)
        begin
            LaG <= 0;
            LaY <= 1;
        end
//      else if(currState == S2)  ==> No need to do anything for S2 as it will come only after S1 and needs no change
        else if(currState == S3)
        begin
            LaR <= 1;
            LbR <= 0;
            LaY <= 0;
            LbG <= 1;
        end
        else if(currState == S4)
        begin
            LbG <= 0;
            LbY <= 1;
        end
//      else if(currState == S5)  ==> No need to do anything for S5 as it will come only after S4 and needs no change
    end

    always @(Ta,Tb,currState)
    begin
        if(currState == S0 && Ta == 1)
            nextState <= S0;
        else if(currState == S0 && Ta == 0)
            nextState <= S1;
        else if(currState == S1)
            nextState <= S2;
        else if(currState == S2)
            nextState <= S3;
        else if(currState == S3 && Tb ==1)
            nextState <= S3;
        else if(currState == S3 && Tb ==0)
            nextState <= S4;
        else if(currState == S4)
            nextState <= S5;
        else if(currState == S5)
            nextState <= S0;
    end

endmodule 

// This is a modified Traffic Light controller
module TLC_testbench;
    reg clk, reset, Ta, Tb;
    wire LaG,LaY,LaR,LbG,LbY,LbR;

    TLC tlc(LaG,LaY,LaR,LbG,LbY,LbR,Ta,Tb,clk,reset);

    initial
    begin
        clk = 0;
        reset = 0;
        Ta = 0;
        Tb = 0;

        $dumpfile ("TLC.vcd");
        $dumpvars(0,TLC_testbench);

        reset =1; Ta = 1;
        #3  reset =0;   Ta = 1;
        #10  Ta = 0;
        #10  
        #10  Ta = 1;
        #10  Tb = 1;
        #10  Tb = 0;
        #10  
        #10  
        #10  Ta = 0;
        #3  reset = 1;
        #7  reset = 0;

    end


    always
        #5 clk=~clk;

    // so that we don't have to press Ctrl+Z :-)
    initial
        #120 $finish;


endmodule 
