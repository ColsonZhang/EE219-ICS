
from operator import is_
from Common import *

InstructionSet = {
# RV-32I
#   inst                type    opcode      funct3  funct7
    'lui'       :   [   'U',    '0110111'                       ],
    'auipc'     :   [   'U',    '0010111'                       ],
    'jal'       :   [   'J',    '1101111'                       ],
    'jalr'      :   [   'I',    '1100111',  '000'               ],
    'beq'       :   [   'B',    '1100011',  '000'               ],
    'bne'       :   [   'B',    '1100011',  '001'               ],
    'blt'       :   [   'B',    '1100011',  '100'               ],
    'bge'       :   [   'B',    '1100011',  '101'               ],
    'bltu'      :   [   'B',    '1100011',  '110'               ],
    'bgeu'      :   [   'B',    '1100011',  '111'               ],
    'lb'        :   [   'I',    '0000011',  '000'               ],
    'lh'        :   [   'I',    '0000011',  '001'               ],
    'lw'        :   [   'I',    '0000011',  '010'               ],
    'lbu'       :   [   'I',    '0000011',  '100'               ],
    'lhu'       :   [   'I',    '0000011',  '101'               ],
    'sb'        :   [   'S',    '0100011',  '000'               ],
    'sw'        :   [   'S',    '0100011',  '001'               ],
    'sw'        :   [   'S',    '0100011',  '010'               ],
    'addi'      :   [   'I',    '0010011',  '000'               ],
    'slti'      :   [   'I',    '0010011',  '010'               ],
    'sltiu'     :   [   'I',    '0010011',  '011'               ],
    'xori'      :   [   'I',    '0010011',  '100'               ],
    'ori'       :   [   'I',    '0010011',  '110'               ],
    'andi'      :   [   'I',    '0010011',  '111'               ],
    'slli'      :   [   'I',    '0010011',  '001',  '0000000'   ], # !!!
    'srli'      :   [   'I',    '0010011',  '101',  '0000000'   ], # !!!
    'srai'      :   [   'I',    '0010011',  '101',  '0100000'   ], # !!!
    'add'       :   [   'R',    '0110011',  '000',  '0000000'   ],
    'sub'       :   [   'R',    '0110011',  '000',  '0100000'   ],
    'sll'       :   [   'R',    '0110011',  '001',  '0000000'   ],
    'slt'       :   [   'R',    '0110011',  '010',  '0000000'   ],
    'sltu'      :   [   'R',    '0110011',  '011',  '0000000'   ],
    'xor'       :   [   'R',    '0110011',  '100',  '0000000'   ],
    'srl'       :   [   'R',    '0110011',  '101',  '0000000'   ],
    'sra'       :   [   'R',    '0110011',  '101',  '0100000'   ],
    'or'        :   [   'R',    '0110011',  '110',  '0000000'   ],
    'and'       :   [   'R',    '0110011',  '111',  '0000000'   ],
# RV-32M
#   inst                type    opcode      funct3  funct7
    'mul'       :   [   'R',    '0110011',  '000',  '0000001'   ],

# RV-32V 
#   inst                type        opcode      funct3  funct6
    'vadd.vv'   :   [   'OPIVV',    '1010111',  '000',  '000000'    ],
    'vadd.vx'   :   [   'OPIVX',    '1010111',  '100',  '000000'    ],
    'vadd.vi'   :   [   'OPIVI',    '1010111',  '011',  '000000'    ],

    'vmul.vv'   :   [   'OPIVV',    '1010111',  '000',  '100101'    ],
    'vmul.vx'   :   [   'OPIVX',    '1010111',  '100',  '100101'    ],
    'vmul.vi'   :   [   'OPIVI',    '1010111',  '011',  '100101'    ],

#   inst                type        opcode      width   funct6
    'vle32.v'   :   [   'VL',       '0000111',  '110',  '000000'    ],
    'vse32.v'   :   [   'VS',       '0100111',  '110',  '000000'    ],
}

RegisterSet = {}
for i in range(32):
    content = bin(i)[2:]
    len_diff = 5-len(content)
    content = '0'*len_diff + content
    RegisterSet['x{}'.format(i)] = content
    RegisterSet['s{}'.format(i)] = content
RegisterSet['zero'] = RegisterSet['x0']
RegisterSet['ra']   = RegisterSet['x1']
RegisterSet['sp']   = RegisterSet['x2']


VRegisterSet = {
    'vzero':    '00000'
}
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

def InstructionGen_U(opcode, rd, imm):
    inst = ''
    inst = inst + imm[0:20] + rd + opcode 
    return inst

def InstructionGen_J(opcode, rd, imm):
    inst = ''
    inst = inst + imm[0] + imm[10:20] + imm[9] + imm[1:9] + rd + opcode
    return inst

def InstructionGen_VL(opcode, width, funct6, vd, rs1, lumop, vm):
    inst = ''
    inst = inst + funct6 + vm + lumop + rs1 + width + vd + opcode
    return inst

def InstructionGen_VS(opcode, width, funct6, vs3, rs1, sumop, vm):
    inst = ''
    inst = inst + funct6 + vm + sumop + rs1 + width + vs3 + opcode
    return inst

def InstructionGen_OPIVV(opcode, funct3, funct6, vd, vs1, vs2, vm):
    inst = ''
    inst = inst + funct6 + vm + vs2 + vs1 + funct3 + vd + opcode
    return inst

def InstructionGen_OPIVX(opcode, funct3, funct6, vd, rs1, vs2, vm):
    inst = ''
    inst = inst + funct6 + vm + vs2 + rs1 + funct3 + vd + opcode
    return inst

def InstructionGen_OPIVI(opcode, funct3, funct6, vd, imm, vs2, vm):
    inst = ''
    inst = inst + funct6 + vm + vs2 + imm + funct3 + vd + opcode
    return inst


def InstGen(list_inst, label_dict, current_index):
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
            if ( code=='slli' or code=='srli' or code=='srai' ):
                imm = inst_info[3] + signedint2bin(imm_int, 5)
            else:
                imm = signedint2bin(imm_int, 12)
        # lw
        elif( len(list_inst) == 3 ):
            rd = RegisterSet[ list_inst[1] ]
            tmp = list_inst[2].replace("("," ").replace(")","")
            tmp = tmp.split(" ")
            rs1 = RegisterSet[tmp[1]]
            imm_int = int(tmp[0])
            imm = signedint2bin(imm_int, 12)

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

        the_inst = InstructionGen_S(opcode, funct3, rs1, rs2, imm)

    elif(the_type == 'U'):
        opcode = inst_info[1]

        if( len(list_inst) == 3 ):
            rd = RegisterSet[ list_inst[1] ]
            tmp = list_inst[2]
            imm_int = int(tmp)
            # !!! Speically for 32I, not for 64
            imm = signedint2bin(imm_int, 32)
        try:
            the_inst = InstructionGen_U(opcode, rd, imm)
        except:
            assert False, "Error!!!"
        # print(the_inst)

    elif(the_type == 'J'):
        opcode = inst_info[1]
        
        if( len(list_inst) == 3 ):
            rd = RegisterSet[ list_inst[1] ]
            tmp = list_inst[2]
            if is_number(tmp):
                imm_int = int(tmp)
            else:
                label = tmp 
                label_idx = label_dict[label]
                # print(current_index, label_idx)
                imm_int = (current_index - label_idx )*(-4)
                # print(imm_int)
            imm = signedint2bin(imm_int, 21)
        
        the_inst = InstructionGen_J(opcode, rd, imm)
        # print(the_inst)

    elif(the_type == 'B'):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        if( len(list_inst) == 4 ):
            rs1 = RegisterSet[ list_inst[1] ]
            rs2 = RegisterSet[ list_inst[2] ]
            tmp = list_inst[3]
            if is_number(tmp):
                imm_int = int(tmp)
            else:
                label = tmp 
                label_idx = label_dict[label]
                # print(current_index)
                # print(label_idx)
                imm_int = (current_index - label_idx )*(-4)
            # print(imm_int)
            imm = signedint2bin(imm_int, 13)

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

    elif(the_type == 'OPIVX'):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        funct6 = inst_info[3]

        if( len(list_inst) == 5 ):
            vd = VRegisterSet[ list_inst[1] ]
            vs2 = VRegisterSet[ list_inst[2] ]
            rs1 = RegisterSet[ list_inst[3] ]
            vm = list_inst[4]
        
        the_inst = InstructionGen_OPIVX( opcode, funct3, funct6, vd, rs1, vs2, vm )

    elif(the_type == 'OPIVI'):
        opcode = inst_info[1]
        funct3 = inst_info[2]
        funct6 = inst_info[3]

        if( len(list_inst) == 5 ):
            vd = VRegisterSet[ list_inst[1] ]
            vs2 = VRegisterSet[ list_inst[2] ]
            # imm = RegisterSet[ list_inst[3] ]
            tmp = list_inst[3]
            imm_int = int(tmp)
            imm = signedint2bin(imm_int, 5)
            vm = list_inst[4]
        
        the_inst = InstructionGen_OPIVI( opcode, funct3, funct6, vd, imm, vs2, vm )

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

    else:
        print("The instruciton is not supported !!!") 

    return the_inst

