
def read_file(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    return lines

def export_bin(filename, data_bytes):
    with open(filename, "wb") as f:
        f.write(data_bytes)

def full_zero(the_bin, length):
    len_diff = length-len(the_bin)
    content = '0'*len_diff + the_bin
    return content

def ext_signed(the_bin, length):
    len_diff = length-len(the_bin)
    if(len_diff>=0):
        content = the_bin[0]*len_diff + the_bin
    else :
        content = the_bin[-len_diff:]
    return content

def posint2bin(num, signed_length=12):
    binary = bin(num)[2:]
    len_num = signed_length - 1
    len_diff = len_num - len(binary)
    assert (len_diff>=-1), "ERROR: num is too large !!!"
    if ( len_diff == -1 ):
        real_num = binary 
    else:
        real_num = '0' + len_diff*'0' + binary
    return real_num

def negint2bin(num, signed_length=12):
    len_num = signed_length - 1

    num_pos = -num 
    binary = bin(num_pos)[2:]

    list_bin = []
    for i in range(len(binary)):
        list_bin.append(binary[i])
    
    len_diff = len_num - len(list_bin)
    list_bin = len_diff*['0'] + list_bin

    list_reverse = []
    for i in range(len(list_bin)):
        if list_bin[i] == '1':
            list_reverse.append('0')
        elif list_bin[i] == '0':
            list_reverse.append('1')

    num_reverse = ""
    for i in list_reverse:
        num_reverse = num_reverse + i

    num_signed = bin(int(num_reverse,2) + 1)[2:]

    real_num = "1" + num_signed[-len_num:]
    return real_num

def signedint2bin(num, signed_length):
    if(num>=0):
        return posint2bin(num, signed_length)
    else:
        return negint2bin(num, signed_length)

def int2bin(num, mode='big', signed=True):
    if num >= 0:
        tmp = bin((num).to_bytes(1, mode, signed=signed)[0])[2:]
        result = tmp.rjust( len(tmp)+1, "0" )
    else:
        result = bin((num).to_bytes(1, mode, signed=signed)[0])[2:]
    return result

def order_reverse(list_nums):
    new_list = []
    the_len = int(len(list_nums)/4)
    for i in range(the_len):
        for j in range(3,-1,-1):
            new_list.append( list_nums[4*i+j] )
    return new_list

def binstr2bytes(context, reverse=True):
    str_width = 8
    int_width = 2
    len_byte = int(len(context)/str_width)
    list_int = []
    for i in range(0, len_byte):
        chs = context[str_width*i : str_width*i + str_width]
        num = int(chs, int_width)
        list_int.append(num)

    if(reverse):
        list_int = order_reverse(list_int)

    data_btyes = bytes(list_int)
    return data_btyes


def split_inst(instruction):
    # split the instruciton by the annotation
    inst_split = instruction.split(";")
    if(len(inst_split)==1):
        inst = inst_split[0]
        annotation = ""
    elif(len(inst_split)==2):
        inst = inst_split[0]
        annotation = inst_split[1]
    else:
        inst = inst_split[0]
        annotation = ""
        for i in inst_split[1:-1]:
            annotation = annotation + i + ";"
        annotation = annotation + inst_split[-1]
    return inst, annotation

def extract_inst(instruction):
    instruction = instruction.replace(",", " ").replace("\t", " ").replace("\n", " ")
    list_tmp = instruction.split(" ")
    list_inst = []
    for i in list_tmp:
        if(i != ''):
            list_inst.append(i)
    return list_inst

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        pass
 
    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass
 
    return False