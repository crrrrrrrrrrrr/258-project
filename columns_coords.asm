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
ADDR_DSPL: .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD: .word 0xffff0000

# .word means that it has 4 bytes per unit, so 8x4 = 8 spaces for a word, each word w/4 bytes
colour_array: .word 8 # array of 6 possible colours plus grey, and black
col_array: .word 8   # array of the x,y coords of the top pixel, then the 3 colours in the column, going from top to bottom 
# col_array = [x-coord, y-coord, pixel1 colour, pixel2 colour, pixel3 colour]
     
##############################################################################
# Mutable Data
##############################################################################

############# need to update this to match paper version

# $a0 = x coord of start of line
# $a1 = y coord of start of line
# $a2 = length of line, OR starting address of col pixel 1
# $a3 = offset from array location (using when drawing coloured column)

# $t0 = address of keyboard 
# $t1 = address of the top left corner of the bitmap display
# $t2 = address of array of colours
# $t3 = address of array of current column colours
# $t4 = 
# $t5 = colour grey/ temp colour storing to load into colour array
# $t6 = address of temp copy of array of current column colours AND locations
# $t7 = the stopping condition for the end of the line
# $t8 = load first word from keyboard
# $t9 = temp COPY (which can be manipulated) of bitmap address, 
# ^(which after initialisation should be the BOTTOM of the 3 pixel col)

# $v1 = temp COPY of col array address

##############################################################################
# Code
##############################################################################
	.text
	lw $t0, ADDR_KBRD   # $t0 = base address for keyboard
    lw $t1, ADDR_DSPL    # $t1 = base address for bitmap display
    la $t2, colour_array # $t2 = address of array of colours
    la $t3, col_array   # $t3 = address for array of column colours and address (in order respectively)
    
########################################################################
# setting up the array of 6 colours

addi $t5, $zero, 0xff0000 # load red colour 
sw $t5, 0($t2) #store colour red
addi $t5, $zero, 0xff6600 # load orange colour 
sw $t5, 4($t2) #store colour orange
addi $t5, $zero, 0xffcc00 # load yellow colour 
sw $t5, 8($t2) #store colour yellow
addi $t5, $zero, 0x00cc00 # load green colour 
sw $t5, 12($t2) #store colour green
addi $t5, $zero, 0x3399ff # load blue colour 
sw $t5, 16($t2) #store colour blue
addi $t5, $zero, 0x9933ff # load purple colour 
sw $t5, 20($t2) #store colour purple
addi, $t5, $zero, 0x808080 # load GREY colour (only used for border!)
sw $t5, 24($t2) #store colour GREY
addi, $t5, $zero, 0x000000 # load BLACK colour (only used for border!)
sw $t5, 28($t2) #store colour BLACK

########################################################################
    
	.globl main

    # Run the game.

main:
    # Initialize the game
    ####################################################################################
    # draw border and starting col
        
    # draw top line
    addi $a0, $zero, 3
    addi $a1, $zero, 2
    addi $a2, $zero, 8
    jal set_starting_pixel_location
    jal draw_hor_line
    
    # draw bottom line
    addi $a0, $zero, 3
    addi $a1, $zero, 18
    addi $a2, $zero, 8
    jal set_starting_pixel_location
    jal draw_hor_line
    
    # draw left edge
    addi $a0, $zero, 3
    addi $a1, $zero, 2
    addi $a2, $zero, 17
    jal set_starting_pixel_location
    jal draw_vert_line
    
    # draw right edge
    addi $a0, $zero, 10
    addi $a1, $zero, 2
    addi $a2, $zero, 17
    jal set_starting_pixel_location
    jal draw_vert_line
    
    # painting the 3 pixels for the coloured column, need to loop 3 times
    
    jal generate_rand_colours # general random colours (and store them in the col array in the appropriate spots)
    # now i have 3 random colours in my columns array at the indices 0, 2, 4 for pixel 1 2, 3 respectively
    j set_starting_col_location

#######################################################################################
keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    # 1b. Check which key has been pressed
    beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
    beq $a0, 0x61, respond_to_A     # check if a is pressed
    beq $a0, 0x64, respond_to_D     # check if d is pressed
    beq $a0, 0x73, respond_to_S     # check if s is pressed
    beq $a0, 0x77, respond_to_W     # check if w is pressed

    li $v0, 1                       # ask system to print $a0
    syscall
    j game_loop

respond_to_W:                       # column must rotate (each colour moves DOWN 1)
	# load third colour into $t7
	lw $t7, 16($t3)
	# load second colour into $t5
	lw $t5, 8($t3)
	# store second colour in 16 position
	sw $t5, 16($t3)
	# load first colour 
	lw $t5, 0($t3)
	# store first colour in 8 position
	sw $t5, 8($t3)
	# store third colour in 0 position 
	sw $t7, 0($t3)
	
	# initialise $t9 so it can draw the new column correctly
	lw $t9, 4($t3)
	jal draw_col
	j game_loop
	
respond_to_Q:
	li $v0, 10                      # Quit gracefully
	syscall

respond_to_D:
    # if already at edge, don't go right more (collision)
    
    # load x coord
    lw $t7, 0($t3)
    
    # add 1 to x coord
    addi $t7, $t7, 1
    
    # store new x cord
    sw $t7, 0($t3)
    
    # draw new col
    jal draw_col
    
    # return to game loop
    j game_loop
    
respond_to_A:
    # if already at edge, don't go right more (collision)
    
    # load x coord
    lw $t7, 0($t3)
    
    # add -1 to x coord
    addi $t7, $t7, -1
    
    # store new x cord
    sw $t7, 0($t3)
    
    # draw new col
    jal draw_col
    
    # return to game loop
    j game_loop 

respond_to_S:
    # if already at edge, don't go right more (collision)
    
    # load y coord
    lw $t7, 4($t3)
    
    # add 1 to y coord
    addi $t7, $t7, 1
    
    # store new x cord
    sw $t7, 4($t3)
    
    # draw new col
    jal draw_col
    
    # return to game loop
    j game_loop
    
####################################################################################################################

set_starting_pixel_location: # shifting the original bitmap display location to the starting location for drawing
    sll $a0, $a0, 2     # shift left 2 to multiply x-coord by 4 to get next pixel
    add $t9, $t1, $a0   # add the x offset from $a0 to $t0
    sll $a1, $a1, 7     # shifting left 7 to multiply the y-coord by 128 to get new row
    add $t9, $t9, $a1   # add vertical offset to starting location 
    jr $ra # return, now that $t9 is the right address for starting pixel

set_starting_col_location:
    addi $a0, $zero, 6 # position for the middle of the top of the box
    addi $a1, $zero, 3
    # set starting address for top pixel 
    sw $a0, 0($t3)  # store x coord
    sw $a1, 4($t3)  # store y coord
    j draw_col # draw the column with the generated colours, and the starting position

draw_hor_line:
    # new additions: drawing a line of pixels
    sll $a2, $a2, 2   # set length of line
    lw $t5, 24($t2) # get colour GREY
    # make a loop to draw a line
    add $t7, $t9, $a2
    draw_hor_loop_start: 
        beq $t7, $t9, draw_hor_loop_end # if t0 has reached stopping condition, then stop
        sw $t5, 0($t9) # paint the current pixel red
        addi $t9, $t9, 4 # increment the memory address, (move $t0 to the next pixel)
        j draw_hor_loop_start
    draw_hor_loop_end: 
    
    jr $ra # return to the calling program
    
draw_vert_line:
    # new additions: drawing a line of pixels
    sll $a2, $a2, 7   # set length of line ** different than horizontal
    lw $t5, 24($t2) # get colour GREY
    # make a loop to draw a line
    add $t7, $t9, $a2
    draw_vert_loop_start: 
        beq $t7, $t9, draw_vert_loop_end # if t0 has reached stopping condition, then stop
        sw $t5, 0($t9) # paint the current pixel red
        addi $t9, $t9, 128 # increment the memory address, (move $t0 to the next ROW)
        j draw_vert_loop_start
    draw_vert_loop_end: 
    
    jr $ra # return to the calling program
    
    
generate_rand_colours: 
    addi $t8, $t3, 8       # initialise copy of col array address, to the 3rd element (which is the first colour)
    addi $t7, $t8, 12       # stopping condition (if alreadying generated 3 pixel colours 
    rand_loop_start:
        beq $t7, $t8, rand_loop_end # stop if done drawing all 3 coloured pixels
        
        li $v0, 42          # pick a random colour
        li $a0, 0           # range from 0 to 6 EXclusive
        li $a1, 6
        syscall             # after this, the return value is in $a0
        
        sll $a3, $a0, 2     # index multiplied by 4  (to get offset value from start of colours array)
        
        # get memory address of new colour (from start of colours array at $t2)
        add $t6, $t2, $a3       # new address of colour array = # starting address of colours array + offset
        lw $t5, 0($t6)          # load colour (the element at address $t6) into $t5
            
        sw $t5, 0($t8)      # store colour used in array for col colours and address
        add $t8, $t8, 4     # increment to next space to store colour
        
        j rand_loop_start
    rand_loop_end:
    jr $ra

draw_col: # function to draw the 3 pixel column, with 3 random colours from the 6 available
    add $t8, $t3, $zero # initialise copy of col array address 
    add $t7, $zero, $zero # intialise counter to 0 (to start)
    
    # set starting address for top pixel 
    lw $a0, 0($t3)  # load x coord
    lw $a1, 4($t3)  # load y coord
    
    jal set_starting_pixel_location 
    
    addi $t8, $t8, 8  # re-initialise $t8 to be the first colour, so that it can be used for column colours
    col_loop_start: 
        beq $t7, 3, col_loop_end # stop if done drawing all 3 coloured pixels
        
        lw $t5, 0($t8) # load colour from the column array
        sw $t5, 0($t9) # paint pixel with that colour

        addi $t8, $t8, 4    # increment column array address
        addi $t7, $t7, 1    # increment counter
        addi $t9, $t9, 128  # increment bitmap display address
        j col_loop_start
    col_loop_end:
    
    j game_loop  # can't just return, because nested function calls, so just jump directly
    
############################################################################################################

done_column: # if collision w bottom or on top of other gems, 
        # then save that column's colours and locations to mega array
        # check if any 3+ in a row
        # then generate new column and continue
        j respond_to_Q # exit for now

############################################################################################################

game_loop:
    # stopping condition for the updating_loop (counting to 100 before gravity pulls down)
    addi $t7, $zero, 10
    add $v1, $zero, $zero # intialise incrementer to 0
    updating_loop_start:
    beq $t7, $v1, updating_loop_end #if counter reaches 100, then exit loop
    # 1a. Check if key has been pressed
    lw $t5, 0($t0)                  # Load first word from keyboard
    beq $t5, 1, keyboard_input      # If first word 1, key is pressed
    
    # 2a. Check for collisions
    check_collisions:
    
    # check if it has reached the bottom
    # load bitmap display address of the last pixel in the column
    lw $t9, 20($t3)
    # stopping condition which is address=start + 128*17= start+2176 which means that it is at the bottom
    addi, $t4, $t1, 2176
    sub $t4, $t9, $t4       # check if 20($t3) - ($t1 + 2176) > 0 
    bgtz $t4, done_column
    
    # else, continue
    
    # go to function to check if collision
        # check if collision with edges
        # check if collision with bottom
        # go to done_column
        # check if collision with other gems
        # go to done column
    
    
	# 2b. Update locations (capsules)
	# 3. Draw the screen
    
    
    # 4. Sleep
	li $v0, 32     # operation to suspend program
    li $a0, 20    # number of milliseconds to wait
    syscall    # sleep
    
    addi $v1, $v1, 1 # increment counter
    j updating_loop_start
    updating_loop_end:
    
	
	# shift down 1 block to do gravity
	jal respond_to_S


    # 5. Go back to Step 1
    j game_loop

