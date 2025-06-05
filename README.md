# Tic Tac Toe (Verilog)

This project implements the game logic of Tic Tac Toe in Verilog, featuring a modular hardware design and an automated testbench. The system tracks player moves, determines the game state (ongoing, win, draw), and outputs the current board for simulation.

---

## Overview

- **Core Modules**
  - `TCell`: Represents a single cell on the board.
  - `TBox`: Manages the 3x3 board, processes moves, tracks game state, and checks for win/draw conditions.
  - `row_col_decoder`: Decodes row/column inputs to one-hot cell selection.
- **Testbench**
  - `TicTacToe_tb.v`: Simulates gameplay, applies moves, and verifies outcomes with assertions and visual board output.

---

## File Structure

- `TicTacToe.v`: Main Verilog source file containing the core logic modules (`TCell`, `TBox`, `row_col_decoder`).
- `TicTacToe_tb.v`: Testbench for simulating and verifying the Tic Tac Toe design.
- `README.md`: (This file) Project overview and usage instructions.

---

## How It Works

### Game Logic

- Players alternate making moves by specifying a row and column.
- The board is a 3x3 grid, each cell represented by a `TCell` module.
- The `TBox` module manages all cells, decides whose turn it is, checks for wins/draws, and outputs the current game state:
  - `2'b00`: Game ongoing
  - `2'b01`: Player X wins
  - `2'b10`: Player O wins
  - `2'b11`: Draw

### Simulation/Testbench

- The testbench (`TicTacToe_tb.v`) automates a series of moves to test different scenarios:
  - Normal gameplay
  - X or O winning
  - Draws
  - Board resets
- The current board is printed after each move for easy visualization.
- Assertions are included to catch incorrect states.

---

## How to Run

1. **Clone the repository:**

   ```bash
   git clone https://github.com/tsand1602/TicTacToe.git
   cd TicTacToe
   ```

2. **Compile the design and testbench** (using Icarus Verilog as an example):

   ```bash
   iverilog -o tictactoe_sim TicTacToe.v TicTacToe_tb.v
   ```

3. **Run the simulation:**

   ```bash
   vvp tictactoe_sim
   ```

4. **View Output:**
   - The simulation will print the board state after each move and report pass/failure for each test scenario.

---

## How to Change the Game Inputs (Customize Moves)

**To play a different game, set up your own test cases, or experiment with move sequences, you need to edit the move macros in the testbench file: [`TicTacToe_tb.v`](https://github.com/tsand1602/TicTacToe/blob/main/TicTacToe_tb.v).**

### Where to Change Inputs

- The moves are specified with the macro `PLAYMOVE(row, col)`, where `row` and `col` are 2-bit binary values:
  - Row: `01` (row 1), `10` (row 2), `11` (row 3)
  - Col: `01` (col 1), `10` (col 2), `11` (col 3)
- Example in `TicTacToe_tb.v`:
  ```verilog
  `PLAYMOVE(01,01) // X plays at row 1, col 1
  `PLAYMOVE(10,10) // O plays at row 2, col 2
  // ... etc.
  ```
- **To test a custom sequence of moves or different board scenarios, simply edit, add, or remove these macro calls in `TicTacToe_tb.v`.**
- The alternation between X and O is handled automatically by the hardware logic; you do not need to specify which player is making the move.

### Example Modification

To make your own game:
```verilog
`PLAYMOVE(01,01) // First move
`PLAYMOVE(01,10) // Second move
`PLAYMOVE(10,10) // Third move
// ... add more moves as desired
```

To reset the board between games, use the macro:
```verilog
`RESETBOARD
```

---

## Module Descriptions

### TCell

- Represents a single cell.
- Handles setting/resetting the cell and storing the player symbol (X or O).
- Outputs whether the cell is valid (occupied) and the symbol.

### TBox

- Contains 9 `TCell` instances for the board.
- Controls move application, alternates players, tracks filled cells.
- Determines the game state: ongoing, X wins, O wins, or draw.

### row_col_decoder

- Converts 2-bit row and column inputs into a one-hot vector for cell selection.

### Testbench Macros

- `PRINTCELL` / `PRINTBOARD`: Helper macros for board visualization.
- `PLAYMOVE`, `RESETBOARD`: Automate moves and resets in the testbench.

---

## Customization

- You can modify the test scenarios in `TicTacToe_tb.v` to test additional gameplay paths or edge cases.
- The design is modular and can be expanded for larger boards or additional features.

---

**Summary:**  
To play or test different games, simply edit the move macros (`PLAYMOVE`) in the `TicTacToe_tb.v` file. All game input is provided there for simulation.
