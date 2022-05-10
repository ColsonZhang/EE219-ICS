; This is a demo code showing how to convert the c-code into the assembly code
; The fuction demo2() is used to do the matrix addition ( Matrix-B + Matrix-C )
; and write the addition result into the memory ( the address of Matrix-D )

addi    x5,     zero,   8   ; num_size = 8

addi    x8,     x2,     0   ; addr_B = B_baseaddr 
addi    x9,     x3,     0   ; addr_C = C_baseaddr 
addi    x10,    x4,     0   ; addr_D = D_baseaddr 

addi    x6,     zero,   0   ; index_col = 0
; for(index_col)

addi    x7,     zero,   0   ; index_row = 0
; for(index_row)

lw      x11,    0(x8)       ; data_B = mem[addr_B] ;
lw      x12,    0(x9)       ; data_C = mem[addr_C] ;

add     x13,    x11,    x12 ; data_D = data_B + data_C ;

sw      x13,    0(x10)      ; mem[addr_D] = data_D ;

addi    x8,     x8,     4   ; addr_B = addr_B + 4 ;
addi    x9,     x9,     4   ; addr_C = addr_C + 4 ;
addi    x10,    x10,    4   ; addr_D = addr_D + 4 ;


; for( index_row=index_row+1 )
addi    x7,     x7,     1   ; for( index_row=index_row+1 )
bne     x7,     x5,     -36 ; for( index_row<num_size )

; for(index_col=index_col+1)
addi    x6,     x6,     1   ; for( index_col=index_col+1 )
bne     x6,     x5,     -48 ; for( index_col<num_size )

