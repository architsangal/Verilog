//This is a Johnson counter
//0, 1, 3, 7, F, E, C, 8, 0, repeat

// module dff(q,d,clk,reset); this order needs to be changed

module dff(q,d,reset,clk);

    output q;
    input d,clk,reset;
    reg q;

    always@(posedge clk or reset)
    begin
        if (reset==1)
            q=0;
        else
            q=d;
    end

endmodule



module counter(q,reset,clk);
    output [3:0]q;
    input clk,reset;
    
    // cannot be reg has to be wire
    // As reg cannot be driven by primitives or continuous assignment.

    // reg w;
    wire w;

    // in a module like this we don't need any initial block
    //initial
    //begin
    
	// not n1(q[3],w); this will not work as there is no input to w before it act as input to d flip flop

    not n1(w,q[3]);// not(output, input)  --> Syntax
    // Now, In a way we have initialised w as q[3]' and hence w can be used as an input
    
    dff f1(q[0],w,reset,clk);
    dff f2(q[1],q[0],reset,clk);
    dff f3(q[2],q[1],reset,clk);
    dff f4(q[3],q[2],reset,clk);
    
    //end
endmodule

`timescale 10ns/1ps
module tb_johnson;
    // Inputs
    reg clock;
    reg r;
    // Outputs
    wire [3:0] Count_out;

    //in this following notation you have to pass the signals in the same order
    //as in the original module
    counter uut (Count_out,r,clock); // Hence correction was required


    //  alternately, the following notation means that clk in the module connects to clock in the testbench.
    //  reset connects to r, and q to Count_out.
    //  In this notation, you can pass signals in any order, as you are explicitly mentioning 
    //  the signal connections

    //  counter uut ( .clk(clock),  .reset(r),.q(Count_out) );


    initial
    begin


        // clk = 0; No variable clk is defined here..
        clock = 0;
        r=1;
        #50 r=0;  //    reset=1 never shows up on the waveform -- why?

        // I am assuming here, that the reset and r refer to same variable.
        // dumpvars is after the statements clock = 0; r=1; #50 r=0; therefore in waveform it is not there
        // if the code would have been like this, r=1 would have been there: -
        // $dumpfile ("counter.vcd"); 
        // $dumpvars(0,tb_johnson);
        // clock = 0;
        // r=1;
        // #50 r=0;

        $dumpfile ("counter.vcd"); 
        $dumpvars(0,tb_johnson);    // name of the test bench is tb_johnson and not counter_test

    end

    always
    // name of clock variable is clock here and not clk
        //#3 clk=~clk;
        #3 clock=~clock;


    initial #300 $finish;// recording will be taken roughly till 3000 ns

endmodule
