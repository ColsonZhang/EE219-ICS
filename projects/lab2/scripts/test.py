import sys
import os
from turtle import width
import numpy as np

IMG_BASE = 0x00000000
WEIGHT_BASE = 0x00001000
IM2COL_BASE = 0x00002000
OUTPUT_BASE = 0x00003000

mem_file1 = './mem/mem_init.txt'
mem_file2 = './mem/mem_out.txt'

IMG_W = int(sys.argv[1])
IMG_H = int(sys.argv[2])
FILTER_NUM = int(sys.argv[3])
FILTER_SIZE = int(sys.argv[4])

def im2col_fun(input_data, filter_h, filter_w, stride=1, pad=0):

    N, C, H, W = input_data.shape
    out_h = (H + 2*pad - filter_h)//stride + 1
    out_w = (W + 2*pad - filter_w)//stride + 1

    img = np.pad(input_data, [(0,0), (0,0), (pad, pad), (pad, pad)], 'constant')
    col = np.zeros((N, C, filter_h, filter_w, out_h, out_w), dtype='int')

    for y in range(filter_h):
        y_max = y + stride*out_h
        for x in range(filter_w):
            x_max = x + stride*out_w
            col[:, :, y, x, :, :] = img[:, :, y:y_max:stride, x:x_max:stride]

    col = col.transpose(0, 4, 5, 1, 2, 3).reshape(N*out_h*out_w, -1)
    return col.T

def matmul(A, B):
    M = len(A)
    N = len(B)
    K = len(B[0])
    C = []
    for i in range(M):
        row = []
        for j in range(K):
            val = 0
            for k in range(N):
                val += A[i][k] * B[k][j]
            row.append(val)
        C.append(row)
    return C

def main():
    M = FILTER_NUM
    N = FILTER_SIZE * FILTER_SIZE
    K = IMG_H * IMG_W
    f1 = open(mem_file1, 'r')
    f2 = open(mem_file2, 'r')
    mem = f1.readlines()
    mem_out = f2.readlines()
    weight = []
    image = []
    im2col = []
    output = []
    print('M:', M)
    print('N:', N)
    print('K', K)
    print('\nweight:')
    for i in range(M):
        row = []
        for j in range(N):
            val = int(eval('0x'+mem[WEIGHT_BASE + i * N + j].strip()))
            row.append(val)
            print("%02X "%val, end='')
        weight.append(row)
        print('')

    print('\nimage:')
    for i in range(IMG_H):
        row = []
        for j in range(IMG_W):
            val = int(eval('0x'+mem[IMG_BASE + i * IMG_W + j].strip()))
            row.append(val)
            print("%02X "%val, end='')
        image.append(row)
        print('')

    print('\nim2col:')
    for i in range(N):
        row = []
        for j in range(K):
            val = int(eval('0x'+mem_out[IM2COL_BASE + j * N + i].strip()))
            row.append(val)
            print("%02X "%val, end='')
        print('')
        im2col.append(row)
    
    image_arr = np.array(image).reshape(1, 1, IMG_H, IMG_W)
    col = im2col_fun(image_arr, FILTER_SIZE, FILTER_SIZE, pad=1)
    im2col_groundtruth = col.tolist()
    print("###############")
    if im2col == im2col_groundtruth:
        print('im2col pass')
    else:
        print('im2col fail')
    print("###############")

    print('\noutput:')
    for i in range(M):
        row = []
        for j in range(K):
            val = int(eval('0x'+mem_out[OUTPUT_BASE + i * K + j].strip()))
            row.append(val)
            print("%08X "%val, end='')
        print('')
        output.append(row)
    
    groundtruth = matmul(weight, im2col_groundtruth)
    print('\ngroundtruth:')
    for i in range(M):
        for j in range(K):
            print("%08X "%groundtruth[i][j], end='')
        print('')
    
    f1.close()
    f2.close()
    
    print("###############")
    if (output == groundtruth):
        print("Congratulate!")
        os.system('echo "PASS" > mem/status')
    else:
        print("Somthing Wrong!")
        os.system('echo FAIL > mem/status')
    print("###############")
    
if __name__ == '__main__':
    main()
