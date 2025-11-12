# testing keyboard input

.data
keyboard address : # . . .
.text


lw $t0, keyboard address # $ t0 = base address f o r keyboard
lw $t8, 0( $ t0 ) # Load f i r s t word from keyboard
beq $t8, 1 , keyboard input # I f f i r s t word 1 , key i s pressed
# . . .
keyboard input : lw $t2 , 4( $ t0 ) beq $t2 , 0x71 , respond to Q # A key i s pressed
# Load second word from keyboard
# Check i f the key q was pressed
# . . .