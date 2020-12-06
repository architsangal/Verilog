`timescale 1ns/1ps

module FSM(out,inp,clk,reset);

    output out;
    input clk, reset, inp;
    reg [1:0] state,nextState,prevState; 
    //   prevState is used to check the output
    //   current state (here, state) is a combination of input and previous state
    //   we get our next state and we set that next state to state in that same posedge clk.
    
    reg out;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;

    always @(posedge clk, posedge reset)
    begin

        if(reset == 1'b 1)
    
        begin
            state <= S0;
            out <= 0;
        end
    
        else
    
        begin

            prevState = state;
            if(inp == 1'b0 && state == S0)
            begin
                nextState = S1;
                out<=0;
            end
            else if(inp == 1'b1 && state == S0)
            begin
                nextState = S2;
                out<=0;
            end
            else if(inp == 1'b0 && state == S1)
            begin
                nextState = S1;
                out<=0;
            end
            else if(inp == 1'b1 && state == S1)
            begin
                nextState = S2;
                out<=1;
            end
            else if(inp == 1'b0 && state == S2)
            begin
                nextState = S1;
                out<=1;
            end
            else if(inp == 1'b1 && state == S2)
            begin
                nextState = S2;
                out<=0;
            end

            state <= nextState;

        end

    end

endmodule 


module FSM_testbench;
    reg clk, reset, inp;
    wire out;

    FSM fsm(out, inp , clk, reset);

    initial
    begin

        
        clk = 0;
        reset = 0;
        inp = 0;

        $dumpfile ("FSM.vcd");
        $dumpvars(0,FSM_testbench);

        reset =1;
        #5  reset =0;   inp = 0;
        #10  inp = 0;
        #10  inp = 1;
        #10  inp = 1;
        #10  inp = 0;
        #10  reset = 1;
        #10  reset = 0; inp = 1;
        // only last input is considered as input before posedge clk
        #3   inp = 0;
        #3   inp = 1;
        #3   inp = 0;

    end


    always
        #5 clk=~clk;


    // so that we don't have to press Ctrl+Z :-)
    initial
        #80 $finish;


endmodule 
