#####################################################################
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed) 
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 512 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# How to play:
# 'w' to rotate
# 'a' to move left and 'd' to move right
# 's' to move down
# 'q' to quit
# 'r' to restart the game when on Game Over Screen
#
#####################################################################

##############################################################################

.data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
GameBoard:
    .space 800  # 10 * 20 * 4 bytes = 800 bytes

TetrominoShapes:
    # O Block - Type 0 (doesn't change with rotation)
    # Rotation 0: (0,0), (1,0), (0,1), (1,1)
    .word 0, 0, 1, 0, 0, 1, 1, 1
    # Rotation 1: same as 0
    .word 0, 0, 1, 0, 0, 1, 1, 1
    # Rotation 2: same as 0  
    .word 0, 0, 1, 0, 0, 1, 1, 1
    # Rotation 3: same as 0
    .word 0, 0, 1, 0, 0, 1, 1, 1
    
    # I Block - Type 1 (vertical/horizontal line)
    # Rotation 0: vertical (0,0), (0,1), (0,2), (0,3)
    .word 0, 0, 0, 1, 0, 2, 0, 3
    # Rotation 1: horizontal (-1,1), (0,1), (1,1), (2,1)
    .word -1, 1, 0, 1, 1, 1, 2, 1
    # Rotation 2: same as 0
    .word 0, 0, 0, 1, 0, 2, 0, 3
    # Rotation 3: same as 1
    .word -1, 1, 0, 1, 1, 1, 2, 1
    
    # T Block - Type 2
    # Rotation 0: T shape (0,0), (1,0), (2,0), (1,1)
    .word 0, 0, 1, 0, 2, 0, 1, 1
    # Rotation 1: (1,0), (0,1), (1,1), (1,2)
    .word 1, 0, 0, 1, 1, 1, 1, 2
    # Rotation 2: (1,0), (0,1), (1,1), (2,1)
    .word 1, 0, 0, 1, 1, 1, 2, 1
    # Rotation 3: (0,0), (0,1), (1,1), (0,2)
    .word 0, 0, 0, 1, 1, 1, 0, 2
    
    # S Block - Type 3 (Z-shape rotated)
    # Rotation 0: (1,0), (2,0), (0,1), (1,1)
    .word 1, 0, 2, 0, 0, 1, 1, 1
    # Rotation 1: (0,0), (0,1), (1,1), (1,2)
    .word 0, 0, 0, 1, 1, 1, 1, 2
    # Rotation 2: same as 0
    .word 1, 0, 2, 0, 0, 1, 1, 1
    # Rotation 3: same as 1
    .word 0, 0, 0, 1, 1, 1, 1, 2
    
    # Z Block - Type 4
    # Rotation 0: (0,0), (1,0), (1,1), (2,1)
    .word 0, 0, 1, 0, 1, 1, 2, 1
    # Rotation 1: (1,0), (0,1), (1,1), (0,2)
    .word 1, 0, 0, 1, 1, 1, 0, 2
    # Rotation 2: same as 0
    .word 0, 0, 1, 0, 1, 1, 2, 1
    # Rotation 3: same as 1
    .word 1, 0, 0, 1, 1, 1, 0, 2
    
    # J Block - Type 5
    # Rotation 0: (0,0), (0,1), (0,2), (1,2)
    .word 0, 0, 0, 1, 0, 2, 1, 2
    # Rotation 1: (0,0), (1,0), (2,0), (0,1)
    .word 0, 0, 1, 0, 2, 0, 0, 1
    # Rotation 2: (0,0), (1,0), (1,1), (1,2)
    .word 0, 0, 1, 0, 1, 1, 1, 2
    # Rotation 3: (2,0), (0,1), (1,1), (2,1)
    .word 2, 0, 0, 1, 1, 1, 2, 1
    
    # L Block - Type 6
    # Rotation 0: (1,0), (1,1), (1,2), (0,2)
    .word 1, 0, 1, 1, 1, 2, 0, 2
    # Rotation 1: (0,0), (0,1), (1,1), (2,1)
    .word 0, 0, 0, 1, 1, 1, 2, 1
    # Rotation 2: (0,0), (1,0), (0,1), (0,2)
    .word 0, 0, 1, 0, 0, 1, 0, 2
    # Rotation 3: (0,0), (1,0), (2,0), (2,1)
    .word 0, 0, 1, 0, 2, 0, 2, 1

##############################################################################
# Mutable Data
##############################################################################
XOffset:
    .word 6
YOffset:
    .word 15
BlockSize:
    .word 2
LightGrey:
    .word 0x454545
DarkGrey:
    .word 0x17161A
WallColor:
    .word 0x808080  # Light gray for walls
# Current tetromino position (in grid coordinates)
TetrominoX:
    .word 4  # Starting column
TetrominoY:
    .word 0  # Starting row
TetrominoRotation:
    .word 0  # Current rotation state (0-3)
TetrominoType:
    .word 0
    
# Gravity timing variables
GravityTimer:
    .word 0         # Current timer value
GravityDelay:
    .word 30       # Frames between gravity drops (adjust for speed)

GameOverWidth: .word 32
GameOverHeight: .word 16
GameOverData:
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0xED1C24, 0xED1C24, 0xED1C24, 0x000000, 0x000000, 0xED1C24, 0x000000, 0x000000
    .word 0xED1C24, 0x000000, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0xED1C24
    .word 0xED1C24, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xED1C24
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000
    .word 0xED1C24, 0xED1C24, 0x000000, 0xED1C24, 0xED1C24, 0x000000, 0xED1C24, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xED1C24
    .word 0x000000, 0xED1C24, 0xED1C24, 0x000000, 0xED1C24, 0xED1C24, 0xED1C24, 0x000000
    .word 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0xED1C24
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xED1C24
    .word 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000
    .word 0xED1C24, 0x000000, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xED1C24
    .word 0xED1C24, 0xED1C24, 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000
    .word 0xED1C24, 0x000000, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0xED1C24
    .word 0xED1C24, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0xED1C24, 0xED1C24, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24
    .word 0x000000, 0xED1C24, 0xED1C24, 0xED1C24, 0x000000, 0xED1C24, 0xED1C24, 0xED1C24
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0xED1C24, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24
    .word 0x000000, 0xED1C24, 0x000000, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0xED1C24, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24
    .word 0x000000, 0xED1C24, 0xED1C24, 0x000000, 0x000000, 0xED1C24, 0xED1C24, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0xED1C24, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24
    .word 0x000000, 0xED1C24, 0x000000, 0x000000, 0x000000, 0xED1C24, 0x000000, 0xED1C24
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0xED1C24, 0xED1C24, 0x000000, 0x000000, 0x000000, 0xED1C24, 0x000000
    .word 0x000000, 0xED1C24, 0xED1C24, 0xED1C24, 0x000000, 0xED1C24, 0x000000, 0xED1C24
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000

# Add this to your mutable data section:
GameState: .word 0    # 0 = playing, 1 = game over

##############################################################################
# Code
##############################################################################
	.text
	.globl main
	# Run the Tetris game.
main:
    # Initialize the game
    lw $t0, ADDR_DSPL
    jal initalizeGameBoard
    jal drawWalls
    
game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep
    #5. Go back to 1
    # Check game state
    lw $t1, GameState
    beq $t1, 1, game_over_state
    
    jal checkInput          # Handle user input
    jal handleGravity
    jal updateTetromino     # Handle falling piece logic
    jal refreshDisplay      # Redraw everything
    # Small delay to control game speed
    li $v0, 32          # syscall for sleep
    li $a0, 50          # sleep for 50ms
    syscall
    b game_loop
    
game_over_state:
    # Display game over screen
    jal displayGameOver
    jal gameOverInput
    
    # Small delay
    li $v0, 32
    li $a0, 100
    syscall
    b game_loop
    
exitGame:
    li $v0, 10              # terminate the program gracefully
    syscall
initalizeGameBoard:
    la $t1, GameBoard
    li $t2, 0       #empty cell
    li $t3, 200     #10*20
    li $t4, 0       #increment counter
initLoop:
    bge $t4, $t3, initDone
        sw $t2, 0($t1)
        addi $t1, $t1, 4
        addi $t4, $t4, 1
        j initLoop
initDone:
    jr $ra
refreshDisplay:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal drawBackground      # Clear with checkerboard
    jal drawPlacedBlocks    # Draw permanent blocks from GameBoard
    jal drawCurrentPiece    # Draw the falling piece
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
updateTetromino:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if piece should fall automatically (add timer logic later)
    # For now, pieces only fall when 's' is pressed
    
    # Check if current piece should be placed
    jal checkIfShouldPlace
    beq $v0, 1, placePiece
    
    j updateDone
placePiece:
    jal placeCurrentPiece
    jal clearLines
    jal spawnNewPiece

updateDone:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# General collision detection for any tetromino
# Input: $a0 = tetromino type, $a1 = rotation (0-3), $a2 = test_row, $a3 = test_col
# Output: $v0 = 1 if collision, 0 if no collision
checkTetrominoCollision:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    # Calculate offset to the correct tetromino and rotation data
    # Each type has 32 words (4 rotations * 4 blocks * 2 coordinates)
    # Each rotation has 8 words (4 blocks * 2 coordinates)
    
    la $s0, TetrominoShapes     # Base address of shape data
    sll $t8, $a0, 7             # type * 128 bytes (32 words * 4 bytes)
    add $s0, $s0, $t8           # Add type offset
    sll $t1, $a1, 5             # rotation * 32 bytes (8 words * 4 bytes)
    add $s0, $s0, $t1           # Add rotation offset
    
    move $s1, $a2          # Save test_row
    move $s2, $a3          # Save test_col
    li $s3, 0              # Block counter (0-3)
    
check_block_loop:
    li $t8, 4
    bge $s3, $t8, no_collision  # If we've checked all 4 blocks, no collision
    
    # Get relative coordinates for this block
    sll $t8, $s3, 3        # block_index * 8 bytes (2 words per block)
    add $t1, $s0, $t8      # Address of this block's data
    lw $t2, 0($t1)         # rel_col (X coordinate)
    lw $t3, 4($t1)         # rel_row (Y coordinate)
    
    # Calculate absolute position
    add $a0, $s1, $t3      # abs_row = test_row + rel_row
    add $a1, $s2, $t2      # abs_col = test_col + rel_col
    
    # Check bounds
    bltz $a0, collision_detected    # row < 0
    bltz $a1, collision_detected    # col < 0
    li $t4, 20
    bge $a0, $t4, collision_detected  # row >= 20
    li $t4, 10
    bge $a1, $t4, collision_detected  # col >= 10
    
    # Check if cell is occupied
    jal getBoardCell
    lw $t8, 0($v0)
    bnez $t8, collision_detected
    
    # Check next block
    addi $s3, $s3, 1
    j check_block_loop
    
collision_detected:
    li $v0, 1
    j collision_check_done
    
no_collision:
    li $v0, 0
    
collision_check_done:
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# Check if current piece should be placed (hit bottom or obstacle)
checkIfShouldPlace:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if piece would collide if moved down
    lw $a0, TetrominoType
    lw $a1, TetrominoRotation
    lw $t1, TetrominoY
    addi $a2, $t1, 1        # Try moving down
    lw $a3, TetrominoX
    
    jal checkTetrominoCollision
    beq $v0, 1, shouldPlace
    
    # No collision, piece can continue falling
    li $v0, 0
    j checkPlace_done

shouldPlace:
    li $v0, 1

checkPlace_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Draw the current falling piece
drawCurrentPiece:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t1, TetrominoType
    beq $t1, 0, draw_O_piece
    beq $t1, 1, draw_I_piece
    beq $t1, 2, draw_T_piece
    beq $t1, 3, draw_S_piece
    beq $t1, 4, draw_Z_piece
    beq $t1, 5, draw_J_piece
    beq $t1, 6, draw_L_piece
    
draw_O_piece:
    jal drawOBlock
    j draw_piece_done
    
draw_I_piece:
    jal drawIBlock
    j draw_piece_done

draw_T_piece:
    jal drawTBlock
    j draw_piece_done

draw_S_piece:
    jal drawSBlock
    j draw_piece_done
    
draw_Z_piece:
    jal drawZBlock
    j draw_piece_done

draw_J_piece:
    jal drawJBlock
    j draw_piece_done
    
draw_L_piece:
    jal drawLBlock
    j draw_piece_done
    
draw_piece_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

placeCurrentPiece:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t1, TetrominoType
    beq $t1, 0, place_O_piece
    beq $t1, 1, place_I_piece
    beq $t1, 2, place_T_piece
    beq $t1, 3, place_S_piece
    beq $t1, 4, place_Z_piece
    beq $t1, 5, place_J_piece
    beq $t1, 6, place_L_piece
    
place_O_piece:
    jal placeOBlock
    j place_piece_done
    
place_I_piece:
    jal placeIBlock
    j place_piece_done

place_T_piece:
    jal placeTBlock
    j place_piece_done
    
place_S_piece:
    jal placeSBlock
    j place_piece_done
    
place_Z_piece:
    jal placeZBlock
    j place_piece_done
    
place_J_piece:
    jal placeJBlock
    j place_piece_done
    
place_L_piece:
    jal placeLBlock
    j place_piece_done
    
place_piece_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

spawnNewPiece:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Reset position
    li $t1, 4
    sw $t1, TetrominoX
    li $t1, 1
    sw $t1, TetrominoY
    li $t1, 0
    sw $t1, TetrominoRotation
    
    # Generate random piece
    li $v0, 42          # syscall: random int range
    li $a0, 0           # random number generator ID (0 = default)
    li $a1, 7          
    syscall
    sw $a0, TetrominoType   # $a0 contains the random result
    
    # Check if game is over
    jal checkGameOver
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
drawPlacedBlocks:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $s0, 0       #row counter
placedRowLoop:
    li $t1, 20
    bge $s0, $t1, placedDone
    li $s1, 0       #col counter
placedColLoop:
    li $t1, 10
    bge $s1, $t1, placedNextRow
    
    #Get color of cell
    move $a0, $s0
    move $a1, $s1
    jal getBoardCell
    lw $s2, 0($v0)      #Load Colour
    
    #If cell is empty, skip it
    beq $s2, $zero, placedNextCol
    
    lw $t1, XOffset
    lw $t2, YOffset
    lw $t3, BlockSize
    
    mul $t4, $s0, $t3   # row * BlockSize
    add $t4, $t4, $t2   # + YOffset = Y position
    mul $t5, $s1, $t3   # col * BlockSize
    add $t5, $t5, $t1   # + XOffset = X position
    
    move $a0, $t4       # Y position
    move $a1, $t5       # X position
    move $a2, $s2       # Color from board
    jal drawSingleBlock
placedNextCol:
    addi $s1, $s1, 1
    j placedColLoop
placedNextRow:
    addi $s0, $s0, 1
    j placedRowLoop
placedDone:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
# Get address of cell at (row, col) in game board
# Input: $a0 = row, $a1 = col
# Output: $v0 = address of cell
getBoardCell:
    la $v0, GameBoard
    mul $t9, $a0, 10       # row * 10
    add $t9, $t9, $a1       # row * 10 + col
    sll $t9, $t9, 2         # multiply by 4
    add $v0, $v0, $t9       # base + offset
    jr $ra

checkInput:
    lw $t1, ADDR_KBRD
    lw $t2, 0($t1)
    beq $t2, $zero, noInput
    lw $t2, 4($t1)
    
    # Check which key was pressed
    li $t3, 0x77        # 'w' key
    beq $t2, $t3, rotateBlock
    
    li $t3, 0x61        # 'a' key  
    beq $t2, $t3, moveLeft
    
    li $t3, 0x73        # 's' key
    beq $t2, $t3, moveDown
    
    li $t3, 0x64        # 'd' key
    beq $t2, $t3, moveRight
    
    li $t3, 0x71        # 'q' key
    beq $t2, $t3, exitGame
    
noInput:
    jr $ra
moveLeft:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Get current tetromino info
    lw $a0, TetrominoType
    lw $a1, TetrominoRotation
    lw $a2, TetrominoY      # Current row
    lw $t1, TetrominoX
    addi $a3, $t1, -1       # Try moving left
    
    jal checkTetrominoCollision
    beq $v0, 1, moveLeft_blocked
    
    # No collision, update position
    sw $a3, TetrominoX
    
moveLeft_blocked:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

moveRight:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Get current tetromino info
    lw $a0, TetrominoType
    lw $a1, TetrominoRotation
    lw $a2, TetrominoY      # Current row
    lw $t1, TetrominoX
    addi $a3, $t1, 1        # Try moving right
    
    jal checkTetrominoCollision
    beq $v0, 1, moveRight_blocked
    
    # No collision, update position
    sw $a3, TetrominoX
    
moveRight_blocked:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

moveDown:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Get current tetromino info
    lw $a0, TetrominoType
    lw $a1, TetrominoRotation
    lw $t1, TetrominoY
    addi $a2, $t1, 1        # Try moving down
    lw $a3, TetrominoX      # Current column
    
    jal checkTetrominoCollision
    beq $v0, 1, moveDown_blocked
    
    # No collision, update position
    sw $a2, TetrominoY
    
    # Reset gravity timer to prevent double-drop
    sw $zero, GravityTimer
    
moveDown_blocked:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
rotateBlock:
    # Get current rotation and increment
    lw $t1, TetrominoRotation
    addi $t1, $t1, 1

    # Explicit wrap-around check
    li $t2, 4
    blt $t1, $t2, rotation_ok
    li $t1, 0               # Reset to 0 if >= 4

rotation_ok:
    # Update rotation (no collision checking for now)
    sw $t1, TetrominoRotation
    jr $ra
    
drawBackground:
    lw $t1, XOffset
    lw $t2, YOffset
    lw $t3, LightGrey
    lw $t4, DarkGrey
    lw $s4, BlockSize
    
    li $t5, 10      #Number of Cols
    li $t6, 20      #Number of Rows
    
    li $t8, 0       #row index
rowLoop:
    bge $t8, $t6, doneDrawing
    li $t9, 0       #col index
colLoop:
    bge $t9, $t5, nextRow
        add $s7, $t8, $t9
        andi $s7, $s7, 1
        beq $s7, $zero, useLight
            move $s1, $t4
            j drawBlock
    useLight:
        move $s1, $t3
drawBlock:
    # Calculate starting position for this Tetris cell
    mul $s2, $t8, $s4       # row * BlockSize
    add $s2, $s2, $t2       # + YOffset = starting Y
    mul $s3, $t9, $s4       # col * BlockSize  
    add $s3, $s3, $t1       # + XOffset = starting X
    
# Draw a BlockSize x BlockSize square
    li $a0, 0               # Y offset within block
blockRowLoop:
    bge $a0, $s4, nextCol   # If block_y >= BlockSize, done with block
    li $a1, 0               # X offset within block
    
blockColLoop:
    bge $a1, $s4, nextBlockRow  # If block_x >= BlockSize, next row
    
    # Calculate absolute unit position
    add $a2, $s2, $a0       # absolute Y = start_Y + block_y
    add $a3, $s3, $a1       # absolute X = start_X + block_x
    
    
    # Calculate memory address: base + 4 * (Y * 32 + X)
    mul $a2, $a2, 32       # Y * 32
    add $a2, $a2, $a3       # Y * 32 + X
    sll $a2, $a2, 2         # Multiply by 4 (each unit = 4 bytes)
    add $t7, $t0, $a2       # Add base address
    
    # Store the color
    sw $s1, 0($t7)
    
    addi $a1, $a1, 1        # block_x++
    j blockColLoop
    
nextBlockRow:
    addi $a0, $a0, 1        # block_y++
    j blockRowLoop
    
nextCol:
    addi $t9, $t9, 1        # col++
    j colLoop

nextRow:
        addi $t8, $t8, 1
        j rowLoop
    
doneDrawing:
    jr $ra

drawWalls:
    lw $t1, XOffset
    lw $t2, YOffset
    lw $t3, WallColor
    lw $t4, BlockSize
    
    sub $s0, $t1, $t4       #Left wall = XOffset - BlockSize
    addi $s0, $s0, 1
    mul $t5, $t4, 10
    add $s1, $t1, $t5       #Right wall = XOffset + (10*BlockSize)
    mul $t5, $t4, 20
    add $s2, $t2, $t5       #Bottom wall = YOffset + (20*BlockSize)
    
    li $t6, 0       #Left wall row Counter
    li $t7, 0       #Right wall row counter
    li $t8, 0       #Bottom wall row counter
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
drawLeftWall:
    mul $t5, $t4, 20
    bge $t6, $t5, drawRightWall
        add $a2, $t2, $t6
        move $a3, $s0
        jal drawWallBlock
        
        addi $t6, $t6, 1
        j drawLeftWall
drawRightWall:
    mul $t5, $t4, 20
    bge $t7, $t5, drawBottomWall
        add $a2, $t2, $t7
        move $a3, $s1
        jal drawWallBlock
        
        addi $t7, $t7, 1
        j drawRightWall
drawBottomWall:
    mul $t5, $t4, 11
    bge $t8, $t5, wallsDone
        add $a3, $s0, $t8
        move $a2, $s2
        jal drawWallBlock
        
        addi $t8, $t8, 1
        j drawBottomWall
drawWallBlock:
    mul $a2, $a2, 32       # Y * 32
    add $a2, $a2, $a3       # Y * 32 + X
    sll $a2, $a2, 2         # Multiply by 4 (each unit = 4 bytes)
    add $s4, $t0, $a2       # Add base address

    # Store the color
    sw $t3, 0($s4)
    jr $ra
wallsDone:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# General function to draw any tetromino using the data structure
# Input: $a0 = color array address (4 colors for the 4 blocks)
drawTetromino:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    move $s0, $a0        # Save color array address
    
    # Load game state
    lw $t1, TetrominoType      # Tetromino type (0-6)
    lw $t2, TetrominoRotation  # Rotation (0-3)
    lw $t3, TetrominoX         # Grid X position
    lw $t4, TetrominoY         # Grid Y position
    lw $s5, BlockSize          # Block size for scaling (matching your convention)
    lw $t5, XOffset            # Base X offset
    lw $t6, YOffset            # Base Y offset
    
    # Calculate pixel position
    mul $s1, $t3, $s5    # gridX * BlockSize
    add $s1, $s1, $t5    # + XOffset = pixel X
    mul $s2, $t4, $s5    # gridY * BlockSize  
    add $s2, $s2, $t6    # + YOffset = pixel Y
    
    # Calculate offset into TetrominoShapes array
    # Offset = (type * 4 + rotation) * 8 * 4 bytes
    # Each tetromino has 4 rotations, each rotation has 8 coordinates (4 blocks × 2 coords)
    sll $t1, $t1, 2      # type * 4
    add $t1, $t1, $t2    # + rotation
    sll $t1, $t1, 5      # * 32 (8 coordinates * 4 bytes each)
    
    la $t7, TetrominoShapes
    add $s3, $t7, $t1    # Address of current rotation data
    
    # Draw all 4 blocks
    li $t9, 0            # Block counter
    
drawBlock_loop:
    # Load X and Y offsets for this block
    lw $t1, 0($s3)       # X offset
    lw $t2, 4($s3)       # Y offset
    
    # Calculate actual pixel positions
    mul $t1, $t1, $s5    # X offset * BlockSize
    add $a1, $s1, $t1    # base pixel X + scaled offset
    mul $t2, $t2, $s5    # Y offset * BlockSize
    add $a0, $s2, $t2    # base pixel Y + scaled offset
    
    # Load color for this block
    sll $t3, $t9, 2      # block index * 4 bytes
    add $t4, $s0, $t3    # color array + offset
    lw $a2, 0($t4)       # Load color
    
    # Draw the block
    jal drawSingleBlock
    
    # Move to next coordinate pair
    addi $s3, $s3, 8     # Next X,Y pair (2 words = 8 bytes)
    addi $t9, $t9, 1     # Increment block counter
    blt $t9, 4, drawBlock_loop
    
    # Restore registers
    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra

drawOBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    # O block colors (yellow theme)
    li $t1, 0xFFFF00     # Bright yellow
    sw $t1, 0($sp)
    
    li $t1, 0xF0F000     # Slightly darker yellow
    sw $t1, 4($sp)
    
    li $t1, 0xE0E000     # Even darker yellow
    sw $t1, 8($sp)
    
    li $t1, 0xD0D000     # Darkest yellow
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal drawTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

drawIBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    li $t1, 0x00FFFF     # Bright cyan
    sw $t1, 0($sp)
    
    li $t1, 0x00E6E6     # Slightly darker cyan
    sw $t1, 4($sp)
    
    li $t1, 0x00CCCC     # Even darker cyan
    sw $t1, 8($sp)
    
    li $t1, 0x00B3B3     # Darkest cyan
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal drawTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

drawTBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    # T block colors (violet/light purple theme)
    li $t1, 0xC314E2     # Bright violet
    sw $t1, 0($sp)
    
    li $t1, 0xB612D4     # Slightly darker violet
    sw $t1, 4($sp)
    
    li $t1, 0xB012CE     # Even darker violet
    sw $t1, 8($sp)
    
    li $t1, 0xA711C3     # Darkest violet
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal drawTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

drawSBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    li $t1, 0xE21414     # Bright red
    sw $t1, 0($sp)
    
    li $t1, 0xD41212     # Slightly darker red
    sw $t1, 4($sp)
    
    li $t1, 0xCE1212     # Even darker red
    sw $t1, 8($sp)
    
    li $t1, 0xC31111     # Darkest red
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal drawTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

drawZBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    li $t1, 0x14E214     # Bright green
    sw $t1, 0($sp)
    
    li $t1, 0x12D412     # Slightly darker green
    sw $t1, 4($sp)
    
    li $t1, 0x12CE12     # Even darker green
    sw $t1, 8($sp)
    
    li $t1, 0x11C311     # Darkest green
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal drawTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

drawJBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16

    li $t1, 0xE21491     # Bright pink
    sw $t1, 0($sp)
    
    li $t1, 0xD41288     # Slightly darker pink
    sw $t1, 4($sp)
    
    li $t1, 0xCE1283     # Even darker pink
    sw $t1, 8($sp)
    
    li $t1, 0xC3117A     # Darkest pink
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal drawTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    
drawLBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    li $t1, 0xE26E14     # Bright orange
    sw $t1, 0($sp)
    
    li $t1, 0xD46612     # Slightly darker orange
    sw $t1, 4($sp)
    
    li $t1, 0xCE6212     # Even darker orange
    sw $t1, 8($sp)
    
    li $t1, 0xC35B11     # Darkest orange
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal drawTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# General function to place any tetromino into the game board using the data structure
# Input: $a0 = color array address (4 colors for the 4 blocks)
placeTetromino:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    move $s0, $a0        # Save color array address
    
    # Load game state
    lw $t1, TetrominoType      # Tetromino type (0-6)
    lw $t2, TetrominoRotation  # Rotation (0-3)
    lw $s1, TetrominoX         # Grid X position
    lw $s2, TetrominoY         # Grid Y position
    
    # Calculate offset into TetrominoShapes array
    # Offset = (type * 4 + rotation) * 8 * 4 bytes
    # Each tetromino has 4 rotations, each rotation has 8 coordinates (4 blocks × 2 coords)
    sll $t1, $t1, 2      # type * 4
    add $t1, $t1, $t2    # + rotation
    sll $t1, $t1, 5      # * 32 (8 coordinates * 4 bytes each)
    
    la $t7, TetrominoShapes
    add $s3, $t7, $t1    # Address of current rotation data
    
    # Place all 4 blocks
    li $t8, 0            # Block counter
    
placeBlock_loop:
    # Load X and Y offsets for this block
    lw $t1, 0($s3)       # X offset
    lw $t2, 4($s3)       # Y offset
    
    # Calculate grid positions
    add $a0, $s2, $t2    # base grid Y + Y offset
    add $a1, $s1, $t1    # base grid X + X offset
    
    # Get board cell address
    jal getBoardCell
    
    # Load color for this block
    sll $t3, $t8, 2      # block index * 4 bytes
    add $t4, $s0, $t3    # color array + offset
    lw $t5, 0($t4)       # Load color
    
    # Store color in board cell
    sw $t5, 0($v0)
    
    # Move to next coordinate pair
    addi $s3, $s3, 8     # Next X,Y pair (2 words = 8 bytes)
    addi $t8, $t8, 1     # Increment block counter
    blt $t8, 4, placeBlock_loop
    
    # Restore registers
    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra

placeOBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    # O block colors (yellow theme)
    li $t1, 0xFFFF00     # Bright yellow
    sw $t1, 0($sp)
    
    li $t1, 0xF0F000     # Slightly darker yellow
    sw $t1, 4($sp)
    
    li $t1, 0xE0E000     # Even darker yellow
    sw $t1, 8($sp)
    
    li $t1, 0xD0D000     # Darkest yellow
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal placeTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    
placeIBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16
    
    li $t1, 0x00FFFF     # Bright cyan
    sw $t1, 0($sp)
    
    li $t1, 0x00E6E6     # Slightly darker cyan
    sw $t1, 4($sp)
    
    li $t1, 0x00CCCC     # Even darker cyan
    sw $t1, 8($sp)
    
    li $t1, 0x00B3B3     # Darkest cyan
    sw $t1, 12($sp)
    
    move $a0, $sp
    jal placeTetromino
    
    addi $sp, $sp, 16
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

placeTBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16   # Space for 4 colors
    
    # T block colors (violet/light purple theme)
    li $t1, 0xC314E2     # Bright violet
    sw $t1, 0($sp)       # Block 0 color
    
    li $t1, 0xB612D4     # Slightly darker violet
    sw $t1, 4($sp)       # Block 1 color
    
    li $t1, 0xB012CE     # Even darker violet
    sw $t1, 8($sp)       # Block 2 color
    
    li $t1, 0xA711C3     # Darkest violet
    sw $t1, 12($sp)      # Block 3 color
    
    # Call general placement function
    move $a0, $sp        # Pass color array address
    jal placeTetromino
    
    # Clean up stack
    addi $sp, $sp, 16    # Remove color array
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

placeSBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16   # Space for 4 colors

    li $t1, 0xE21414     # Bright red
    sw $t1, 0($sp)
    
    li $t1, 0xD41212     # Slightly darker red
    sw $t1, 4($sp)
    
    li $t1, 0xCE1212     # Even darker red
    sw $t1, 8($sp)
    
    li $t1, 0xC31111     # Darkest red
    sw $t1, 12($sp)
    
    # Call general placement function
    move $a0, $sp        # Pass color array address
    jal placeTetromino
    
    # Clean up stack
    addi $sp, $sp, 16    # Remove color array
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

placeZBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16   # Space for 4 colors
    
    li $t1, 0x14E214     # Bright green
    sw $t1, 0($sp)
    
    li $t1, 0x12D412     # Slightly darker green
    sw $t1, 4($sp)
    
    li $t1, 0x12CE12     # Even darker green
    sw $t1, 8($sp)
    
    li $t1, 0x11C311     # Darkest green
    sw $t1, 12($sp)
    
    # Call general placement function
    move $a0, $sp        # Pass color array address
    jal placeTetromino
    
    # Clean up stack
    addi $sp, $sp, 16    # Remove color array
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

placeJBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16   # Space for 4 colors
    
    li $t1, 0xE21491     # Bright pink
    sw $t1, 0($sp)
    
    li $t1, 0xD41288     # Slightly darker pink
    sw $t1, 4($sp)
    
    li $t1, 0xCE1283     # Even darker pink
    sw $t1, 8($sp)
    
    li $t1, 0xC3117A     # Darkest pink
    sw $t1, 12($sp)
    
    # Call general placement function
    move $a0, $sp        # Pass color array address
    jal placeTetromino
    
    # Clean up stack
    addi $sp, $sp, 16    # Remove color array
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

placeLBlock:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Create color array on stack
    addi $sp, $sp, -16   # Space for 4 colors
    
    li $t1, 0xE26E14     # Bright orange
    sw $t1, 0($sp)
    
    li $t1, 0xD46612     # Slightly darker orange
    sw $t1, 4($sp)
    
    li $t1, 0xCE6212     # Even darker orange
    sw $t1, 8($sp)
    
    li $t1, 0xC35B11     # Darkest orange
    sw $t1, 12($sp)
    
    # Call general placement function
    move $a0, $sp        # Pass color array address
    jal placeTetromino
    
    # Clean up stack
    addi $sp, $sp, 16    # Remove color array
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Draw a single block at position (a0=Y, a1=X) with color a2
drawSingleBlock:
    # Draw BlockSize x BlockSize square
    addi $sp, $sp, -12
    sw $s1, 0($sp)
    sw $s2, 4($sp)
    sw $s3, 8($sp)
    li $t7, 0            # Y offset within block
singleBlockRowLoop:
    bge $t7, $s5, singleBlockDone
    li $t8, 0            # X offset within block
    
singleBlockColLoop:
    bge $t8, $s5, singleBlockNextRow
    
    # Calculate absolute position
    add $s1, $a0, $t7    # absolute Y = start_Y + offset
    add $s2, $a1, $t8    # absolute X = start_X + offset
    
    # Calculate memory address: base + 4 * (Y * 32 + X)
    mul $s1, $s1, 32     # Y * 32
    add $s1, $s1, $s2    # Y * 32 + X
    sll $s1, $s1, 2      # Multiply by 4 (each unit = 4 bytes)
    add $s3, $t0, $s1    # Add base address
    
    # Store the color
    sw $a2, 0($s3)
    
    addi $t8, $t8, 1     # X offset++
    j singleBlockColLoop
    
singleBlockNextRow:
    addi $t7, $t7, 1     # Y offset++
    j singleBlockRowLoop
    
singleBlockDone:
    lw $s1, 0($sp)
    lw $s2, 4($sp)
    lw $s3, 8($sp)
    addi $sp, $sp, 12
    jr $ra
    
#-------CLEAR LINES-------
clearLines:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    # Start from bottom row and work up
    li $s6, 19          # Start at row 19 (bottom)
    
check_next_row:
    bltz $s6, clear_done    # If row < 0, we're done
    
    # Check if current row is complete
    move $a0, $s6
    jal isRowComplete
    
    beq $v0, 1, clear_this_row
    
    # Row not complete, check next row up
    addi $s6, $s6, -1
    j check_next_row
    
clear_this_row:
    # Clear the complete row and shift everything down
    move $a0, $s6
    jal clearRow
    move $a0, $s6
    jal shiftRowsDown
    
    li $t1, 5
    lw $t2, GravityDelay
    bge $t2, $t1, increaseGravitySpeed
    
    # Don't decrement $s0 - check the same row again since
    # everything shifted down into it
    j check_next_row
    
clear_done:
    lw $s6, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

# Check if a row is completely filled (no empty cells)
# Input: $a0 = row number
# Output: $v0 = 1 if complete, 0 if not complete
isRowComplete:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s6, 4($sp)
    
    move $s6, $a0       # Save row number
    li $t8, 0           # Column counter
    
check_column:
    li $t1, 10
    bge $t8, $t1, row_is_complete   # Checked all columns
    
    move $a0, $s6       # Row
    move $a1, $t8       # Column
    jal getBoardCell
    lw $t2, 0($v0)      # Get cell value
    
    beq $t2, $zero, row_not_complete    # If empty, row not complete
    
    addi $t8, $t8, 1    # Next column
    j check_column
    
row_is_complete:
    li $v0, 1
    j check_row_done
    
row_not_complete:
    li $v0, 0
    
check_row_done:
    lw $s6, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

# Clear a specific row (set all cells to 0)
# Input: $a0 = row number
clearRow:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $s6, $a0       # Save row number
    li $t8, 0           # Column counter
clear_column:
    li $s1, 0xFFFFFF
    li $t1, 10
    bge $t8, $t1, clear_row_done    # Cleared all columns
    
    # Clear this cell
    move $a0, $s6       # Row
    move $a1, $t8       # Column
    jal getBoardCell
    move $v1, $v0
    
    sw $s1, 0($v0)
    
    li $v0, 32
    li $a0, 20
    syscall
    
    addi $sp, $sp, -4
    sw $t8, 0($sp)
    
    jal drawBackground
    jal drawPlacedBlocks
    
    lw $t8, 0($sp)
    addi $sp, $sp, 4
    
    sw $zero, 0($v1)    # Set to 0 (empty)
    
    addi $t8, $t8, 1    # Next column
    j clear_column
    
clear_row_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Shift all rows above the specified row down by one
# Input: $a0 = row number (everything above this gets shifted down)
shiftRowsDown:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s6, 4($sp)
    sw $s1, 8($sp)
    
    move $s6, $a0       # Save target row
    
    # Start from target row and work up, copying from row above
    move $s1, $s6       # Current destination row
    
shift_loop:
    beq $s1, $zero, shift_done  # If at row 0, we're done
    
    # Copy row (s1-1) to row s1
    addi $t8, $s1, -1   # Source row = destination row - 1
    move $a0, $t8       # Source row
    move $a1, $s1       # Destination row
    jal copyRow
    
    addi $s1, $s1, -1   # Move to next row up
    j shift_loop
    
shift_done:
    lw $s1, 8($sp)
    lw $s6, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra

# Copy one row to another
# Input: $a0 = source row, $a1 = destination row
copyRow:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s6, 4($sp)
    sw $s1, 8($sp)
    
    move $s6, $a0       # Source row
    move $s1, $a1       # Destination row
    li $t8, 0           # Column counter
copy_column:
    li $t1, 10
    bge $t8, $t1, copy_done     # Copied all columns
    
    # Get value from source cell
    move $a0, $s6       # Source row
    move $a1, $t8       # Column
    jal getBoardCell
    lw $t2, 0($v0)      # Get source value
    
    # Store value in destination cell
    move $a0, $s1       # Destination row
    move $a1, $t8       # Column
    jal getBoardCell
    sw $t2, 0($v0)      # Store value
    
    addi $t8, $t8, 1    # Next column
    j copy_column
    
copy_done:
    lw $s1, 8($sp)
    lw $s6, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra
    
handleGravity:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Increment gravity timer
    lw $t1, GravityTimer
    addi $t1, $t1, 1
    sw $t1, GravityTimer
    
    # Check if it's time for gravity to act
    lw $t2, GravityDelay
    blt $t1, $t2, gravityDone
    
    # Reset timer
    sw $zero, GravityTimer
    
    # Apply gravity (move piece down)
    jal applyGravity
    
gravityDone:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
# Function to apply gravity (move piece down)
applyGravity:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if piece can move down
    lw $a0, TetrominoType
    lw $a1, TetrominoRotation
    lw $t1, TetrominoY
    addi $a2, $t1, 1        # Try moving down
    lw $a3, TetrominoX      # Current column
    
    jal checkTetrominoCollision
    beq $v0, 1, gravityBlocked
    
    # No collision, move piece down
    sw $a2, TetrominoY
    
gravityBlocked:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
increaseGravitySpeed:
    addi $t2, $t2, -1
    sw $t2, GravityDelay
    j check_next_row
    
# Function to check if game is over (blocks reach top)
checkGameOver:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if we can spawn a new piece at starting position (4, 1)
    lw $a0, TetrominoType
    lw $a1, TetrominoRotation
    li $a2, 0           # Starting Y position
    li $a3, 4           # Starting X position
    
    jal checkTetrominoCollision
    beq $v0, 1, gameIsOver
    
    # Game continues
    li $v0, 0
    j checkGameOverDone
    
gameIsOver:
    # Set game state to game over
    li $t1, 1
    sw $t1, GameState
    li $v0, 1
    
checkGameOverDone:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to display the game over screen
displayGameOver:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # First, fill the entire screen with black
    jal clearScreenBlack
    
    # Calculate center position for game over screen
    li $t1, 0           # Start X = 0 (centered)
    li $t2, 20           # Start Y = 8 (centered vertically)
    
    # Load game over image dimensions
    lw $t3, GameOverWidth   # 32
    lw $t4, GameOverHeight  # 16
    
    # Draw the game over image
    la $t5, GameOverData    # Start of pixel data
    li $t6, 0               # Y counter
    
gameOverRowLoop:
    bge $t6, $t4, gameOverDone    # If Y >= height, done
    li $t7, 0                     # X counter
    
gameOverColLoop:
    bge $t7, $t3, gameOverNextRow # If X >= width, next row
    
    # Calculate pixel position
    add $t8, $t2, $t6             # Display Y = start Y + image Y
    add $t9, $t1, $t7             # Display X = start X + image X
    
    # Get color from image data
    mul $s1, $t6, $t3             # Y * width
    add $s1, $s1, $t7             # + X = pixel index
    sll $s1, $s1, 2               # * 4 bytes per pixel
    add $s2, $t5, $s1             # Address of pixel data
    lw $s3, 0($s2)                # Load color
    
    # Calculate display buffer address
    mul $s4, $t8, 32              # Y * display_width
    add $s4, $s4, $t9             # + X
    sll $s4, $s4, 2               # * 4 bytes
    lw $s5, ADDR_DSPL
    add $s4, $s5, $s4             # Add base address
    
    # Store pixel
    sw $s3, 0($s4)
    
    addi $t7, $t7, 1              # X++
    j gameOverColLoop
    
gameOverNextRow:
    addi $t6, $t6, 1              # Y++
    j gameOverRowLoop
    
gameOverDone:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function to clear the entire screen with black
clearScreenBlack:
    lw $t1, ADDR_DSPL       # Get display base address
    li $t2, 0x000000        # Black color
    li $t3, 0               # Y counter
    li $t4, 32              # Display width
    li $t5, 64              # Display height
    
clearScreenRowLoop:
    bge $t3, $t5, clearScreenDone    # If Y >= height, done
    li $t6, 0                        # X counter
    
clearScreenColLoop:
    bge $t6, $t4, clearScreenNextRow # If X >= width, next row
    
    # Calculate display buffer address
    mul $t7, $t3, $t4             # Y * width
    add $t7, $t7, $t6             # + X
    sll $t7, $t7, 2               # * 4 bytes
    add $t8, $t1, $t7             # Add base address
    
    # Store black pixel
    sw $t2, 0($t8)
    
    addi $t6, $t6, 1              # X++
    j clearScreenColLoop
    
clearScreenNextRow:
    addi $t3, $t3, 1              # Y++
    j clearScreenRowLoop
    
clearScreenDone:
    jr $ra

# Game over input handling
gameOverInput:
    lw $t1, ADDR_KBRD
    lw $t2, 0($t1)
    beq $t2, $zero, gameOverNoInput
    lw $t2, 4($t1)
    
    # Check for 'r' key to restart
    li $t3, 0x72        # 'r' key
    beq $t2, $t3, restartGame
    
    # Check for 'q' key to quit
    li $t3, 0x71        # 'q' key
    beq $t2, $t3, exitGame
    
gameOverNoInput:
    jr $ra
    
restartGame:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)
    # Reset game state
    sw $zero, GameState
    
    # Clear the game board
    jal initalizeGameBoard
    jal drawWalls
    
    # Reset tetromino position
    li $t1, 4
    sw $t1, TetrominoX
    li $t1, 1
    sw $t1, TetrominoY
    li $t1, 0
    sw $t1, TetrominoRotation
    
    # Reset gravity
    sw $zero, GravityTimer
    li $t1, 30
    sw $t1, GravityDelay
    
    # Spawn new piece
    jal spawnNewPiece
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra