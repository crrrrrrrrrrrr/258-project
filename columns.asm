################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Columns.
#
# Student 1: Name, Student Number
# Student 2: Name, Student Number (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       TODO
# - Unit height in pixels:      TODO
# - Display width in pixels:    TODO
# - Display height in pixels:   TODO
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
colors: .word 0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xffaa00, 0xaa00ff
columnColor: .space 12



##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main
    # Run the game.
main:
la $s1, columnColor
add $s2, $zero, 6 #Initial X offset
add $s3, $zero, 4 #Initial Y offset


#Draw top border
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 392
    addi $t1, $zero, 8 #length of the row
    li $t2 0x808080 #color for the border
drawBorderTop:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bgez $t1, drawBorderTop
    
#Draw bottom border
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 2184
    addi $t1, $zero, 8 #length of the row
    li $t2 0x808080 #color for the border
drawBorderBottom:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bgez $t1, drawBorderBottom
    
#Draw left border
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 392
    addi $t1, $zero, 14 #length of the column
    li $t2 0x808080 #color for the border
drawBorderLeft:
    sw $t2, 0($t0)
    addi $t0, $t0, 128
    addi $t1, $t1, -1
    bgez $t1, drawBorderLeft
    
#Draw right border
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 424
    addi $t1, $zero, 14 #length of the column
    li $t2 0x808080 #color for the border
drawBorderRight:
    sw $t2, 0($t0)
    addi $t0, $t0, 128
    addi $t1, $t1, -1
    bgez $t1, drawBorderRight
    
#Draw a column
    lw $t0, ADDR_DSPL
    mul $t4, $s2, 4 #x position
    mul $t5, $s3, 128 #y posiiton
    add $t0, $t0, $t4 #Add these offset to initial position
    add $t0, $t0, $t5
    addi $t1, $zero, 2 # 3 cells
    la $t2 colors
drawColumn: 
    #Generate a random number
    li $v0, 42		# choose a random number
    li $a0, 0
	li $a1, 6
	syscall
	
	#Get the random color
	mul $t3, $a0, 4
	add $t7, $t2, $t3 
	lw $t6, 0($t7) #the random color we got
	sw $t6, 0($t0) #Draw the color
	sw $t6, 0($s1) #Save the color in a column array
	addi $t1, $t1, -1
	addi $t0, $t0, 128
	addi $s1, $s1, 4
	bgez $t1 drawColumn
	
#Draw the column in new position
moveColumn:
    la $s1, columnColor 
    addi $t1, $zero, 2 # 3 cells
    lw $t0, ADDR_DSPL
    mul $t4, $s2, 4 #x position
    mul $t5, $s3, 128 #y posiiton
    add $t0, $t0, $t4 #Add these offset to initial position
    add $t0, $t0, $t5
moveColumnLoop:
	add $t7, $s1, $t3 
	lw $t6, 0($s1)
	sw $t6, 0($t0) #Draw the color
    addi $t1, $t1, -1
    addi $t0, $t0, 128
    addi $s1, $s1, 4
    bgez $t1 moveColumnLoop

    
    
game_loop:
    # 1a. Check if key has been pressed
    lw $t1, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t1)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    bne  $t8, 1, game_loop
keyboard_input:                     # A key is pressed
    lw $a0, 4($t1)                  # Load second word from keyboard
    beq $a0, 0x77, w_shuffle     # Check if the key w was pressed
    beq $a0, 0x61, a_moveLeft     # Check if the key a was pressed
    beq $a0, 0x73, s_moveDown     # Check if the key s was pressed
    beq $a0, 0x64, d_moveRight     # Check if the key d was pressed
    beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed

    li $v0, 1                       # ask system to print $a0
    syscall
    b main
    
w_shuffle:

a_moveLeft:
    jal eraseColumn
    addi $s2, $s2, -1
    j moveColumn
s_moveDown:
    jal eraseColumn
    addi $s3, $s3, 1
    j moveColumn
    
d_moveRight:  
    jal eraseColumn
    addi $s2, $s2, 1
    j moveColumn
respond_to_Q:
	li $v0, 10                      # Quit gracefully
	syscall

    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
    
#Erase the old column

eraseColumn:
    lw $t0, ADDR_DSPL
    mul $t4, $s2, 4 #x position
    mul $t5, $s3, 128 #y posiiton
    add $t0, $t0, $t4 #Add these offset to initial position
    add $t0, $t0, $t5
    addi $t1, $zero, 2 # 3 cells
eraseLoop:
    sw $zero, 0($t0) #Draw the color
    addi $t1, $t1, -1
	addi $t0, $t0, 128
	bgez $t1 eraseLoop
	jr $ra
