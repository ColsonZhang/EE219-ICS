import numpy as np
import getopt
import sys

MIN = -255
MAX = 255

def MatrixGen(shape=(8,8)):
    rd = np.random
    matrix = rd.randint(MIN,MAX, shape)
    return matrix 

def TestCase(ram_path, testpath):
    A = MatrixGen()
    B = MatrixGen()
    C = MatrixGen()
    D = A.dot(B) + C 

    B_T = B.T
    C_T = C.T
    D_T = D.T

    data_str  = ""
    for matrix in [A, B_T, C_T]:
        for row in matrix:
            for pixel in row:
                data_str = "{}{:<10}\t".format(data_str, str(pixel))
            data_str = data_str + "\n"
        data_str = data_str + "\n\n"
    
    with open(ram_path,"w+") as f:
        f.write(data_str) 

    data_str = ""
    for row in D_T:
        for pixel in row:
            data_str = "{}{:<10}\t".format(data_str, str(pixel))
        data_str = data_str + "\n"

    with open(testpath,"w+") as f:
        f.write(data_str)     


def arg_handler():
    rampath = ""
    testpath = ""
    try:
        argv = sys.argv[1:]
        opts, args = getopt.getopt( argv, "hr:t:",["ramfile=", "testfile="] )
    except getopt.GetoptError:
        print('python MatrixGen.py -i <rampath> -o <testpath>')
        print('Example:')
        print("python MatrixGen.py -i ../data/ramdata.txt ../data/testdata.txt")
        sys.exit(2)
    
    for opt,arg in opts:
        if opt in ("-h", "--help"):
            print('python MatrixGen.py -i <rampath> -o <testpath>')
            print('Example:')
            print("python MatrixGen.py -i ../data/ramdata.txt ../data/testdata.txt")
            sys.exit()
        elif opt in ("-r", "--ramfile"):
            rampath = arg 
        elif opt in ("-t", "--testfile"):
            testpath = arg 
    
    return rampath, testpath

if __name__ == '__main__':
    rampath, testpath = arg_handler()

    TestCase(rampath, testpath)