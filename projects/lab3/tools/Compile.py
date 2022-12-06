import string
import os
import sys
import getopt
from Common import *
from Instruction import *

def compile(file_path, export_path):
    raw_text = read_file(file_path)

    inst_list = []
    label_dict = {}

    code_list = []
    code_map_dict = {}
    error_flag = False
    for index, line in enumerate(raw_text):
        tmp = line.replace(" ","").replace("\t","")
        if(tmp[0]==';' or tmp[0]=='#'):
            continue
        tmp = line.replace(" ","").replace("\n","").replace(";","").replace("#","")
        if(tmp==''):
            continue
        inst, annotation = split_inst(line)
        
        current_index = len(code_list)
        # if the line is the label
        if ':' in inst:
            label = inst.replace(':', '').replace(' ', '').replace('\t', '').replace('\n', '')
            if label not in label_dict:
                label_dict[label] = current_index
                continue
            else:
                print("\033[31mERROR line {}\033[0m".format(index+1))
                print("Error Repeated Lable:\t{}".format(label))
                error_flag = True
                break
        # if the line is the inst
        the_inst = extract_inst(inst)
        code_list.append(the_inst)
        code_map_dict[current_index] = [index, line]
    # if error exists, exit
    if error_flag:
        exit()

    for index, the_inst in enumerate(code_list):
        try:
            inst_bin = InstGen(the_inst, label_dict, index)
        except:
            [error_index, error_line] = code_map_dict[index]
            print("\033[31mERROR line {}\033[0m".format(error_index+1))
            print(error_line)
            error_flag = True
        inst_list.append(inst_bin)
    # if error exists, exit
    if error_flag:
        exit()

    context = ""
    for i in inst_list:
        context = context + i
    data_btyes = binstr2bytes(context)
    export_bin(export_path, data_btyes)



def arg_handler():
    inputfile = ""
    outputfile = ""
    try:
        argv = sys.argv[1:]
        opts, args = getopt.getopt( argv, "hi:o:",["ifile=", "ofile="] )
    except getopt.GetoptError:
        print('python Compile.py -i <inputfile> -o <outputfile>')
        print('Example:')
        print("python Compile.py -i ../asm/demo.asm ../bin/demo.bin")
        sys.exit(2)
    
    for opt,arg in opts:
        if opt in ("-h", "--help"):
            print('python Compile.py -i <inputfile> -o <outputfile>')
            print('Example:')
            print("python Compile.py -i ../asm/demo.asm ../bin/demo.bin")
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg 
        elif opt in ("-o", "--ofile"):
            outputfile = arg 
    
    return inputfile, outputfile

if __name__== '__main__':
    inputfile, outputfile = arg_handler()

    compile(inputfile, outputfile)