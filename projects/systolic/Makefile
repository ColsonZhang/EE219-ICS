ARR_SIZE = 4
IMG_W = 4
IMG_H = 5
FILTER_NUM = 7
FILTER_SIZE = 3
DEBUG = 0

all: test

memory:
	python3 ./mem/make_mem.py $(ARR_SIZE) $(IMG_W) $(IMG_H) $(FILTER_NUM) $(FILTER_SIZE) $(DEBUG)

build: memory
	./../../build.sh -e systolic -b

sim: build
	./../../build.sh -e systolic -s

test: sim
	python3 ./mem/test.py $(ARR_SIZE) $(IMG_W) $(IMG_H) $(FILTER_NUM) $(FILTER_SIZE) $(DEBUG)
	
clean:
	./../../build.sh -e systolic -c
	if [ -f "mem/mem_init.txt" ]; then rm mem/mem_init.txt; fi
	if [ -f "mem/mem_out.txt" ]; then rm mem/mem_out.txt; fi
	if [ -f "mem/status" ]; then rm mem/status; fi