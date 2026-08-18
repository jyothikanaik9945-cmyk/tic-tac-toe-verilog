module tb_player_win;

    // ================= INPUTS =================
    reg clock;
    reg reset;
    reg play;
    reg pc;
    reg [3:0] player_position;
    reg [3:0] computer_position;

    // ================= OUTPUTS =================
    wire [1:0] pos1,pos2,pos3;
    wire [1:0] pos4,pos5,pos6;
    wire [1:0] pos7,pos8,pos9;
    wire [1:0] who;

    // ================= DUT =================
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

    // ================= CLOCK =================
    initial begin
        clock = 0;
        forever #5 clock = ~clock;   // 10 time-unit period
    end

    // ================= STIMULUS =================
    initial begin
        $dumpfile("player_win.vcd");
        $dumpvars(0, tb_player_win);

        // initial values
        reset = 1;
        play  = 0;
        pc    = 0;
        player_position   = 0;
        computer_position = 0;

        // hold reset
        repeat (2) @(posedge clock);
        reset = 0;

        // -------- PLAYER WIN TEST (FSM-SAFE) --------

        // P -> 0
        @(posedge clock); play = 1; player_position = 0;
        @(posedge clock); play = 0;
        @(posedge clock);   // FSM settle

        // C -> 3
        @(posedge clock); pc = 1; computer_position = 3;
        @(posedge clock); pc = 0;
        @(posedge clock);

        // P -> 1
        @(posedge clock); play = 1; player_position = 1;
        @(posedge clock); play = 0;
        @(posedge clock);

        // C -> 4
        @(posedge clock); pc = 1; computer_position = 4;
        @(posedge clock); pc = 0;
        @(posedge clock);

        // P -> 2  (WIN HERE)
        @(posedge clock); play = 1; player_position = 2;
        @(posedge clock); play = 0;
        @(posedge clock);

        #50;
        $finish;
    end

endmodule
