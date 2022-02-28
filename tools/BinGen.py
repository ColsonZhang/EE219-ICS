import string
import os
import sys
import getopt

def read_file(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    return lines

def extract_num(lines, mode='hex', reverse=False):
    if mode in ('hex','Hex','HEX'):
        str_width = 2
        int_width = 16
    elif mode in ('bin','Bin','BIN'):
        str_width = 8
        int_width = 2
    else:
        return False
    
    context = ""
    for line in lines:
        if ':' in line:
            line = line[ line.index(':')+1 : ]  # ignore the inst-addr

        if '#' in line:
            line = line[: line.index('#') ]     # ignore the inst-note

        context = context + line
    context = context.replace(' ', '').replace('_', '').replace('\n', '').replace('\t', '')

    list_nums = []
    len_byte = int(len(context)/str_width) #计算字节的个数
    for i in range(0, len_byte):      #循环将解析出来的字节填充到list中
        chs = context[str_width*i : str_width*i + str_width]
        num = int(chs, int_width)
        list_nums.append(num)        
    
    if(reverse):
        list_nums = order_reverse(list_nums)

    data_bys = bytes(list_nums)
    return data_bys, list_nums

def export_bin(filename, data_bys):
    with open(filename, "wb") as f:
        f.write(data_bys)

def export_txt(filename, data_export ):
    with open(filename, "w") as f:
        f.write(data_export)

def binary_str_gen(list_nums):
    c = ""
    for count, i in enumerate(list_nums):
        temp = "{:0>8b}".format(i)
        c = c + temp
        if (count+1) % 4 == 0:
            c = c + "\n"
        else:
            c = c + "_"
    return c

def order_reverse(list_nums):
    new_list = []
    the_len = int(len(list_nums)/4)
    for i in range(the_len):
        for j in range(3,-1,-1):
            new_list.append( list_nums[4*i+j] )
    print("reverse the list")
    return new_list

def judege_bool(the_str):
    if the_str in ("True","true","TRUE","T","t"):
        return True
    else:
        return False

def arg_handler():
    # default-values
    inputfile   = "../bin/test.txt"
    outputfile  = "../bin/test.bin"
    mode        = "hex"
    export      = "False"
    reverse     = "False"

    try:
        argv = sys.argv[1:]
        opts, args = getopt.getopt(argv,"hi:o:m:e:r:",["ifile=","ofile=","mode=","export=","reverse="])
        # print(argv)
        # print(opts)
    except getopt.GetoptError:
        print('BinGen.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print('BinGen.py -i <inputfile> -o <outputfile> -m <mode>(hex or bin) -e -r')
            print('-i input-file-path\n-o output-file-path\n-m input-data-mode(hex or bin)\n-e export?\n-r reverse the list?')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
        elif opt in ("-m", "--mode"):
            mode = arg
        elif opt in ("-e", "--export"):
            export = arg
        elif opt in ("-r", "--reverse"):
            reverse = arg

    return inputfile, outputfile, mode, export, reverse
    

if __name__== '__main__':
    # get the args
    inputfile, outputfile, mode, export, reverse = arg_handler()
    # print(inputfile, outputfile, mode, export, reverse)

    export = judege_bool(export)
    reverse = judege_bool(reverse)

    if os.path.exists(inputfile) == False:
        print("The input-file does not exist !!!")
        sys.exit(2)
    
    lines =  read_file(inputfile)
    data_bys, list_nums = extract_num(lines, mode=mode, reverse=reverse)
    # print(data_bys)

    if export :
        data_export =  binary_str_gen(list_nums)
        export_txt(outputfile, data_export)
        print("Extracting the bin from the hex is done !")
    else:
        export_bin(outputfile, data_bys)
        print("Exporting the bin-file is done !")
