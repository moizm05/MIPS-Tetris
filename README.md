# MIPS-Tetris
<p align="center">
> A classic Tetris game built from the ground up in MIPS assembly language.
</p>

<p align="center">
<img src="https://drive.google.com/file/d/1610KeimnKXO1LVLooCVedXcXtU2YsgNa/view?usp=sharing" alt="Project Demo">
</p>

This project is a complete implementation of the classic puzzle game Tetris, written entirely in MIPS assembly. It was developed to run on any MIPS Assembly Simulator. The game interacts directly with memory-mapped I/O (MMIO) to render graphics to a bitmap display and receive user input from a simulated keyboard, demonstrating low-level hardware control and game logic programming.

📋 Table of Contents
✨ Features

⚙️ How It Works

🚀 Getting Started

Prerequisites

Running the Game

🎮 Controls

🙏 Acknowledgements

✨ Features
Full Tetris Gameplay: All seven classic tetromino shapes (I, O, T, S, Z, J, L) are implemented.

Player Controls: Move pieces left, right, down, and rotate them.

Collision Detection: Pieces correctly collide with the walls and other placed blocks.

Line Clearing: Completed horizontal lines are detected and cleared.

Increasing Difficulty: The game speed (gravity) increases as lines are cleared.

Random Piece Generation: Tetrominoes are generated randomly for unpredictable gameplay.

Game Over State: The game ends when blocks stack to the top of the playfield.

Restart Functionality: Players can restart the game from the "Game Over" screen.

⚙️ How It Works
The entire game logic is contained within a single MIPS assembly file (tetris.asm).

Game Board: The 10x20 playfield is represented as a 1D array in memory (GameBoard). Each cell stores a color value, with 0 representing an empty cell.

Tetromino Data: The shapes and their four rotation states are stored in a large data structure (TetrominoShapes). This allows for efficient lookup of a piece's block coordinates for any given rotation.

Rendering: The game renders graphics by writing color values directly to the memory-mapped Bitmap Display. The main background, the placed blocks, and the currently falling piece are redrawn in each frame.

Input Handling: The program continuously polls the memory-mapped keyboard address to check for key presses, making the game responsive to user input.

Game Loop: The core game_loop is responsible for:

Checking for and processing user input.

Applying gravity to the current piece.

Checking for collisions and placing the piece if necessary.

Scanning for and clearing completed lines.

Redrawing the entire display.

Looping with a small delay to control the frame rate.

🚀 Getting Started
To run this game, you will need the MARS, Saturn, or any MIPS Assembler.

Running the Game
Launch MIPS Assembler.

Go to File > Open and select the tetris.asm file.

Connect the necessary tools:

In the Tools menu, select Bitmap Display.

In the Tools menu, select Keyboard and Display MMIO Simulator.

Configure the Bitmap Display:

Set Unit Width to 8.

Set Unit Height to 8.

Set Display Width to 256.

Set Display Height to 512.

Set the Base Address to 0x10008000 ($gp).

Click the Connect to MIPS button.

Connect the Keyboard Simulator:

Simply click the Connect to MIPS button in the Keyboard Simulator window.

🎮 Controls
Use the following keys to play the game.

Key

Action

A

Move Piece Left

D

Move Piece Right

S

Move Piece Down

W

Rotate Piece

Q

Quit the Game

R

Restart (on Game Over screen)
