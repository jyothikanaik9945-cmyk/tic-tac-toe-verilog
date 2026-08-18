module tb_draw_case;

    reg clock;
    reg reset;
    reg play;
    reg pc;
    reg [3:0] player_position;
    reg [3:0] computer_position;

    wire [1:0] pos1,pos2,pos3;
    wire [1:0] pos4,pos5,pos6;
    wire [1:0] pos7,pos8,pos9;
    wire [1:0] who;

    tic_tac_toe_game uut (
        .clock(clock),
        .reset(reset),
        .play(play),
        .pc(pc),
        .player_position(player_position),
        .computer_position(computer_position),
        .pos1(pos1), .pos2(pos2), .pos3(pos3),
        .pos4(pos4), .pos5(pos5), .pos6(pos6),
        .pos7(pos7), .pos8(pos8), .pos9(pos9),
        .who(who)
    );

    // clock
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end


// stimulus
initial begin
    $dumpfile("draw_case.vcd");
    $dumpvars(0, tb_draw_case);

    reset = 1;
    play = 0;
    pc = 0;
    player_position = 0;
    computer_position = 0;

    // reset
    repeat (2) @(posedge clock);
    reset = 0;

    // -------- DRAW TEST (FSM-SAFE) --------

    // -------- PLAYER 0 --------
    @(posedge clock); play = 1; player_position = 0;
    @(posedge clock); play = 0;
    @(posedge clock); // FSM settle

    // -------- COMPUTER 1 --------
    @(posedge clock); pc = 1; computer_position = 1;
    @(posedge clock); pc = 0;
    @(posedge clock);

    // -------- PLAYER 2 --------
    @(posedge clock); play = 1; player_position = 2;
    @(posedge clock); play = 0;
    @(posedge clock);

    // -------- COMPUTER 4 --------
    @(posedge clock); pc = 1; computer_position = 4;
    @(posedge clock); pc = 0;
    @(posedge clock);

    // -------- PLAYER 3 --------
    @(posedge clock); play = 1; player_position = 3;
    @(posedge clock); play = 0;
    @(posedge clock);

    // -------- COMPUTER 5 --------
    @(posedge clock); pc = 1; computer_position = 5;
    @(posedge clock); pc = 0;
    @(posedge clock);

    // -------- PLAYER 7 --------
    @(posedge clock); play = 1; player_position = 7;
    @(posedge clock); play = 0;
    @(posedge clock);

    // -------- COMPUTER 6 --------
    @(posedge clock); pc = 1; computer_position = 6;
    @(posedge clock); pc = 0;
    @(posedge clock);

    // -------- PLAYER 8 --------
    @(posedge clock); play = 1; player_position = 8;
    @(posedge clock); play = 0;
    @(posedge clock);    // this line ensures the FSM timing not ignoring it

    #50;
    $finish;
end

endmodule
