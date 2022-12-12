# =====================================
# You can modify the code here
# =====================================

# your ASM file name
NAME=hello-str

IMG_SUFFIX=-riscv64-mycpu
IMG=$(NAME)$(IMG_SUFFIX)
# =====================================
# DO NOT Modify the below code
# =====================================
TOP_PATH=$(shell pwd)
PROJECT_NAME=$(notdir $(CURDIR:%/=%))
PROJECT_SRC=$(PROJECT_NAME)/hw
BIN_FOLDER:=$(TOP_PATH)/sw/build/

BIN_FILE:=$(IMG).bin 
BIN_FULLPATH:=$(BIN_FOLDER)$(BIN_FILE)
INST_FULLPATH:=$(BIN_FULLPATH)

build:
	./../../build.sh -e $(PROJECT_SRC) -b 

sim: build 
	./../../build.sh -e $(PROJECT_SRC) -s -a "$(INST_FULLPATH) $(IMG_PULLPATH) $(DUMP1_PULLPATH) $(DUMP2_PULLPATH) $(DUMP3_PULLPATH) $(DUMP4_PULLPATH)"

clean:
	-rm -r ./hw/build_test/emu-compile 
	-rm ./hw/build_test/emu

clear:
	-rm -r ./hw/build_test

run: clear sim
	@echo Done

pack:
	@git log > log.txt
	@git log -p > log_p.txt
	tar -zcvf $(TOP_PATH)/../$(PROJECT_NAME).tar.gz ../$(PROJECT_NAME)

