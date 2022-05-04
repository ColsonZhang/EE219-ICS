
from Common import *

InstructionSet = {
#   inst            type    opcode    funct3  funct7
    'addi'      :   ['I', '0010011', '111'],
    'lw'        :   ['I', '0000011', '010'],
    'sw'        :   ['S', '0100011', '010'],
    'add'       :   ['R', '0110011', '000', '0000000'],
    'mul'       :   ['R', '0110011', '000', '0000001'],
    'bne'       :   ['B', '1100011', '001'],

#   inst            type        opcode      funct3  funct6
    'vadd.vv'   :   ['OPIVV',   '1010111', '000', '000000' ],
    'vmul.vv'   :   ['OPIVV',   '1010111', '000', '100101' ],
#   inst            type        opcode      width   funct6
    'vle32.v'   :   ['VL',      '0000111', '110', '000000'],
    'vse32.v'   :   ['VS',      '0100111', '110', '000000'],

    'vmac.lw'   :   ['VMAC_LW', '1010111', '000', '000001' ],
    'vmac.sw'   :   ['VMAC_SW', '1010111', '000', '001000' ],
    'vmac.en'   :   ['VMAC_EN', '1010111', '000', '110100' ],

}

RegisterSet = {
    'zero': '00000',
}
for i in range(32):
    content = bin(i)[2:]
    len_diff = 5-len(content)
    content = '0'*len_diff + content
    RegisterSet['x{}'.format(i)] = content
    RegisterSet['s{}'.format(i)] = content

VRegisterSet = {}
for i in range(32):
    content = bin(i)[2:]
    len_diff = 5-len(content)
    content = '0'*len_diff + content
    VRegisterSet['vs{}'.format(i)] = content
    VRegisterSet['vx{}'.format(i)] = content
    VRegisterSet['v{}'.format(i)] = content


def InstructionGen_I(opcode, funct3, rd, rs1, imm):
    inst = ''
    inst = inst + imm + rs1 + funct3 + rd + opcode
    return inst

def InstructionGen_R(opcode, funct3, rd, rs1, rs2, funct7):
    inst = ''
    inst = inst + funct7 + rs2 + rs1 + funct3 + rd + opcode 
    return inst 

def InstructionGen_S(opcode, funct3, rs1, rs2, imm):
    inst = ''
    inst = inst + imm[0:7] + rs2 + rs1 + funct3 + imm[7:12] + opcode
    return inst

def InstructionGen_B(opcode, funct3, rs1, rs2, imm):
    inst = ''
    inst = inst + imm[0] + imm[2:8] + rs2 + rs1 + funct3 + imm[8:12] + imm[1]  + opcode
    return inst

def InstructionGen_OPIVV(opcode, funct3, funct6, vd, vs1, vs2, vm):
    inst = ''
    inst = inst + funct6 + vm + vs2 + vs1 + funct3 + vd + opcode
    return inst

def InstructionGen_VL(opcode, width, funct6, vd, rs1, lumop, vm):
    inst = ''
    inst = inst + funct6 + vm + lumop + rs1 + width + vd + opcode
    return inst

def InstructionGen_VS(opcode, width, funct6, vs3, rs1, sumop, vm):
    inst = ''
    inst = inst + funct6 + vm + sumop + rs1 + width + vs3 + opcode
    return inst


def InstGen(list_inst):
    code = list_inst[0]
    inst_info = InstructionSet[code]
    the_type = inst_info[0]
    if(the_type == 'I'):
        opcode = inst_info[1]
        funct3 = inst_info[2]

        if( len(list_inst) == 4 ):
            rd = RegisterSet[ list_inst[1] ]
            rs1 = RegisterSet[ list_inst[2] ]
            imm_int = int(list_inst[3])
            imm = signedint2bin(imm_int, 12)
            # imm = ext_signed( int2bin(imm_int), 12 )
        elif( len(list_inst) == 3 ):
            rd = RegisterSet[ list_inst[1] ]
            tmp = list_inst[2].replace("("," ").replace(")","")
            tmp = tmp.split(" ")
            rs1 = RegisterSet[tmp[1]]
            imm_int = int(tmp[0])
            imm = signedint2bin(imm_int, 12)
            # imm = ext_signed( int2bin(imm_int), 12 )

        the_inst = InstructionGen_I(opcode, funct3, rd, rs1, imm)

    elif(the_type == 'R'):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        funct7 = inst_info[3]

        if( len(list_inst) == 4 ):
            rd = RegisterSet[ list_inst[1] ]
            rs1 = RegisterSet[ list_inst[2] ]
            rs2 = RegisterSet[ list_inst[3] ]
        
        the_inst = InstructionGen_R(opcode, funct3, rd, rs1, rs2, funct7)
    
    elif(the_type == 'S'):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        
        if( len(list_inst) == 3 ):
            rs2 = RegisterSet[ list_inst[1] ]
            tmp = list_inst[2].replace("("," ").replace(")","")
            tmp = tmp.split(" ")
            rs1 = RegisterSet[tmp[1]]
            imm_int = int(tmp[0])
            imm = signedint2bin(imm_int, 12)
            # imm = ext_signed( int2bin(imm_int), 12 )

        the_inst = InstructionGen_S(opcode, funct3, rs1, rs2, imm)
    
    elif(the_type == 'B'):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        if( len(list_inst) == 4 ):
            rs1 = RegisterSet[ list_inst[1] ]
            rs2 = RegisterSet[ list_inst[2] ]
            imm_int = int(list_inst[3])
            imm = signedint2bin(imm_int, 13)
            # imm = ext_signed( int2bin(imm_int), 13 )

        the_inst = InstructionGen_B(opcode, funct3, rs1, rs2, imm)
        
    elif(the_type == 'OPIVV'):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        funct6 = inst_info[3]

        if( len(list_inst) == 5 ):
            vd = VRegisterSet[ list_inst[1] ]
            vs2 = VRegisterSet[ list_inst[2] ]
            vs1 = VRegisterSet[ list_inst[3] ]
            vm = list_inst[4]
        
        the_inst = InstructionGen_OPIVV( opcode, funct3, funct6, vd, vs1, vs2, vm )

    elif(the_type == 'VL'):
        opcode = inst_info[1]
        width = inst_info[2]
        funct6 = inst_info[3]

        if( len(list_inst) == 4 ):
            vd = VRegisterSet[ list_inst[1] ]
            rs1 = RegisterSet[ list_inst[2] ]
            vm = list_inst[3]
            lumop = '00000'

        the_inst = InstructionGen_VL( opcode, width, funct6, vd, rs1, lumop, vm )
    
    elif(the_type == 'VS'):
        opcode = inst_info[1]
        width = inst_info[2]
        funct6 = inst_info[3]

        if( len(list_inst) == 4 ):
            vs3 = VRegisterSet[ list_inst[1] ]
            rs1 = RegisterSet[ list_inst[2] ]
            vm = list_inst[3]
            sumop = '00000'
        
        the_inst = InstructionGen_VS( opcode, width, funct6, vs3, rs1, sumop, vm )

    elif( the_type == 'VMAC_LW' ):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        funct6 = inst_info[3]
        vd = '00000'
        vs2 = '00000'
        vm = '1'
        if( len(list_inst) == 2 ):
            vs1 = VRegisterSet[ list_inst[1] ]

        the_inst = InstructionGen_OPIVV( opcode, funct3, funct6, vd, vs1, vs2, vm )
    
    elif( the_type == 'VMAC_SW' ):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        funct6 = inst_info[3]
        vs1 = '00000'
        vs2 = '00000'
        vm = '1'
        if( len(list_inst) == 2 ):
            vd = VRegisterSet[ list_inst[1] ]

        the_inst = InstructionGen_OPIVV( opcode, funct3, funct6, vd, vs1, vs2, vm )
    
    elif( the_type == 'VMAC_EN' ):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        funct6 = inst_info[3]
        vm = '1'

        if( len(list_inst) == 4 ):
            sel = int(list_inst[1])
            vd = signedint2bin(sel, 5)
            # vd = full_zero( int2bin(sel), 5 )
            vs2 = VRegisterSet[ list_inst[2] ]
            vs1 = VRegisterSet[ list_inst[3] ]

        the_inst = InstructionGen_OPIVV( opcode, funct3, funct6, vd, vs1, vs2, vm )
    

    elif(the_type == 'U'):
        pass 

    return the_inst