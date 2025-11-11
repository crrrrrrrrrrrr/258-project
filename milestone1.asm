# milestone 1
# drawing the static scene

.data # data memory
display_address:.word 0x10008000 # address in memory
A: .space 6 # array of 6 possible colours

# instruction memory is the second section (below .text)
.text # ... 

li $t2, 0x808080 #grey
lw $t0, display_address 

########################################################################
# setting up the array of 6 colours

la $t8, A # temp reg 8 stores address of array A

addi $t3, $zero, 0xff0000 # load red colour into t3
sw $t3, 0($t8) #store colour red
addi $t3, $zero, 0xff6600 # load orange colour into t3
sw $t3, 4($t8) #store colour orange
addi $t3, $zero, 0xffcc00 # load yellow colour into t3
sw $t3, 8($t8) #store colour yellow
addi $t3, $zero, 0x00cc00 # load green colour into t3
sw $t3, 12($t8) #store colour green
addi $t3, $zero, 0x3399ff # load blue colour into t3
sw $t3, 16($t8) #store colour blue
addi $t3, $zero, 0x9933ff # load purple colour into t3
sw $t3, 20($t8) #store colour purple
########################################################################

# painting the 3 pixels, need to loop 3 times
addi $t1, $zero, 3 # end goal
addi $t3, $zero, 0 # index
addi $t9, $t0, 528 # starting pixel position

col_loop_start:
beq $t3, $t1, col_loop_end # stop if done drawing all 3 coloured pixels

li $v0, 42 # pick a random colour
li $a0, 0
li $a1, 6
syscall # after this, the return value is in $a0

sll $t6, $a0, 2 # index multiplied by 4  (to get offset from start of array)

# get memory address of new colour
# new address = # starting address of array + $t6
add $t5, $t8, $t6

lw $t7, 0($t5) # load colour (the element at address $t5) into $t7
sw $t7, 0($t9) # paint pixel with that colour

addi $t9, $t9, 128
addi $t3, $t3, 1 # increment counter
j col_loop_start
col_loop_end:

###########################################################

##### could make this a function to clean up code..
# drawing grey border
## total perimeter OUTSIDE is 15x8
# top left corner is 392
addi $t9, $t0, 392
# draw top line
add $t5, $t9, 32 # set up loop to draw 8 pixels to the right
top_loop_start:
beq $t5, $t9, top_loop_end # stop if done drawing all 8 pixels
sw $t2, 0($t9)
addi $t9, $t9, 4 # increment the memory address, (move $t0 to the next pixel)
j top_loop_start
top_loop_end:

# drawing the left and right edges of the border
add $t5, $t9, 1920 # set up loop to draw 17 pixels down
# want to go from 424 (prev ending spot) to 424+128*13= 2088

edge_loop_start:
beq $t5, $t9, edge_loop_end # stop if done drawing all edges
sw $t2, 0($t9)
subi $t9, $t9, 32 # subtract 28 to get left side
sw $t2, 0($t9)
addi $t9, $t9, 160 # increment the memory address
j edge_loop_start
edge_loop_end:

## drawing bottom edge
# initialise memory address to bottom left corner
subi $t9, $t9, 32
# draw top line
add $t5, $t9, 36 # set up loop to draw 8 pixels to the right
bottom_loop_start:
beq $t5, $t9, bottom_loop_end # stop if done drawing all 8 pixels
sw $t2, 0($t9)
addi $t9, $t9, 4 # increment the memory address, (move $t0 to the next pixel)
j bottom_loop_start
bottom_loop_end:

