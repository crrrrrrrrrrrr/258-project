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





##############################################################################
# Mutable Data
##############################################################################
columnColor: .space 12
columnArray: .word 0:312 # 312 = 6 * 13
##############################################################################
# Code
##############################################################################
	.text
	.globl main
    # Run the game.
main:
la $s1, columnColor #$ s1 - Array hold the colors of current column
add $s2, $zero, 6 #$s2 - Initial X offset
add $s3, $zero, 4 #$s3 - Initial Y offset
la $s4, columnArray

#Draw top border
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 392
    addi $t1, $zero, 7 #length of the row
    li $t2 0x808080 #color for the border
drawBorderTop:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bgez $t1, drawBorderTop
    
#Draw bottom border
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 2184
    addi $t1, $zero, 7 #length of the row
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
    addi $t0, $t0, 420
    addi $t1, $zero, 14 #length of the column
    li $t2 0x808080 #color for the border
drawBorderRight:
    sw $t2, 0($t0)
    addi $t0, $t0, 128
    addi $t1, $t1, -1
    bgez $t1, drawBorderRight

	
#Draw initial column
resetDrawColumn:
    li $s2 6
    li $s3 4
    lw $t0, ADDR_DSPL
    mul $t4, $s2, 4 #x position
    mul $t5, $s3, 128 #y posiiton
    add $t0, $t0, $t4 #Add these offset to initial position
    add $t0, $t0, $t5
    addi $t1, $zero, 2 # 3 cells
    la $t2 colors
    la $s1, columnColor
drawColumn: 
    #Generate a random number
    li $v0, 42		# choose a random number
    li $a0, 0
	li $a1, 6
	syscall
	mul $t3, $a0, 4 #Get the address offset
	add $t7, $t2, $t3 #Move the pointer to the color we want
	lw $t6, 0($t7) # $t6 - the random color we got
	sw $t6, 0($t0) #Draw the color at current position $t0 points to
	sw $t6, 0($s1) #Save the color in a column array $s1
	addi $t1, $t1, -1
	addi $t0, $t0, 128
	addi $s1, $s1, 4
	bgez $t1 drawColumn
j game_loop
	
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
    j game_loop
    
w_shuffle:
    jal CheckBelow
    lw $t0, ADDR_DSPL
    la $s1, columnColor
    
    #load the current 3 colors from columnColor
    lw $t2, 0($s1) #load first color
    lw $t3, 4($s1) #load second color
    lw $t4, 8($s1) #load third color
    
    #Update the shuffled columnColor
    sw $t4, 0($s1) #New first color
    sw $t2, 4($s1) #New second color
    sw $t3, 8($s1) #New third color
    
    #Draw the new colors on the board
    mul $t5, $s2, 4 #x position
    mul $t6, $s3, 128 #y posiiton
    add $t0, $t0, $t5 #Add these offset to initial position
    add $t0, $t0, $t6 #Add these offset to initial position
    
    la $s1, columnColor
    sw $t4, 0($t0)
    addi $t0, $t0, 128
    sw $t2, 0($t0)
    addi $t0, $t0, 128
    sw $t3, 0($t0)
    j game_loop
    
a_moveLeft:
    jal CheckBelow
    jal checkLeftBorder
    jal eraseColumn
    addi $s2, $s2, -1
    j moveColumn
    
s_moveDown:
    jal CheckBelow
    jal eraseColumn
    addi $s3, $s3, 1
    j moveColumn
    
d_moveRight:
    jal CheckBelow
    jal checkRightBorder
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
  
#Check borders
checkLeftBorder:
    beq $s2, 3, game_loop
    jr $ra
    
checkBottomBorder:
    beq $s3, 14, game_loop
    jr $ra
    
checkRightBorder: 
    beq $s2, 8, game_loop
    jr $ra
    
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

#Check if there is something below
CheckBelow:
    la $t3, columnArray
    addi $t0, $s3, -1 #Check for the cell below bottom cell #t0 = $s3 - 4 + 3
    mul $t1, $t0, 6 # y * width
    add $t1, $t1, $s2 # y * width + x
    add $t1, $t1, -6 # y * width + x
    mul $t1, $t1, 4 # multiply by 4 bytes
    bge $t1, 300, recordColumn #Reach the bottom
    add $t3, $t3, $t1
    lw $t2, 0($t3) #load the color at the index in columnArray
    bne $t2, 0,recordColumn
    jr $ra

#Fix the column when it reach the bottom and record it
recordColumn:
    la $t1, columnColor
    li $t2, 2 #3 cells
    la $s4, columnArray
    add $t6, $s3, -4 #Deduct the initial offeset
recordColumnLoop: #$S2 x-offset   $s3 y-offset
    #Compute the index to store in columnArray
    mul $t3, $t6, 6 # y * width
    add $t3, $t3, $s2 # y * width + x
    add $t3, $t3, -6 #Deduct the initial x offeset
    mul $t3, $t3, 4 # multiply by 4 bytes
    # add $t4, $s4, $t3 #Move the pointer to the index
    #Write the color to columnArray
    add $t7, $s4, $t3
    lw $t5, 0($t1) #load color of this cell from colorArray to $t4
    sw $t5, 0($t7) #Record the color to columnArray
    #Increment for next cell
    addi $t6, $t6, 1
    addi $t2, $t2, -1
    addi $t1, $t1, 4
    bgez $t2, recordColumnLoop
j resetDrawColumn


    
    