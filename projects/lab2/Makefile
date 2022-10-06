IMG_W = 4
IMG_H = 5
FILTER_NUM = 5
FILTER_SIZE = 3
DEBUG = 0

all: build

memory:
	python3 ./scripts/generate_mem.py $(IMG_W) $(IMG_H) $(FILTER_NUM) $(FILTER_SIZE) $(DEBUG)

build: memory
	./../../build.sh -e lab2 -b
	./../../build.sh -e lab2 -s

clean:
	./../../build.sh -e lab2 -c
	if [ -f "mem/mem_init.txt" ]; then rm mem/mem_init.txt; fi
	if [ -f "mem/mem_out.txt" ]; then rm mem/mem_out.txt; fi
	if [ -f "mem/status" ]; then rm mem/status; fi