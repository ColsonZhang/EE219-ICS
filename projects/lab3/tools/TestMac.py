import getopt
import sys


def read_txt(path):
    matrix = []
    with open(path,'r') as f:
        str_lines = f.readlines()

        for the_line in str_lines:
            line = []
            list_line = the_line.replace("\n",'').split("\t")
            for i in list_line:
                i = i.replace(" ",'')
                if (i!=''):
                    line.append( int(i) )
            matrix.append(line)
    return matrix

def show_matrix(mat):
    the_row = len(mat)
    the_col = len(mat[0])
    context = ""
    for i in range(the_row):
        for j in range(the_col):
            context += ("{:10}".format( mat[i][j] ))
        context += ("\n")    
    print(context)


def compare(mat_A, mat_B):
    the_row = len(mat_A)
    the_col = len(mat_A[0])

    flag_same = True
    error_cnt = 0
    context = ""
    for i in range(the_row):
        for j in range(the_col):
            if( mat_A[i][j] != mat_B[i][j] ):
                flag_same = False
                error_cnt = error_cnt + 1
                context += ( "\033[31m{:10}\033[0m".format(mat_B[i][j]) )
            else:
                context += ( "\033[32m{:10}\033[0m".format(mat_B[i][j]) )
        context += "\n"
    print(context)

    if(flag_same):
        print("=====================================")
        print("                \033[32mPass\033[0m                 ")
        print("=====================================")
    else:
        print("=====================================")
        print("                \033[31mFail\033[0m                 ")
        print("=====================================")
        print("Total {} errors !!!".format(error_cnt))

def arg_handler():
    dumppath = ""
    testpath = ""
    try:
        argv = sys.argv[1:]
        opts, args = getopt.getopt( argv, "d:t:",["dumpfile=", "testfile="] )
    except getopt.GetoptError:
        print('\033[31mTest.py Arg EROOR!!!\033[0m')
        sys.exit(2)
    
    for opt,arg in opts:
        if opt in ("-d", "--dumpfile"):
            dumppath = arg 
        elif opt in ("-t", "--testfile"):
            testpath = arg 
    
    return dumppath, testpath

if __name__== '__main__':

    dumppath, testpath = arg_handler()
    if( dumppath == ""):
        dumppath = '../data/dumpdata_D.txt'
    
    if( testpath == ""):
        testpath = '../data/testdata_D.txt'   

    matrix_test = read_txt(testpath)
    matrix_dump = read_txt(dumppath)

    print('-----------------------------')
    print("The Golden Result:")
    print('-----------------------------')
    show_matrix(matrix_test)

    print('-----------------------------')
    print("The Dumped Result:")
    print('-----------------------------')
    compare(matrix_test, matrix_dump )

        