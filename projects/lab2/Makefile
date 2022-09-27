ARR_SIZE = 4
IMG_W = 4
IMG_H = 5
FILTER_NUM = 7
FILTER_SIZE = 3
DEBUG = 0

all: clean

build:
	

clean:
	./../../build.sh -e lab2 -c
	if [ -f "mem/mem_init.txt" ]; then rm mem/mem_init.txt; fi
	if [ -f "mem/mem_out.txt" ]; then rm mem/mem_out.txt; fi
	if [ -f "mem/status" ]; then rm mem/status; fi