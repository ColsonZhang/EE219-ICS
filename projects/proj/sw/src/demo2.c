#include "trap.h"

#define STR2(s)             #s
#define STR(s)              STR2(s)

#define INST_OPV_BIN(funct6, vm, vs2, vs1, funct3, vd, opcode) 0b##funct6##vm##vs2##vs1##funct3##vd##opcode
#define WORD(inst) ".word "#inst""
#define ASM_CUSTOM(inst) WORD(inst)
#define PUTCH ASM_CUSTOM(0x0005007f)

int custom_mul(int a, int b){
    int result ;
    asm volatile( ".insn r 0x33, 0, 1, %0, %1, %2": "=r" (result): "r" (a), "r" (b) );
    return result ;
}

void custom_putch_1(char ch) {
    asm volatile("mv a0, %0; "PUTCH" " : :"r"(ch));
}

void custom_putch_2(){
    asm volatile( ASM_CUSTOM( INST_OPV_BIN( 000000, 1, 00000, 00000, 000, 00000, 1010111 ) ) );
}

void vadd_vv(register int* vd,register int* vs1,register int* vs2){
    asm volatile( ".insn r 0x57, 0x0, 0x01, %0, %1, %2": :"r"(vd), "r"(vs1), "r"(vs2) );
}

void vadd_vx(register int* vd,register int* rs1,register int* vs2){
    asm volatile( ".insn r 0x57, 0x4, 0x01, %0, %1, %2": :"r"(vd), "r"(rs1), "r"(vs2) );
}

void vadd_vi(register int* vd,register int* imm,register int* vs2){
    asm volatile( ".insn r 0x57, 0x3, 0x01, %0, %1, %2": :"r"(vd), "r"(imm), "r"(vs2) );
}


int main(){

    int result = custom_mul(10,10);
    printf("%d",result);

    register int *reg_vx0 asm ("x0");
    register int *reg_vx1 asm ("x1");
    register int *reg_vx2 asm ("x2");

    vadd_vv(reg_vx1, reg_vx1, reg_vx2);
    vadd_vx(reg_vx2, reg_vx1, reg_vx2);
    vadd_vi(reg_vx2, reg_vx0, reg_vx2);

    return 0 ;
}
