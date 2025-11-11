# milestone 1
# drawing the static scene

.data # data memory
display_address:.word 0x10008000 # address in memory

# instruction memory is the second section (below .text)
.text # ... 
li $t1, 0xff0000 #red  
li $t2, 0x808080 #grey
li $t3, 0x0000ff #blue
li $t5, 0x00ff00 #green
lw $t0, display_address 

# create yellow colour
add $t4, $t1, $t5

###########################################################

# create the three pixels of colour
sw $t3, 528($t0) # draw first blue pixel in the starting spot
sw $t4, 656($t0) # draw yellow pixel below
sw $t1, 784($t0) # draw third red pixel at the end

###########################################################

# drawing grey border
## total perimeter OUTSIDE is 15x8
# top left corner is 392
addi $t0, $t0, 392
# draw top line
add $t5, $t0, 32 # set up loop to draw 8 pixels to the right
top_loop_start:
beq $t5, $t0, top_loop_end # stop if done drawing all 8 pixels
sw $t2, 0($t0)
addi $t0, $t0, 4 # increment the memory address, (move $t0 to the next pixel)
j top_loop_start
top_loop_end:

# drawing the left and right edges of the border
add $t5, $t0, 1920 # set up loop to draw 17 pixels down
# want to go from 424 (prev ending spot) to 424+128*13= 2088

edge_loop_start:
beq $t5, $t0, edge_loop_end # stop if done drawing all edges
sw $t2, 0($t0)
subi $t0, $t0, 32 # subtract 28 to get left side
sw $t2, 0($t0)
addi $t0, $t0, 160 # increment the memory address
j edge_loop_start
edge_loop_end:

## drawing bottom edge
# initialise memory address to bottom left corner
subi $t0, $t0, 32
# draw top line
add $t5, $t0, 36 # set up loop to draw 8 pixels to the right
bottom_loop_start:
beq $t5, $t0, bottom_loop_end # stop if done drawing all 8 pixels
sw $t2, 0($t0)
addi $t0, $t0, 4 # increment the memory address, (move $t0 to the next pixel)
j bottom_loop_start
bottom_loop_end:

