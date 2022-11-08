IMG_W = 4
IMG_H = 3
FILTER_NUM = 5
FILTER_SIZE = 3
DEBUG = 0

all: test

memory:
	python3 ./scripts/generate_mem.py $(IMG_W) $(IMG_H) $(FILTER_NUM) $(FILTER_SIZE) $(DEBUG)

test: sim
	python3 ./scripts/test.py $(IMG_W) $(IMG_H) $(FILTER_NUM) $(FILTER_SIZE)

sim: memory
	./../../build.sh -e lab2 -b
	./../../build.sh -e lab2 -s

clean:
	./../../build.sh -e lab2 -c
	if [ -f "mem/mem_init.txt" ]; then rm -rf mem/mem_init.txt; fi
	if [ -f "mem/mem_out.txt" ]; then rm -rf mem/mem_out.txt; fi

