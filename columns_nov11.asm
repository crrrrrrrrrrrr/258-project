################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Columns.
#
# Student 1: Cynthia Rong, 1011129832
# Student 2: Jasmine, Student Number (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
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

     A: .space 6 # array of 6 possible colours
##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	li $t2, 0x808080 #grey colour
	li $t3, 0x000000 # black
    lw $t1, ADDR_DSPL 
	.globl main

    add $t9, $t1, $zero
    # Run the game.
main:
    # Initialize the game
    
    
    # draw grey borders
    
    # draw pixels
    addi $t7, $zero, 0x9933ff
    sw $t7, 0($t9) # paint pixel with that colour
    
    
    ## quit if press q
    li 		$v0, 32
	li 		$a0, 1
	syscall

    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    b main

keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
    beq $a0, 0x61, respond_to_A     # check if A is pressed
    beq $a0, 0x64, respond_to_D     # check if D is pressed
    beq $a0, 0x73, respond_to_S     # check if S is pressed

    li $v0, 1                       # ask system to print $a0
    syscall
    b main

respond_to_Q:
	li $v0, 10                      # Quit gracefully
	syscall

respond_to_D:
    # erase previous pixel
    sw $t3, 0($t9)
    addi $t9, $t9, 4
    sw $t7, 0($t9)
    
    # redraw
    # paint pixel with that colour
    b main
    
respond_to_A:
    # erase previous pixel
    sw $t3, 0($t9)
    subi $t9, $t9, 4
    sw $t7, 0($t9)
    
    # redraw
    # paint pixel with that colour
    b main

respond_to_S:
    # erase previous pixel
    sw $t3, 0($t9)
    addi $t9, $t9, 128
    sw $t7, 0($t9)
    
    # redraw
    # paint pixel with that colour
    b main
    

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	
	# draw starting 3 pixels
	
	# 4. Sleep
	

    # 5. Go back to Step 1
    j game_loop
