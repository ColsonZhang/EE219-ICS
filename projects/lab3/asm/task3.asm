; =======================================
; task3
; Do not modify this file !!!
; =======================================


lui         x5,     2157969408          ;   0x80a00000

# Test for vadd.vi & vse32.v
vadd.vi     vx2,    vx0,    8,    1     ;
vse32.v     vx2,    x5,             1   ;   mem[0][0:7]=8
addi        x5,     x5,     32          ;

# Test for vadd.vx
addi        x7,     x0,     9           ;
vadd.vx     vx3,    vx0,    x7,     1   ;
vse32.v     vx3,    x5,             1   ;   mem[1][0:7]=9
addi        x5,     x5,     32          ;

# Test for vadd.vv
vadd.vv     vx2,    vx2,    vx3,    1   ;
vse32.v     vx2,    x5,             1   ;   mem[2][0:7]=17

# Test for vle32.v
vadd.vv     vx2,    vx2,    vx0,    1   ;
vle32.v     vx2,    x5,             1   ;
addi        x5,     x5,     32          ;
vadd.vv     vx2,    vx2,    vx3,    1   ;
vse32.v     vx2,    x5,             1   ;   mem[4][0:7]=26
addi        x5,     x5,     32          ;

# Test for vmul.vi
vadd.vi     vx2,    vx0,    1,      1   ;
vmul.vi     vx2,    vx2,    13,     1   ;
vse32.v     vx2,    x5,             1   ;   mem[5][0:7]=13
addi        x5,     x5,     32          ;

# Test for vmul.vx
vadd.vi     vx2,    vx0,    1,      1   ;
addi        x7,     x0,     7           ;
vmul.vx     vx2,    vx2,    x7,     1   ;
vse32.v     vx2,    x5,             1   ;   mem[5][0:7]=7
addi        x5,     x5,     32          ;

# Test for vmul.vv
vadd.vi     vx2,    vx0,    10,     1   ;
vadd.vi     vx3,    vx0,    10,     1   ;
vmul.vv     vx2,    vx2,    vx3,    1   ;
vse32.v     vx2,    x5,             1   ;   mem[5][0:7]=100
addi        x5,     x5,     32          ;
