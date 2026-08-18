Tic-Tac-Toe Game in Verilog (FSM-Based)

## 1.Overview:

This project implements a fully synchronous "Tic-Tac-Toe game" using "Verilog HDL". The design follows an **FSM-based architecture** to control player and computer turns, validate moves, detect draw conditions, and identify winners. The entire design is verified using **GTKWave** with clock-accurate testbenches.

---
## 2.Features:

* FSM-controlled gameplay (Player ↔ Computer turns)
* Illegal move detection (prevents overwriting occupied cells)
* Draw detection using no-space logic
* Winner identification with player indication
* Fully synchronous, clock-driven design
* Verified using GTKWave waveform analysis

---

## 3.Architecture Summary

* "FSM Controller"
  Manages game flow using states: IDLE, PLAYER, COMPUTER, DONE

* "Position Registers"
  Stores board state (`pos1` to `pos9`)

  * `01` → Player move
  * `10` → Computer move
  * `00` → Empty

* "Decoders"
  Convert position inputs into one-hot enable signals

* "Illegal Move Detector"
  Blocks moves on already occupied positions

* "Winner Detector"
  Checks all rows, columns, and diagonals

* "No-Space Detector"
  Detects draw condition when board is full

---

## 4. Verification

The design is verified using multiple testbenches:

* Player win scenario
* Draw (no-space) scenario
* Illegal move handling

All simulations are visualized using **GTKWave**, confirming correct FSM behavior, timing, and outputs (`win`, `who`, `no_space`).

---

## 5.How to Run:
```bash
*iverilog -g2012 -o out.vvp tic_tac_toe_game.v tb_player_win.v
*vvp out.vvp
*gtkwave player_win.vcd
*Note:
 *To observe normal Play and illegal Play -- Replace testbench with "tb_normal_illegal_movecase.v"
 *To observe drawcase.v  -- Replace testbench with "tb_drawcase.v"
```


---

## 6. Tools Used:

* Verilog HDL
* Icarus Verilog (iverilog)
* GTKWave

---

## 7. Learning Outcomes:

* FSM-based digital system design
* Synchronous RTL coding practices
* Hardware verification using waveforms
* Modular Verilog design methodology

---

## 8. Notes:

This project focuses on **RTL correctness and verification**, making it suitable for academic evaluation, interviews, and digital design practice.

---


