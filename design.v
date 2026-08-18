module tic_tac_toe_game(
    input clock,
    input reset,
    input play,
    input pc,
    input [3:0] computer_position,
    input [3:0] player_position,
    output [1:0] pos1,pos2,pos3,
    output [1:0] pos4,pos5,pos6,
    output [1:0] pos7,pos8,pos9,
    output [1:0] who
);

wire [15:0] PC_en, PL_en;
wire illegal_move;
wire win;
wire computer_play;
wire player_play;
wire no_space;

// ================= POSITION REGISTERS =================
position_registers pos_regs(
    clock, reset, illegal_move,
    PC_en[8:0], PL_en[8:0],
    pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9
);

// ================= DECODERS =================
position_decoder pd_player(
    player_position,
    player_play,
    PL_en
);

position_decoder pd_computer(
    computer_position,
    computer_play,
    PC_en
);

// ================= FSM =================
fsm_controller fsm(
    clock,
    reset,
    play,
    pc,
    illegal_move,
    no_space,
    win,
    computer_play,
    player_play
);

// ================= ILLEGAL MOVE =================
illegal_move_detector imd(
    pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
    PC_en[8:0], PL_en[8:0],
    illegal_move
);

// ================= NO SPACE =================
nospace_detector nsd(
    pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
    no_space
);

// ================= WINNER =================
winner_detector wd(
    pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
    win,
    who
);

endmodule

module fsm_controller(
    input clock,
    input reset,
    input play,
    input pc,
    input illegal_move,
    input no_space,
    input win,
    output reg computer_play,
    output reg player_play
);

parameter IDLE = 2'b00,
          PLAYER = 2'b01,
          COMPUTER = 2'b10,
          DONE = 2'b11;

reg [1:0] current_state, next_state;

// STATE REGISTER
always @(posedge clock or posedge reset) begin
    if (reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// NEXT STATE LOGIC
always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE:
            if (play)
                next_state = PLAYER;

        PLAYER:
            if (!illegal_move)
                next_state = COMPUTER;
            else
                next_state = IDLE;

        COMPUTER:
            if (win || no_space)
                next_state = DONE;
            else if (pc)
                next_state = IDLE;

        DONE:
            if (reset)
                next_state = IDLE;
    endcase
end

// OUTPUT REGISTER (THIS IS THE KEY FIX)
always @(posedge clock or posedge reset) begin
    if (reset) begin
        player_play <= 0;
        computer_play <= 0;
    end else begin
        player_play <= (current_state == PLAYER);
        computer_play <= (current_state == COMPUTER && pc);
    end
end

endmodule

module position_decoder(
    input [3:0] in,
    input enable,
    output reg [15:0] out_en
);

always @(*) begin
    out_en = 16'd0;
    if (enable) begin
        case (in)
            4'd0: out_en = 16'b0000000000000001;
            4'd1: out_en = 16'b0000000000000010;
            4'd2: out_en = 16'b0000000000000100;
            4'd3: out_en = 16'b0000000000001000;
            4'd4: out_en = 16'b0000000000010000;
            4'd5: out_en = 16'b0000000000100000;
            4'd6: out_en = 16'b0000000001000000;
            4'd7: out_en = 16'b0000000010000000;
            4'd8: out_en = 16'b0000000100000000;
            default: out_en = 16'd0;
        endcase
    end
end

endmodule

//position registers
module position_registers(
    input clock,
    input reset,
    input illegal_move,
    input [8:0] PC_en,
    input [8:0] PL_en,
    output reg [1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9
);

always @(posedge clock or posedge reset) begin
    if (reset) begin
        pos1<=0; pos2<=0; pos3<=0;
        pos4<=0; pos5<=0; pos6<=0;
        pos7<=0; pos8<=0; pos9<=0;
    end else if (!illegal_move) begin
        if (PC_en[0]) pos1<=2'b10; else if (PL_en[0]) pos1<=2'b01;
        if (PC_en[1]) pos2<=2'b10; else if (PL_en[1]) pos2<=2'b01;
        if (PC_en[2]) pos3<=2'b10; else if (PL_en[2]) pos3<=2'b01;
        if (PC_en[3]) pos4<=2'b10; else if (PL_en[3]) pos4<=2'b01;
        if (PC_en[4]) pos5<=2'b10; else if (PL_en[4]) pos5<=2'b01;
        if (PC_en[5]) pos6<=2'b10; else if (PL_en[5]) pos6<=2'b01;
        if (PC_en[6]) pos7<=2'b10; else if (PL_en[6]) pos7<=2'b01;
        if (PC_en[7]) pos8<=2'b10; else if (PL_en[7]) pos8<=2'b01;
        if (PC_en[8]) pos9<=2'b10; else if (PL_en[8]) pos9<=2'b01;
    end
end
endmodule

//fsm Controller

//postion decoder

//illegal_move_detector
module illegal_move_detector(
    input [1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
    input [8:0] PC_en, PL_en,
    output illegal_move
);
assign illegal_move =
    ((pos1!=0)&(PC_en[0]|PL_en[0])) |
    ((pos2!=0)&(PC_en[1]|PL_en[1])) |
    ((pos3!=0)&(PC_en[2]|PL_en[2])) |
    ((pos4!=0)&(PC_en[3]|PL_en[3])) |
    ((pos5!=0)&(PC_en[4]|PL_en[4])) |
    ((pos6!=0)&(PC_en[5]|PL_en[5])) |
    ((pos7!=0)&(PC_en[6]|PL_en[6])) |
    ((pos8!=0)&(PC_en[7]|PL_en[7])) |
    ((pos9!=0)&(PC_en[8]|PL_en[8]));
endmodule

//
module nospace_detector(
    input [1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
    output no_space
);
assign no_space =
    pos1&&pos2&&pos3&&pos4&&pos5&&pos6&&pos7&&pos8&&pos9;
endmodule

//
module winner_detect_3(
    input [1:0] a,b,c,
    output win,
    output [1:0] who
);
assign win = (a==b)&&(b==c)&&(a!=0);
assign who = win ? a : 2'b00;
endmodule

//

module winner_detector(
    input [1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
    output winner,
    output [1:0] who
);

wire w1,w2,w3,w4,w5,w6,w7,w8;
wire [1:0] h1,h2,h3,h4,h5,h6,h7,h8;

winner_detect_3 u1(pos1,pos2,pos3,w1,h1);
winner_detect_3 u2(pos4,pos5,pos6,w2,h2);
winner_detect_3 u3(pos7,pos8,pos9,w3,h3);
winner_detect_3 u4(pos1,pos4,pos7,w4,h4);
winner_detect_3 u5(pos2,pos5,pos8,w5,h5);
winner_detect_3 u6(pos3,pos6,pos9,w6,h6);
winner_detect_3 u7(pos1,pos5,pos9,w7,h7);
winner_detect_3 u8(pos3,pos5,pos7,w8,h8);

assign winner = w1 | w2 | w3 | w4 | w5 | w6 | w7 | w8;
assign who    = h1 | h2 | h3 | h4 | h5 | h6 | h7 | h8;

endmodule
