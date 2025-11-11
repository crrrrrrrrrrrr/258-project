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

##############################################################################
# Code
##############################################################################
	.text
	.globl main
    # Run the game.
main:
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
    
#Draw Preview column
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 728
    addi $t1, $zero, 2 # 3 cells
    la $t2 colors
drawPreview: 
    #Generate a random number
    li $v0, 42		# choose a random number
    li $a0, 0
	li $a1, 6
	syscall
	
	#Get the random color
	mul $t3, $a0, 4
	add $t5, $t2, $t3 
	lw $t4, 0($t5) #the random color we got
	sw $t4, 0($t0)
	addi $t1, $t1, -1
	addi $t0, $t0, 128
	bgez $t1 drawPreview
	
	
	
	
    
        
    
    
game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
