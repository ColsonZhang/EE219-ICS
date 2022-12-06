import getopt
import sys

golden_result = [ 100, -100,   115,    -85,    -115,   100,    3,      4,  1,  0,  64,     60 ]
test_content = [    'addi & sw & lui', 'addi & sw & lui', 
                    'lw',  
                    'add', 
                    'mul',
                    'and', 'and',
                    'sll',
                    'slti', 'slti',
                    'blt', 
                    'jal' ]

def read_txt(path):
    line = []
    with open(path,'r') as f:
        str_lines = f.readlines()

        for the_line in str_lines:
            
            list_line = the_line.replace("\n",'').split("\t")
            for i in list_line:
                i = i.replace(" ",'')
                if (i!=''):
                    line.append( int(i) )
    return line

def show_golden(golden_result):
    length = len(golden_result)
    context = ""
    for i in range(length):
        res_a = golden_result[i]
        context += ("{:10}".format( res_a )) 
        if((i+1)%8==0):
            context += "\n"
    print(context)


def compare( golden_result, test_list ):
    length = len(golden_result)
    
    flag_same = True 
    error_cnt = 0 
    error_list = []
    context = ""
    for i in range(length):
        res_a = golden_result[i]
        res_b = test_list[i]
        if ( res_a != res_b ):
            flag_same = False 
            error_cnt += 1 
            error_list.append( i )
            context += ("\033[31m{:10}\033[0m".format( res_b )) 
        else:
            context += ("\033[32m{:10}\033[0m".format( res_b )) 
        if((i+1)%8==0):
            context += "\n"
    print(context)

    if error_cnt >  0 :
        print("Error Instructions:")
        for i in error_list:
            print("{}\t".format(test_content[i]))

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
    try:
        argv = sys.argv[1:]
        opts, args = getopt.getopt( argv, "d:",["dumpfile="] )
    except getopt.GetoptError:
        print('\033[31mTest.py Arg EROOR!!!\033[0m')
        sys.exit(2)
    
    for opt,arg in opts:
        if opt in ("-d", "--dumpfile"):
            dumppath = arg 
    
    return dumppath

if __name__== '__main__':

    dumppath = arg_handler()
    if( dumppath == ""):
        dumppath = '../data/dumpdata_task1.txt'

    test_list = read_txt(dumppath)

    print('-----------------------------')
    print("The Golden Result:")
    print('-----------------------------')
    show_golden( golden_result )

    print('-----------------------------')
    print("The Dumped Result:")
    print('-----------------------------')
    compare(golden_result, test_list )
