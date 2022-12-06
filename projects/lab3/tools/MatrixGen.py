import numpy as np
import getopt
import sys

MIN = -255
MAX = 255

def MatrixGen(shape=(8,8)):
    rd = np.random
    matrix = rd.randint(MIN,MAX, shape)
    return matrix 

def TestCase(ram_path, testpath, testfile_T):
    A = MatrixGen()
    B = MatrixGen()
    C = MatrixGen()
    D = A.dot(B) + C 

    A_T = A.T
    B_T = B.T
    C_T = C.T
    D_T = D.T

    dump_list = [ A, A_T, B, B_T, C, C_T ]
    gold_result = D
    gold_result_T = D_T

    data_str  = ""
    for matrix in dump_list:
        for row in matrix:
            for pixel in row:
                data_str = "{}{:<10}\t".format(data_str, str(pixel))
            data_str = data_str + "\n"
        data_str = data_str + "\n\n"
    with open(ram_path,"w+") as f:
        f.write(data_str) 

    data_str = ""
    for row in gold_result:
        for pixel in row:
            data_str = "{}{:<10}\t".format(data_str, str(pixel))
        data_str = data_str + "\n"
    with open(testpath,"w+") as f:
        f.write(data_str)     

    data_str = ""
    for row in gold_result_T:
        for pixel in row:
            data_str = "{}{:<10}\t".format(data_str, str(pixel))
        data_str = data_str + "\n"
    with open(testfile_T,"w+") as f:
        f.write(data_str)  

def arg_handler():
    rampath = ""
    testpath = ""
    testfile_T = ""
    try:
        argv = sys.argv[1:]
        opts, args = getopt.getopt( argv, "hr:t:T:",["ramfile=", "testfile=", "testfile_T="] )
    except getopt.GetoptError:
        print('Example:')
        print("python MatrixGen.py -r ../data/ramdata.txt -t ../data/testdata.txt -T ../data/testdata_T.txt")
        sys.exit(2)
    
    for opt,arg in opts:
        if opt in ("-h", "--help"):
            print('Example:')
            print("python MatrixGen.py -r ../data/ramdata.txt -t ../data/testdata.txt -T ../data/testdata_T.txt")
            sys.exit()
        elif opt in ("-r", "--ramfile"):
            rampath = arg 
        elif opt in ("-t", "--testfile"):
            testpath = arg 
        elif opt in ("-T", "--testfile_T"):
            testfile_T = arg 

    return rampath, testpath, testfile_T

if __name__ == '__main__':
    rampath, testpath, testfile_T = arg_handler()

    TestCase(rampath, testpath, testfile_T)