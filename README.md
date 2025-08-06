# MIPS-Tetris 🎮

A classic Tetris game built from the ground up in MIPS assembly language.

This project is a complete implementation of the classic puzzle game Tetris, written entirely in MIPS assembly. It was developed to run on any MIPS Assembly Simulator (e.g. MARS or Saturn). The game interacts directly with memory-mapped I/O (MMIO) to render graphics to a bitmap display and receive user input from a simulated keyboard, demonstrating low-level hardware control and game logic programming.

---

## 🖼️ Screenshots

### Gameplay
![Gameplay Screenshot](https://github.com/user-attachments/assets/c3deb866-f46a-4699-a430-faf31419d09a)

### Game Over Screen
![Game Over](<img width="440" height="853" alt="image" src="https://github.com/user-attachments/assets/f69644d4-eb37-48c0-831e-fd0828caa930" />
)

---

## ✨ Features

- **Full Tetris Gameplay**: All seven classic tetromino shapes (I, O, T, S, Z, J, L) are implemented.
- **Player Controls**: Move pieces left, right, down, and rotate them.
- **Collision Detection**: Pieces correctly collide with walls and placed blocks.
- **Line Clearing**: Automatically detects and clears full horizontal lines.
- **Increasing Difficulty**: The fall speed increases as more lines are cleared.
- **Random Piece Generation**: Unpredictable gameplay with randomized tetromino spawning.
- **Game Over State**: Ends the game when the stack reaches the top.
- **Restart Functionality**: Restart the game from the "Game Over" screen.

---

## ⚙️ How It Works

- **Game Logic**: Entirely contained in a single file: `tetris.asm`
- **Board Representation**: A 10x20 grid stored as a 1D array in memory
- **Tetromino Storage**: All shapes and their 4 rotations are precomputed in memory
- **Rendering**: Drawn directly to the memory-mapped Bitmap Display using color values
- **User Input**: Polled in real time from the MMIO Keyboard Simulator
- **Game Loop**:
  - Reads user input
  - Applies gravity
  - Handles collisions
  - Places tetrominoes
  - Clears lines
  - Updates the display
  - Delays slightly to control the frame rate

---

## 🚀 Getting Started

### Requirements

- A MIPS simulator such as:
  - [MARS](https://computerscience.missouristate.edu/mars-mips-simulator.htm)
  - [Saturn](https://github.com/1whatleytay/saturn)

### Running the Game

1. Open your MIPS Assembler (e.g. MARS).
2. Load the `tetris.asm` file.
3. From the **Tools** menu, open:
   - **Bitmap Display**
   - **Keyboard and Display MMIO Simulator**

#### Bitmap Display Settings:

| Setting         | Value        |
|-----------------|--------------|
| Unit Width      | 8            |
| Unit Height     | 8            |
| Display Width   | 256          |
| Display Height  | 512          |
| Base Address    | 0x10008000   |

> Make sure to click **"Connect to MIPS"** after configuring the Bitmap Display.

#### Keyboard Simulator:

- Just click **"Connect to MIPS"**

---

## 🎮 Controls

| Key | Action             |
|-----|--------------------|
| A   | Move Left          |
| D   | Move Right         |
| S   | Move Down          |
| W   | Rotate Piece       |
| Q   | Quit Game          |
| R   | Restart (Game Over)|

---

## 📽️ Demo

[🎥 Watch the Demo](https://drive.google.com/file/d/1610KeimnKXO1LVLooCVedXcXtU2YsgNa/view?usp=sharing)

---

## 🧠 Learning Outcomes

- Assembly-level game development
- Memory-mapped I/O (MMIO) control
- Efficient rendering and polling in MIPS
- Structuring real-time loops in a low-level language
