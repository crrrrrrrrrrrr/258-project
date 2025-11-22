################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Columns.
#
# Student 1: Cynthia Rong, 1011129832
# Student 2: Jasmine Li, 1008825407
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
colors: .word 0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xffaa00, 0xaa00ff
paused_array:  
0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
game_array: 
0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 
0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
over_array:
0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
retry_array:
0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 

##BGM data
pitches:.word 57, 93, 52, 88, 60, 52, 88, 59, 95, 52, 88, 93, 57, 52, 88, 56, 92, 52, 88, 95, 59, 52, 88, 57, 93, 52, 88, 56, 92, 52, 88, 91, 55, 50, 86, 59, 95, 50, 86, 93, 57, 50, 86, 55, 91, 50, 86, 54, 90, 50, 86, 55, 91, 50, 86, 93, 57, 50, 86, 55, 91, 86, 50, 93, 81, 57, 45, 88, 52, 76, 60, 40, 40, 76, 52, 88, 81, 45, 59, 52, 88, 84, 48, 93, 88, 47, 88, 83, 80, 59, 44, 88, 40, 56, 92, 40, 76, 52, 88, 80, 59, 44, 88, 91, 79, 43, 55, 50, 83, 59, 47, 50, 47, 86, 57, 50, 86, 50, 95, 83, 59, 47, 86, 50, 47, 86, 50, 54, 78, 42, 50, 86, 91, 83, 47, 47, 86, 50, 60, 57, 45, 52, 40, 81, 45, 47, 88, 83, 59, 95, 48, 79, 88, 47, 83, 45, 81, 91, 76, 52, 40, 56, 47, 59, 52, 59, 80, 44, 59, 52, 44, 62, 52, 40, 71, 74, 40, 59, 74, 38, 50, 86, 54, 50, 90, 86, 35, 86, 83, 47, 45, 57, 47, 55, 35, 83, 45, 81, 42, 83, 78, 74, 38, 90, 57, 45, 81, 78, 90, 45, 81, 57, 42, 38, 50, 78, 45, 52, 60, 45, 57, 59, 95, 47, 47, 59, 64, 40, 95, 59, 56, 40, 52, 88, 59, 56, 95, 44, 44, 56, 56, 44, 59, 95, 55, 59, 43, 95, 60, 57, 62, 40, 59, 52, 40, 56, 88, 84, 60, 57, 48, 59, 62, 79, 45, 60, 45, 57, 57, 93, 42, 54, 86, 60, 57, 45, 78, 57, 50, 62, 59, 47, 57, 60, 86, 60, 57, 83, 62, 47, 55, 59, 95, 96, 60, 62, 56, 92, 57, 93, 59, 95, 96, 60, 54, 90, 59, 95, 91, 47, 83, 55, 79, 88, 40, 57, 38, 55, 54, 90, 52, 40, 76, 76, 90, 54, 42, 50, 38, 40, 52, 76, 76, 42, 90, 38, 50, 43, 59, 62, 59, 43, 55, 95, 60, 57, 45, 81, 57, 54, 45, 95, 59, 60, 62, 47, 56, 92, 45, 81, 57, 95, 78, 59, 74, 54, 42, 90, 78, 76, 40, 55, 91, 95, 83, 47, 59, 93, 57, 76, 55, 91, 54, 90, 93, 45, 81, 57, 78, 54, 90, 40, 52, 76, 57, 76, 54, 42, 90, 38, 50, 52, 40, 76, 81, 76, 90, 54, 42, 50, 40, 52, 76, 76, 42, 45, 52, 57, 81, 45, 53, 41, 91, 88, 52, 55, 50, 86, 53, 88, 85, 49, 33, 52
durations: .word 196, 209, 196, 255, 209, 196, 243, 209, 220, 185, 255, 243, 139, 175, 152, 209, 232, 185, 232, 220, 209, 185, 266, 243, 232, 196, 162, 220, 221, 196, 162, 185, 209, 196, 220, 220, 243, 196, 209, 220, 196, 196, 256, 187, 210, 196, 209, 196, 220, 196, 360, 209, 232, 196, 209, 220, 209, 198, 350, 209, 232, 209, 209, 173, 196, 209, 220, 173, 196, 173, 185, 209, 185, 162, 162, 185, 185, 196, 233, 198, 243, 209, 209, 209, 209, 325, 185, 162, 162, 185, 209, 173, 163, 198, 221, 173, 162, 173, 185, 173, 173, 209, 162, 162, 185, 220, 209, 196, 173, 196, 255, 173, 196, 185, 198, 209, 173, 220, 162, 173, 196, 266, 196, 209, 209, 187, 198, 185, 209, 347, 173, 336, 162, 209, 209, 196, 196, 209, 185, 220, 220, 196, 185, 162, 173, 163, 185, 244, 185, 185, 220, 232, 185, 185, 243, 162, 173, 209, 151, 151, 151, 209, 209, 266, 232, 336, 175, 175, 162, 209, 151, 209, 185, 209, 232, 173, 162, 209, 173, 185, 173, 278, 139, 139, 185, 244, 185, 220, 162, 185, 185, 209, 139, 162, 151, 209, 185, 209, 243, 163, 198, 139, 162, 139, 173, 173, 371, 173, 162, 162, 173, 196, 151, 151, 173, 173, 407, 185, 151, 232, 220, 173, 266, 371, 476, 220, 1, 220, 243, 360, 185, 173, 151, 162, 173, 220, 173, 476, 196, 278, 151, 196, 173, 175, 139, 151, 173, 196, 162, 173, 151, 196, 278, 151, 173, 162, 185, 162, 173, 173, 441, 196, 196, 209, 266, 187, 187, 221, 139, 196, 196, 209, 173, 185, 278, 336, 151, 162, 162, 185, 209, 209, 185, 196, 175, 173, 173, 347, 986, 1114, 1835, 232, 220, 162, 196, 162, 196, 209, 209, 232, 198, 221, 173, 196, 185, 325, 196, 232, 173, 209, 209, 243, 196, 290, 151, 139, 210, 280, 336, 453, 196, 139, 255, 220, 151, 139, 162, 151, 185, 198, 187, 256, 220, 151, 173, 196, 173, 173, 209, 266, 151, 278, 173, 209, 173, 196, 209, 498, 522, 917, 986, 173, 220, 185, 173, 196, 187, 198, 196, 209, 220, 173, 173, 173, 185, 162, 185, 185, 185, 173, 162, 185, 220, 162, 185, 185, 209, 185, 210, 196, 196, 209, 185, 232, 162, 220, 209, 220, 209, 185, 220, 220, 232, 255, 151, 209, 140, 140, 163, 185, 173, 196, 196, 266, 162, 209, 139, 139, 139, 196, 196, 196, 243, 187, 139, 476, 975, 162, 173, 616, 162, 1789, 302, 453, 453, 487, 453, 476, 498, 498, 498, 1637, 336, 1962
instruments:.word 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16,16, 16, 16, 16, 16, 16, 16, 16, 16, 16
velocity:.word 88, 88, 82, 82, 84, 79, 79, 93, 93, 92, 88, 88, 88, 91, 91, 83, 83, 82, 82, 82, 80, 91, 88, 88, 88, 92, 92, 81, 81, 94, 94, 82, 82, 81, 81, 81, 81, 80, 80, 85, 80, 85, 77, 77, 77, 82, 82, 80, 80, 82, 76, 76, 76, 81, 81, 86, 79, 79, 77, 77, 77, 81, 81, 87, 87, 87, 87, 88, 88, 75, 75, 75, 77, 77, 77, 77, 77, 77, 88, 80, 84, 84, 84, 84, 90, 82, 101, 101, 81, 81, 81, 68, 80, 80, 80, 78, 78, 78, 78, 81, 81, 81, 71, 86, 86, 86, 86, 86, 88, 88, 88, 84, 84, 84, 83, 81, 81, 81, 91, 91, 91, 91, 90, 90, 90, 80, 80, 80, 80, 75, 75, 84, 84, 84, 84, 93, 93, 93, 96, 96, 96, 89, 89, 86, 86, 85, 85, 61, 80, 80, 80, 80, 82, 82, 82, 77, 77, 77, 81, 81, 81, 90, 90, 90, 92, 83, 83, 83, 94, 94, 89, 89, 85, 85, 85, 87, 90, 90, 79, 79, 79, 80, 80, 80, 80, 62, 92, 92, 85, 85, 99, 99, 63, 63, 63, 63, 98, 98, 98, 92, 92, 59, 59, 78, 78, 78, 82, 82, 85, 85, 85, 85, 89, 89, 89, 89, 88, 88, 89, 89, 89, 84, 84, 84, 93, 93, 79, 79, 79, 87, 87, 76, 76, 76, 91, 91, 82, 82, 90, 88, 87, 87, 87, 87, 88, 88, 88, 88, 89, 89, 96, 96, 82, 82, 82, 82, 82, 84, 84, 84, 94, 94, 94, 94, 88, 94, 94, 94, 96, 96, 96, 96, 83, 86, 86, 76, 76, 76, 76, 96, 96, 96, 88, 88, 81, 86, 86, 81, 81, 81, 81, 89, 89, 82, 82, 81, 88, 88, 84, 84, 87, 87, 82, 82, 83, 78, 78, 78, 75, 75, 75, 86, 84, 66, 66, 66, 85, 85, 86, 86, 90, 90, 90, 83, 79, 79, 79, 78, 78, 84, 84, 84, 84, 71, 71, 79, 79, 95, 77, 84, 84, 84, 84, 84, 95, 95, 95, 91, 91, 91, 91, 87, 87, 71, 80, 80, 81, 81, 72, 72, 72, 75, 75, 75, 80, 76, 76, 76, 76, 66, 66, 66, 66, 79, 79, 79, 79, 80, 80, 68, 68, 68, 79, 79, 84, 84, 84, 84, 82, 74, 74, 84, 84, 66, 83, 83, 70, 70, 70, 79, 79, 83, 83, 76, 85, 85, 68, 68, 68, 70, 82, 82, 82, 81, 71, 90, 90, 77, 77, 77, 80, 80, 94, 94, 94, 94, 94, 94, 94, 97, 97, 79, 79, 79
length:.word 434

##Sound Effect data
# ----- Remove -----
remove_pitches: .word 84, 88, 91, 96
remove_durations:.word 60, 60, 60, 120
remove_instruments:.word 81
remove_velocity:.word 90, 100, 110, 120
remove_length: 4
# ----- Drop -----
drop_pitches: .word 56
drop_durations:.word 750
drop_instruments:.word 116
drop_velocity:.word 100
drop_length: 1
# ----- Shuffle -----
shuffle_pitches: .word 57, 60
shuffle_durations:.word 50, 50
shuffle_instruments:.word 13, 13
shuffle_velocity:.word 100, 100
shuffle_length: 2
# ----- Gameover -----
gameover_pitches: .word 76, 72, 67, 60
gameover_durations:.word 200, 200, 250, 400
gameover_instruments:.word 1 
gameover_velocity:.word 110, 100, 90, 80
gameover_length: 4
##############################################################################
# Mutable Data
##############################################################################
currentColumn: .space 12
previewColumn: .space 12
columnArray: .word 0:78 #6*13
removeArray: .word 0:78
gravity_count: .word 0 # to keep track of gravity
score: .word 0  # score starts at 0 
music_index: .word 0
music_tick: .word 0
##############################################################################
# Code
##############################################################################
.text
.globl main
main:
    #Initialization
    jal reset
    
    # get input for levels 1,2,3
    
    jal drawBorderTop
    jal drawBorderBottom
    jal drawBorderLeft
    jal drawBorderRight
    jal create1StColumn
    jal createPreview
    jal drawColumn
    j game_loop
    
game_loop: # put the intialisation in a loop
    jal initialise_sleep_counter

    check_settings:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    jal checkKeyBoard
    jal CheckBelow
    jal repaint
    
    # 2a. Check for collisions
    # 2b. Update locations (capsules)
	# 3. Draw the screen
	
	# 4. Sleep
	jal sleep
    jal increment_sleep
    
    
    # shift down 1 block to do gravity
	jal s_moveDown
	# TODO: ^^how to get gravity to still work while player is moving left/right/shuffling
    
    # 5. Go back to Step 1
    j game_loop

##############################################################################
#Draw
##############################################################################
#reset: Reset the arrays and offsets
reset:
    
    # clear current Column (12 bytes)
    clearCurrentColumn:
    la $t1, currentColumn
    lw $zero, 0($t1)
    lw $zero, 4($t1)
    lw $zero, 8($t1)
    
    # clear column array (78 words)
    clearColumnArray: 
    la $t4, columnArray
    addi $t7, $t4, 312  # intiailise stopping condition
    clearPixel_start:
        beq $t4, $t7, clearPixel_end    # end if done  clearing all array elements
        sw $zero, 0($t4)    # store 0 (to clear)
        add $t4, $t4, 4     # increment column array address
        j clearPixel_start
    clearPixel_end:
    
    # reset score, gravity count
    la $t0, score
    sw $zero, 0($t0)
    la $t0, gravity_count
    sw $zero, 0($t0)
    
    la $s1, currentColumn #$ s1 - Array hold the colors of current column
    add $s2, $zero, 6 #$s2 - Initial X offset
    add $s3, $zero, 2 #$s3 - Initial Y offset
    la $s4, columnArray
    jr $ra

#Clear the entire screen to blank
clearScreen:
    lw $t0, ADDR_DSPL
    li $t1, 1024
clearScreen_loop:
    sw $zero, 0($t0)
    addi $t1, $t1, -1
    addi $t0, $t0, 4
    bgez $t1, clearScreen_loop
    jr $ra
    
    
#Draw top border
drawBorderTop:
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 392
    addi $t1, $zero, 7 #length of the row
    li $t2 0x808080 #color for the border
drawBorderTop_loop:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bgez $t1, drawBorderTop_loop
    jr $ra
    
#Draw bottom border
drawBorderBottom:
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 2184
    addi $t1, $zero, 7 #length of the row
    li $t2 0x808080 #color for the border
drawBorderBottom_loop:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bgez $t1, drawBorderBottom_loop
    jr $ra
    
#Draw left border
drawBorderLeft:
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 392
    addi $t1, $zero, 14 #length of the column
    li $t2 0x808080 #color for the border
drawBorderLeft_loop:
    sw $t2, 0($t0)
    addi $t0, $t0, 128
    addi $t1, $t1, -1
    bgez $t1, drawBorderLeft_loop
    jr $ra
    
#Draw right border
drawBorderRight:
    lw $t0 ADDR_DSPL
    addi $t0, $t0, 420
    addi $t1, $zero, 14 #length of the column
    li $t2 0x808080 #color for the border
drawBorderRight_loop:
    sw $t2, 0($t0)
    addi $t0, $t0, 128
    addi $t1, $t1, -1
    bgez $t1, drawBorderRight_loop
    jr $ra
 
drawColumnArray:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    li $s0, 0
drawColumnArray_loop:
    jal drawOneRow
    addi $s0, $s0, 1
    blt $s0, 13, drawColumnArray_loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
drawOneRow:
    lw $t0, ADDR_DSPL
    #Add Y offset to t0
    li  $t1, 4                 # initial Y-offset
    add $t1, $t1, $s0          
    mul $t1, $t1, 128         
    add $t0, $t0, $t1
    
    #Add X offset to t0
    li  $t2, 3              
    mul $t2, $t2, 4            
    add $t0, $t0, $t2          
    
    li $t3, 0
    la $t4, columnArray
drawOneRow_loop:
    #Compute color location in column array
    mul $t5, $s0, 6 #t5 = y*6
    add $t5, $t5, $t3 #t5 = y*6+x
    mul $t5, $t5, 4 #calculate byte
    add $t7, $t4, $t5 #Move to this location in columnArray
    
    lw $t6, 0($t7) #load the color from columnArray
    beq $t6, $zero, next # skip if there is no color
    sw $t6, 0($t0) # draw the color on board
next:
    addi $t0, $t0, 4
    addi $t3, $t3, 1
    blt $t3, 6, drawOneRow_loop
    jr $ra
    
repaint:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal clearScreen
    jal drawBorderTop
    jal drawBorderBottom
    jal drawBorderLeft
    jal drawBorderRight
    jal drawColumnArray
    jal drawPreview
    jal drawColumn
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
#Draw the column in new position
drawPreview:
    la $s1, previewColumn 
    addi $t1, $zero, 2 # 3 cells
    lw $t0, ADDR_DSPL
    li $t4, 652
    add $t0, $t0, $t4 #Add these offset to initial position
    add $t0, $t0, $t5
drawPreview_loop:
	lw $t6, 0($s1)
	sw $t6, 0($t0) #Draw the color
    addi $t1, $t1, -1
    addi $t0, $t0, 128
    addi $s1, $s1, 4
    bgez $t1 drawPreview_loop
    jr $ra
    
#Draw the column in new position
drawColumn:
    la $s1, currentColumn 
    addi $t1, $zero, 2 # 3 cells
    lw $t0, ADDR_DSPL
    mul $t4, $s2, 4 #x position
    mul $t5, $s3, 128 #y posiiton
    add $t0, $t0, $t4 #Add these offset to initial position
    add $t0, $t0, $t5
drawColumn_Loop:
	lw $t6, 0($s1)
	sw $t6, 0($t0) #Draw the color
    addi $t1, $t1, -1
    addi $t0, $t0, 128
    addi $s1, $s1, 4
    bgez $t1 drawColumn_Loop
    jr $ra
    
    

##############################################################################
#Check keyboard inputs
##############################################################################
checkKeyBoard:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    lw $t1, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t1)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    jr $ra
keyboard_input:                     # A key is pressed
    lw $a0, 4($t1)                  # Load second word from keyboard
    beq $a0, 0x77, w_shuffle     # Check if the key w was pressed
    beq $a0, 0x61, a_moveLeft     # Check if the key a was pressed
    beq $a0, 0x73, s_moveDown     # Check if the key s was pressed
    beq $a0, 0x64, d_moveRight     # Check if the key d was pressed
    beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
    beq $a0, 0x70, respond_to_P     # check if the key p was pressed
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
respond_to_P:   # pause the game
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    
    # clear screen
    jal clearScreen
    # display the word paused on the screen
    addi $a0, $zero, 2688       # load starting offset
    la $a1, paused_array    # load array address
    jal display_array 
    
    # enter loop
    pause_start:
    # sleep for delay
    li $v0, 32          # operation to suspend program
    li $a0, 10          # number of milliseconds to wait
    syscall             # sleep
    
    lw $t1, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t1)                  # Load first word from keyboard
    bne $t8, 1, pause_start         # If first word is NOT 1, key is NOT pressed
    # else key is pressed
    lw $a0, 4($t1)                  # Load second word from keyboard
    beq $a0, 0x70, pause_end        # Check if the key p was pressed
    
    j pause_start
    pause_end:      # repaint is handled back in game_loop
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
display_array:         # display the word FROM THE ARRAY on the screen (paused, game over retry)
    lw $t0, ADDR_DSPL
    la $t5, 0xffffff # load colour
    add $t0, $t0, $a0     # add offset to address, so that it prints in the bottom plus whatever
    add $t1, $zero, $a1    # load address of the array
    
    
    # stopping condition, once done 6 rows, 128*5 = 640
    addi $t7, $t0, 768
    draw_array_start:
    beq $t7, $t0, draw_array_end # end if done
    lw $t2, 0($t1)                              # load value from paused array
    bne $t2, 1, increment_array_address        # skip if value is 0
    # else, draw white pixel
    sw $t5, 0($t0)
    
    increment_array_address:
    addi $t0, $t0, 4        # increment display address location
    addi $t1, $t1, 4        # increment array location too
    j draw_array_start
    draw_array_end:
    
    jr $ra   # return 
    
w_shuffle:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal CheckBelow
    bnez $v0, noShuffle #0 is returned, reach the end, no shuffle will be made

    la $s1, currentColumn
    
    #load the current 3 colors from currentColumn
    lw $t2, 0($s1) #load first color
    lw $t3, 4($s1) #load second color
    lw $t4, 8($s1) #load third color
    
    #Update the shuffled currentColumn
    sw $t4, 0($s1) #New first color
    sw $t2, 4($s1) #New second color
    sw $t3, 8($s1) #New third color
    
    jal play_shuffle
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    lw $ra, 0($sp) ##################******************************************
    addi $sp, $sp, 4
    jr $ra
noShuffle:
    lw $ra, 0($sp)#################******************************************
    addi $sp, $sp, 4
    jr $ra #################****************************************** having issues getting stuck here...

    
respond_to_Q:
	li $v0, 10      # Quit gracefully
	syscall
	
a_moveLeft:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal CheckBelow
    jal checkLeftBorder
    bnez $v0, dontMove  # if hit the border, don't move
    addi $s2, $s2, -1
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
s_moveDown:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal CheckBelow
    bnez $v0, reachBottom  # if hit the border, don't move
    addi $s3, $s3, 1
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
d_moveRight:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal CheckBelow
    bnez $v0, dontMove
    jal checkRightBorder
    bnez $v0, dontMove  # if hit the border, don't move
    addi $s2, $s2, 1
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
dontMove:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

##############################################################################
#Check Helpers
##############################################################################
#Check if there is something below
CheckBelow:
    move $t0, $s3
    la $t3, columnArray
    
    addi $t4, $s2, -3 # x
    addi $t5, $s3, -4 # y
    bgt $t0, 13, hasCollision

    # check below bottom gem:
    addi $t5, $t5, 3 # y+3

    mul $t1, $t5, 6 #t1 = y*6
    add $t1, $t1, $t4 #t1 = y*6+x
    mul $t1, $t1, 4 # multiply by 4 bytes
    add $t3, $t3, $t1 #Move the pointer t3 to the current block
    lw $t2, 0($t3) #load the color at the index in columnArray
    bne $t2, 0, hasCollision
    # otherwise no collision
    li $v0, 0 #return 0
    jr $ra
hasCollision: 
    li $v0, 1 #return 1
    jr $ra
    
#Check if the move hit borders
checkLeftBorder:
    beq $s2, 3, hitBorder
    
    la $t0, columnArray
    addi $t1, $s2, -3 # x
    addi $t2, $s3, -4 # y
    
    mul $t3, $t2, 6 # y*6
    add $t3, $t3, $t1 #t1 = y*6+x
    mul $t3, $t3, 4
    add $t3, $t3, $t0 #Move to current cell
    
    lw $t2, -4($t3) #load the color of the cell on the left
    bne $t2, 0, hitBorder
    lw $t2,  20($t3) #load the color of the cell on the left bottom
    bne $t2, 0, hitBorder
    lw $t2,  44($t3) #load the color of the cell on the left bottom bottom
    bne $t2, 0, hitBorder
    
    li $v0, 0 #otherwise return 0
    jr $ra
    
checkBottomBorder:
    beq $s3, 14, hitBorder
    li $v0, 0 #otherwise return 0
    jr $ra
    
checkRightBorder: 
    beq $s2, 8, hitBorder
    
    la $t0, columnArray
    addi $t1, $s2, -3 # x
    addi $t2, $s3, -4 # y
    
    mul $t3, $t2, 6 # y*6
    add $t3, $t3, $t1 #t1 = y*6+x
    mul $t3, $t3, 4
    add $t3, $t3, $t0 #Move to current cell
    
    lw $t2, 4($t3) #load the color of the cell on the right
    bne $t2, 0, hitBorder
    lw $t2, 28($t3) #load the color of the cell on the right bottom
    bne $t2, 0, hitBorder
    lw $t2, 52($t3) #load the color of the cell on the right bottom bottom
    bne $t2, 0, hitBorder
    
    li $v0, 0 #otherwise return 0
    jr $ra
    
hitBorder:
    li $v0, 1 #return 1
    jr $ra
    
##############################################################################
#Game logic
##############################################################################
createPreview:
    la $t0, previewColumn
    li $t1, 2 #3 cells
    la $t2, colors
createPreview_loop:
    #Generate a random number
    li $v0, 42	# choose a random number
    li $a0, 0
	li $a1, 6
	syscall
	
	mul $t3, $a0, 4 #Get the address offset
	add $t4, $t2, $t3 #Move the pointer to the color we want
	lw $t6, 0($t4) # $t6 - load the random color we got from colors
	sw $t6, 0($t0) #Save the color in a preview column array

	addi $t1, $t1, -1
	addi $t0, $t0, 4
	bgez $t1 createPreview_loop
	jr $ra
	
create1StColumn:
    la $t0, currentColumn
    li $t1, 2 #3 cells
    la $t2, colors
create1StColumn_loop:
    #Generate a random number
    li $v0, 42 # choose a random number
    li $a0, 0
 li $a1, 6
 syscall
 
 mul $t3, $a0, 4 #Get the address offset
 add $t4, $t2, $t3 #Move the pointer to the color we want
 lw $t6, 0($t4) # $t6 - load the random color we got from colors
 sw $t6, 0($t0) #Save the color in a column array $s1
 
 addi $t1, $t1, -1
 addi $t0, $t0, 4
 bgez $t1 create1StColumn_loop
 jr $ra
 

createColumn:
    la $t0, currentColumn
    li $t1, 2 #3 cells
    la $t2, colors
    la $t3, previewColumn
    lw $t4, 0($t3)
    sw $t4, 0($t0)
    
    lw $t4, 4($t3)
    sw $t4, 4($t0)
    
    lw $t4, 8($t3)
    sw $t4, 8($t0)
    jr $ra
    
recordColumn:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    la $t0, columnArray
    addi $t1, $s2, -3
    addi $t2, $s3, -4
    li $t3, 0
    la $t4, currentColumn
recordColumn_loop:
    add $t5, $t2, $t3
    mul $t5, $t5, 6
    add $t5, $t5, $t1
    mul $t5, $t5, 4
    
    add $t6, $t0, $t5
    lw $t7, 0($t4)
    sw $t7, 0($t6)
    
    addi $t4, $t4, 4
    addi $t3, $t3, 1
    blt $t3, 3, recordColumn_loop
    
    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra
    
reachBottom:
    jal play_drop
    jal recordColumn
    jal checkCollision
    jal createColumn
    jal createPreview
    jal checkGameOver
    li $s2, 6
    li $s3, 2
    j game_loop

checkCollision:
    addi $sp,$sp,-4
    sw $ra,0($sp)

checkCollision_loop:
    jal checkThree
    beq $v0,$zero, end_checkCollision   # no matches, exit loop

    jal removeMatches
    jal play_remove
    jal dropping

    j checkCollision_loop

end_checkCollision:
    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra

checkThree:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, removeArray
    li $t9, 78 #Count
clearRemove:
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    addi $t9, $t9, -1
    bgez $t9, clearRemove
la $s4, columnArray
la $s5, removeArray
la $s6, 0 #s6: A boolean 1-Three Found 0-Not Found
li $t1, 0

ScanEachRow:
    bge $t1, 13, done #t1 - y
    li $t2, 0
ScanOneRow:
    bge $t2, 6, next_row #t2 - x
    
    #Get color from current cell
    mul $t0, $t1, 6        # t0 = y*6
    add $t0, $t0, $t2        # t0 = y*6 + x
    mul $t0, $t0, 4          
    add $t3, $s4, $t0        # t3 points to color of current cell

    lw  $t4, 0($t3)          # t4 load color
    
    ####Horizontal Check###### check the both sides for x = 1, 2, 3, 4
    blt $t2, 1, vertical # if x = 0 skip
    bgt $t2, 4, vertical # if x = 4 skip
    
    lw $t5, -4($t3) #load color of the left neighbour
    lw $t6, 4($t3) #load color of the right neighbour
    
    beq $t5, $zero, vertical
    bne $t5, $t4, vertical
    bne $t6, $t4, vertical
    
    #Otherwise there is a match
    move $a0, $t1 #a0 - y
    move $a1, $t2 #a1 - x
    jal markHorizontalMatch
    li $s6, 1 #A Three Match Found
    # load score AND increment
    la $t8, score # load score address
    lw $s7, 0($t8)
    addi $s7, $s7, 1
    sw $s7, 0($t8)
    add $t8, $zero, $zero   # reset temp register
    
    ####Vertical Check######
    vertical: 
        bgt $t1, 10, diagonal_down #Last two rows already covered, skip
        
        lw $t5, 24($t3) #load color of the neighbour 1 cell under
        lw $t6, 48($t3) #load color of the neighbour 2 cell under
        
        beq $t5, $zero, diagonal_down
        bne $t5, $t4, diagonal_down
        bne $t6, $t4, diagonal_down
        
        #Otherwise there is a match
        move $a0, $t1 #a0 - y
        move $a1, $t2 #a1 - x
        jal markVerticalMatch
        li $s6, 1 #A Three Match Found
        # load score AND increment
        la $t8, score # load score address
        lw $s7, 0($t8)
        addi $s7, $s7, 1
        sw $s7, 0($t8)
        add $t8, $zero, $zero   # reset temp register
        
    ####Diagonal Check######
    diagonal_down: #\
        bgt $t1, 10, diagonal_up #Last two rows already covered, skip
        bgt $t2, 3, diagonal_up
        
        lw $t5, 28($t3) #load color of the bottom-right neighbour  = 24 + 4
        lw $t6, 56($t3) #load color of the bottom-right neighbour  = 48 + 8
        
        beq $t5, $zero, diagonal_up
        bne $t5, $t4, diagonal_up
        bne $t6, $t4, diagonal_up
        
        #Otherwise there is a match
        move $a0, $t1 #a0 - y
        move $a1, $t2 #a1 - x
        jal markDiagonalDown
        li $s6, 1 #A Three Match Found
        # load score AND increment
        la $t8, score # load score address
        lw $s7, 0($t8)
        addi $s7, $s7, 1
        sw $s7, 0($t8)
        add $t8, $zero, $zero   # reset temp register
        
    diagonal_up: #/
        blt $t1, 2, skip_diag_up #Last two rows already covered, skip
        bgt $t2, 3, skip_diag_up
        
        lw $t5, -20($t3) #load color of the bottom-right neighbour  = -24 + 4
        lw $t6, -40($t3) #load color of the bottom-right neighbour  = -48 + 8
        
        beq $t5, $zero, skip_diag_up
        bne $t5, $t4, skip_diag_up
        bne $t6, $t4, skip_diag_up
        
        #Otherwise there is a match
        move $a0, $t1 #a0 - y
        move $a1, $t2 #a1 - x
        jal markDiagonalUp
        li $s6, 1 #A Three Match Found
        
        # load score AND increment
        la $t8, score # load score address
        lw $s7, 0($t8)
        addi $s7, $s7, 1
        sw $s7, 0($t8)
        add $t8, $zero, $zero   # reset temp register
        j skip_diag_up  
###Helpers for checkThree
skip_diag_up:
    addi $t2, $t2, 1 #x + 1
    j ScanOneRow #next cell
    
next_row:
    addi $t1, $t1, 1 #y + 1
    j ScanEachRow #next row

done: 
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    move $v0, $s6 #Return if a 3 match is found
    jr $ra
    
markHorizontalMatch: #$s5, removeArray
    mul $t0, $a0, 6 #t0 = y*6
    add $t0, $t0, $a1 #t0 = y*6+x
    mul $t0, $t0, 4 #bytes
    add $t0, $s5, $t0 #Points to current cell in removeArray
    li $t9, 1
    sw $t9, 0($t0)
    sw $t9, -4($t0)
    sw $t9, 4($t0)
    jr $ra
    
markVerticalMatch:
    mul $t0, $a0, 6 #t0 = y*6
    add $t0, $t0, $a1 #t0 = y*6+x
    mul $t0, $t0, 4 #bytes
    add $t0, $s5, $t0 #Points to current cell in removeArray
    li $t9, 1
    sw $t9, 0($t0)
    sw $t9, 24($t0)
    sw $t9, 48($t0)
    jr $ra
    
markDiagonalDown:
    mul $t0, $a0, 6 #t0 = y*6
    add $t0, $t0, $a1 #t0 = y*6+x
    mul $t0, $t0, 4 #bytes
    add $t0, $s5, $t0 #Points to current cell in removeArray
    li $t9, 1
    sw $t9, 0($t0)
    sw $t9, 28($t0)
    sw $t9, 56($t0)
    jr $ra
    
markDiagonalUp: 
    mul $t0, $a0, 6 #t0 = y*6
    add $t0, $t0, $a1 #t0 = y*6+x
    mul $t0, $t0, 4 #bytes
    add $t0, $s5, $t0 #Points to current cell in removeArray
    li $t9, 1
    sw $t9, 0($t0)
    sw $t9, -20($t0)
    sw $t9, -40($t0)
    jr $ra

removeMatches:
    la $t0, columnArray
    la $t1, removeArray
    li $t2, 78 #Count = 13*6
removeMatches_loop:
    lw $t3, 0($t1)
    beq $t3, $zero, skip_remove
    sw $zero, 0($t0)

skip_remove:
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    addi $t2, $t2, -1
    bgtz $t2, removeMatches_loop
    
    jr $ra
 
#The dropping mechanism after removal
dropping:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t7, 0  # boolean-changed = 0
    li $t1, 0 # x = 0
    
drop_x_loop:
    bge  $t1, 6, drop_check_if_done
    li   $t2, 11 # y = 11 (one row above bottom)
    
drop_y_loop:
    bltz $t2, drop_x_next
    
    mul $t3, $t2, 6
    add $t3, $t3, $t1
    mul $t3, $t3, 4

    la $t0, columnArray
    add $t4, $t0, $t3 

    addi $t3, $t3, 24 # next row
    add $t5, $t0, $t3 

    lw $t6, 0($t4) # cell above
    lw $t8, 0($t5) # cell below
    beq $t6, $zero, drop_y_next
    bne $t8, $zero, drop_y_next

    # SWAP
    sw $t6, 0($t5)
    sw $zero, 0($t4)
    li $t7, 1 # changed = 1

drop_y_next:
    addi $t2, $t2, -1
    j drop_y_loop

drop_x_next:
    addi $t1, $t1, 1
    j drop_x_loop

drop_check_if_done:
    beq $t7, $zero, drop_done
    j dropping

drop_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
################################################################################################
# game over conditions

checkGameOver:
    la $t0, columnArray
    add $t1, $t0, 60
    lw $t2, 0($t1)
    
    # if game is in fact over, then...
    bne $t2, 0, game_over_retry
    # else, just return 
    jr $ra
    
game_over_retry:
    jal play_gameover
    # clear the screen (maybe clear and repaint a couple times for the flashing effect?)
    jal clearScreen
    li $v0, 32          # operation to suspend program
    li $a0, 200           # number of milliseconds to wait
    syscall             # sleep
    jal repaint
    li $v0, 32          # operation to suspend program
    li $a0, 200           # number of milliseconds to wait
    syscall             # sleep
    jal clearScreen
    li $v0, 32          # operation to suspend program
    li $a0, 200           # number of milliseconds to wait
    syscall             # sleep
    jal repaint
    li $v0, 32          # operation to suspend program
    li $a0, 200           # number of milliseconds to wait
    syscall   
    jal clearScreen
    li $v0, 32          # operation to suspend program
    li $a0, 200           # number of milliseconds to wait
    syscall             # sleep# sleep
    
    # print words
    # load values for display array function 
    addi $a0, $zero, 640
    la $a1, game_array
    jal display_array
    addi $a0, $zero, 1408
    la $a1, over_array
    jal display_array
    
    # pause for effect
    li $v0, 32          # operation to suspend program
    li $a0, 900           # number of milliseconds to wait
    syscall             # sleep
    
    addi $a0, $zero, 2688   # load values for displaying the word paused w function
    la $a1, retry_array
    jal display_array
    
    # waiting for keyboard press r to retry
    add $t0, $zero, $zero      # counter initialise to 0
    retry_start:
        bgt $t0, 5000, retry_end     # wait for 5 seconds, then exit
        # sleep for delay
        li $v0, 32          # operation to suspend program
        li $a0, 1          # number of milliseconds to wait
        syscall             # sleep
        
        lw $t1, ADDR_KBRD               # $t0 = base address for keyboard
        lw $t8, 0($t1)                  # Load first word from keyboard
        addi $t0, $t0, 1                # increment counter
        bne $t8, 1, retry_start         # If first word is NOT 1, key is NOT pressed
                                        # else key is pressed
        lw $a0, 4($t1)                  # Load second word from keyboard
        beq $a0, 0x72, main            # Check if the key p was pressed

        j retry_start
    retry_end:
    
    retry_loop_end:
    j respond_to_Q  # finish game
    
################################################################################################
################################################################################################
# sleeping loops

sleep:
    li $t0, 200000 # Count down to slow down the game_loop
sleep_loop:
    addi $t0, $t0, -1
    bnez $t0, sleep_loop
    jr $ra
    
initialise_sleep_counter:
    # reset gravity counter
    la $t1, gravity_count # load address for gravity counter
    sw $zero, 0($t1)       # store the updated count in memory

    updating_sleep_loop_start:
    # load score
    lw $s0, score
    sll $s0, $s0, 2                         # multiply by 4
    addi $a3, $zero, 120
    sub $a3, $a3, $s0                       # stopping condition is 100 - score*2
    lw $s7, gravity_count                   # load gravity counter value into register
    bge $s7, $a3, updating_sleep_loop_end   # if counter reaches stopping condition, then exit loop
    j check_settings

increment_sleep:        # to implement gravity
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    add $t0, $v0, $zero # save value in $v0
    li $v0, 32          # operation to suspend program
    li $a0, 1           # number of milliseconds to wait
    syscall             # sleep
    lw $s7, gravity_count       # load gravity counter value into register
    addi $s7, $s7, 1    # increment $s7 by 1

    la $t1, gravity_count # load address for gravity counter
    sw $s7, 0($t1)       # store the updated count in memory
    
    add $v0, $t0, $zero # reload value in $v0 (so it doesn't mess anything up)
    
    # ---Play BGM---
    la   $t9, music_tick
    lw   $t0, 0($t9)
    addi $t0, $t0, 1
    sw   $t0, 0($t9)

    li   $t1, 25
    blt  $t0, $t1, music_skip

    sw   $zero, 0($t9) # reset counter
    jal  play_music_tick_async
    
    music_skip:
    j updating_sleep_loop_start
    updating_sleep_loop_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
################################################################################################
                        ##################  MUSIC   ######################
################################################################################################

play_music_tick_async:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, pitches
    la $t1, durations
    la $t2, velocity
    la $t3, instruments
    la $t4, music_index
    lw $t5, 0($t4) # current index
    lw $t6, length # total number of notes

    bge $t5, $t6, music_reset

    mul $t7, $t5, 4

    # Load pitch
    add $t8, $t0, $t7
    lw $a0, 0($t8)

    # Load duration
    add $t8, $t1, $t7
    lw $a1, 0($t8)

    # Load velocity
    add $t8, $t2, $t7
    lw $a2, 0($t8)

    # Load instrument
    add $t8, $t3, $t7
    lw $a3, 0($t8)

    # Play a note
    li $v0, 31
    syscall

    # Increment index
    addi $t5, $t5, 1
    sw $t5, 0($t4)
    jr $ra

music_reset:
    sw $zero, 0($t4)
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
play_shuffle:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    la   $t1, shuffle_pitches
    la   $t2, shuffle_durations 
    la   $t3, shuffle_velocity
    la   $t4, shuffle_instruments
    lw   $t5, shuffle_length 
    li   $t0, 0 # index i = 0
    j play_loop
    
play_remove:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    la   $t1, remove_pitches
    la   $t2, remove_durations
    la   $t3, remove_velocity
    la   $t4, remove_instruments 
    lw   $t5, remove_length
    li   $t0, 0              # index i = 0
    j play_loop
    
play_drop:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    la   $t1, drop_pitches
    la   $t2, drop_durations
    la   $t3, drop_velocity
    la   $t4, drop_instruments 
    lw   $t5, drop_length
    li   $t0, 0 # index i = 0
    j play_loop
    
play_gameover:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    la   $t1, gameover_pitches
    la   $t2, gameover_durations
    la   $t3, gameover_velocity
    la   $t4, gameover_instruments
    lw   $t5, gameover_length     
    li   $t0, 0  # index = 0
    j play_loop

play_loop:
    bge  $t0, $t5, finished   # if index >= length: exit loop
    mul  $t6, $t0, 4 # compute offset = i * 4

    #Load pitch
    add  $t7, $t1, $t6
    lw   $a0, 0($t7)

    #Load duration
    add  $t7, $t2, $t6
    lw   $a1, 0($t7)

    #Load velocity
    add  $t7, $t3, $t6
    lw   $a3, 0($t7)

    #Load instrument
    add  $t7, $t4, $t6
    lw   $a2, 0($t7)

    #PLAY note
    li   $v0, 33
    syscall

    #next note
    addi $t0, $t0, 1
    j play_loop

finished:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    

