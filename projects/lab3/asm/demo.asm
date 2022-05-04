; =======================================
; scalar instructions
; =======================================
addi    x5,     x1,     0   ; addr_A = A_baseaddr
addi    x6,     x2,     0   ; addr_B = B_baseaddr
addi    x7,     x3,     0   ; addr_C = C_baseaddr
addi    x8,     x4,     0   ; addr_D = D_baseaddr

lw      x9,     0(x5)       ; load scalar data A[0]
lw      x10,    0(x6)       ; load scalar data B[0]
sw      x9,     0(x8)       ; save x9 into mem[x8+0]

add     x11,    x9,     x10 ; x11 = x9 + x10  
mul     x12,    x9,     x10 ; x12 = x9 * x10 

addi    x13,    zero,   0   ; x13 = 0
addi    x13,    x0,     0   ; x13 = 0
addi    x14,    zero,   8   ; x14 = 8

addi    x13,    x13,    1   ; x13 = x13 + 1 for(;;x13=x13+1 )
bne     x13,    x14,    -8  ; if(x13 != x14) { pc = pc-8 branch to addi x13, x13, 1 }

; =======================================
; vector instructions
; =======================================
vle32.v vx2,    x5,     1           ; vx2 = mem[addr_A]
vle32.v vx3,    x6,     1           ; vx3 = mem[addr_B]

vmul.vv vx4,    vx2,    vx3,    0   ; vx4 = vx2 * vx3
vadd.vv vx1,    vx1,    vx4,    0   ; vx1 = vx1 + vx4

vse32.v vx1,    x8,     1           ; mem[addr_D] = vx1

; =======================================
; custom instructions
; =======================================
vle32.v vx2,    x5,     1   ; data_A(vx2) = mem[addr_A]
vle32.v vx3,    x6,     1   ; data_B(vx3) = mem[addr_B]
vle32.v vx5,    x7,     1   ; data_C(vx4) = mem[addr_C]

vmac.lw vx5                 ; load coefficient into mac_unit

vmac.en 0,      vx2,    vx3 ; compute the first segment
addi    x5,     x5,     32  ; addr_A = addr_A + 4* 8
vle32.v vx2,    x5,     1   ; data_A = mem[addr_A]
vmac.en 1,      vx2,    vx3 ; compute the second segment
addi    x5,     x5,     32  ; addr_A = addr_A + 4* 8
vle32.v vx2,    x5,     1   ; data_A = mem[addr_A]
vmac.en 2,      vx2,    vx3 ; compute the third segment

vmac.sw vx1                 ; export the result in mac_unit into vx1 