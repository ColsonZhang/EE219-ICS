import sys
import random
import os
import shutil

mem_path = "./mem/"
top_file = "./vsrc/sim/top.v"

ARR_SIZE = int(sys.argv[1])
IMG_W = int(sys.argv[2])
IMG_H = int(sys.argv[3])
FILTER_NUM = int(sys.argv[4])
FILTER_SIZE = int(sys.argv[5])
DEBUG = int(sys.argv[6])

MEM_SIZE = 0x5000
IMG_BASE = 0x00000000
WEIGHT_BASE = 0x00001000


def init_mem():
    mem_list = []
    for i in range(MEM_SIZE):
        mem_list.append(0)
    return mem_list

def write_mem(mem_list):
    mem_file = open(mem_path+'mem_init.txt', 'w')
    mem_file.seek(0)
    mem_file.truncate()
    for val in mem_list:
        mem_file.write('%08X\n'%val)
    mem_file.close()
    
def main():
    M = FILTER_NUM
    N = FILTER_SIZE * FILTER_SIZE
    K = IMG_H * IMG_W
    mem_list = init_mem()
    for i in range(IMG_H):
        for j in range(IMG_W):
            val = random.randint(0, 255)
            mem_list[IMG_BASE + i * IMG_W + j] = val

    for i in range(M):
        for j in range(N):
            val = random.randint(0, 255)
            mem_list[WEIGHT_BASE + i * FILTER_SIZE * FILTER_SIZE +j] = val
    write_mem(mem_list)
    modify_testbench()

def modify_testbench():
    f_testbench = open(top_file, "r+")
    testbench = f_testbench.read().split('\n')
    testbench[1] = '`define ARR_SIZE ' + str(ARR_SIZE)
    testbench[2] = '`define IMG_W ' + str(IMG_W)
    testbench[3] = '`define IMG_H ' + str(IMG_H)
    testbench[4] = '`define FILTER_NUM ' + str(FILTER_NUM)
    testbench[5] = '`define FILTER_SIZE ' + str(FILTER_SIZE)
    testbench[6] = '`define DEBUG ' + str(DEBUG)

    f_testbench.seek(0)
    f_testbench.write("\n".join(testbench))
    f_testbench.close()

if __name__ == '__main__':
    main()