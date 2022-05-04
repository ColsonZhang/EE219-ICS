import string
import os
import sys
import getopt
from Common import *
from Instruction import *

def compile(file_path, export_path):
    raw_text = read_file(file_path)

    inst_content = []
    for index, line in enumerate(raw_text):
        tmp = line.replace(" ","").replace("\t","")
        if(tmp[0]==';'):
            continue
        tmp = line.replace(" ","").replace("\n","").replace(";","")
        if(tmp==''):
            continue

        inst, annotation = split_inst(line)
        list_inst = extract_inst(inst)
        try:
            inst_bin = InstGen(list_inst)
        except:
            print("ERROR line {}".format(index+1))
            print(list_inst)
        inst_content.append(inst_bin)
    context = ""
    for i in inst_content:
        context = context + i

    data_btyes =  binstr2bytes(context)

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