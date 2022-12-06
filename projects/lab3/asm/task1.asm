; =======================================
; task1
; Do not modify this file !!!
; =======================================

# Test for addi & sw & lui
lui     x5,     2156920832          ;   0x80900000
lui     x6,     2156920832          ;   0x80900000

addi    x7,     x0,     100         ;   
sw      x7,     0(x6)               ;   mem[0] = 100
addi    x6,     x6,     4           ;

addi    x7,     x0,     -100        ;
sw      x7,     0(x6)               ;   mem[1] = -100
addi    x6,     x6,     4           ;

# Test for lw   
lw      x7,     0(x5)               ;
addi    x7,     x7,     15          ;
sw      x7,     0(x6)               ;   mem[1] = 115
addi    x6,     x6,     4           ;

# Test for add  
lw      x7,     4(x5)               ;
addi    x8,     x0,     15          ;
add     x7,     x7,     x8          ;
sw      x7,     0(x6)               ;   mem[2] = -85
addi    x6,     x6,     4           ;

lw      x7,     4(x5)               ;
addi    x8,     x0,     -15         ;
add     x7,     x7,     x8          ;
sw      x7,     0(x6)               ;   mem[3] = -115
addi    x6,     x6,     4           ;

# Test for mul  
addi    x7,     x0,     10          ;
addi    x8,     x0,     10          ;
mul     x7,     x7,     x7          ;   
sw      x7,     0(x6)               ;   mem[4] = 100
addi    x6,     x6,     4           ;

# Test for and      
addi    x7,     x0,     7           ;
addi    x8,     x0,     3           ;
and     x7,     x7,     x8          ;
sw      x7,     0(x6)               ;   mem[5] = 3
addi    x6,     x6,     4           ;

# Test for sll      
addi    x7,     x0,     1           ;
addi    x8,     x0,     2           ;
sll     x7,     x7,     x8          ;   
sw      x7,     0(x6)               ;   mem[6] = 4
addi    x6,     x6,     4           ;

# Test for slti         
addi    x7,     x0,     9           ;
slti    x7,     x7,     10          ;
sw      x7,     0(x6)               ;   mem[7] = 1
addi    x6,     x6,     4           ;

addi    x7,     x0,     9           ;
slti    x7,     x7,     8           ;
sw      x7,     0(x6)               ;   mem[8] = 0
addi    x6,     x6,     4           ;

# Test for blt 
addi    x7,     x0,     0           ;
addi    x8,     x0,     4           ;
addi    x9,     x0,     60          ;
loop:
addi    x9,     x9,     1           ;
addi    x7,     x7,     1           ;
blt     x7,     x8,     loop        ;

addi    x7,     x9,     0           ;
sw      x7,     0(x6)               ;   mem[9] = 64
addi    x6,     x6,     4           ;

# Test for jal
addi    x7,     x0,     50          ;
jal     x1,     label 
addi    x7,     x7,     1           ;
label:
addi    x7,     x7,     10          ;
sw      x7,     0(x6)               ;   mem[10] = 60
addi    x6,     x6,     4           ;

