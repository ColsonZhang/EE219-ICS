# =====================================
# You can modify the code here
# =====================================

# your ASM file name
IMG_NAME=demo

# =====================================
# DO NOT Modify the below code
# =====================================
PROJECT_NAME=$(notdir $(CURDIR:%/=%))

ASM_FILE:=$(IMG_NAME).asm
BIN_FILE:=$(IMG_NAME).bin 

IMG_FILE=ramdata.txt
DUMP_FILE=dumpdata.txt

TOP_PATH=$(shell pwd)

ASM_FOLDER:=$(TOP_PATH)/asm/
BIN_FOLDER:=$(TOP_PATH)/bin/
DATA_FOLDER:=$(TOP_PATH)/data/

ASM_FULLPATH:=$(ASM_FOLDER)$(ASM_FILE)
BIN_FULLPATH:=$(BIN_FOLDER)$(BIN_FILE)

INST_FULLPATH:=$(BIN_FULLPATH)
IMG_PULLPATH:=$(DATA_FOLDER)$(IMG_FILE)
DUMP_PULLPATH:=$(DATA_FOLDER)$(DUMP_FILE)


build: compile
	./../../build.sh -e $(PROJECT_NAME) -b 

sim: build 
	./../../build.sh -e $(PROJECT_NAME) -s -a "$(INST_FULLPATH) $(IMG_PULLPATH) $(DUMP_PULLPATH)"

clean:
	-rm -r ./build_test/emu-compile 
	-rm ./build_test/emu

clear:
	-rm -r build_test

compile:
ifneq ($(wildcard $(ASM_FULLPATH)),)
	python ./tools/Compile.py -i $(ASM_FULLPATH) -o $(BIN_FULLPATH)
else
	@echo File $(ASM_FULLPATH) does not exist.
ifneq ($(wildcard $(BIN_FULLPATH)),)
	@echo But file $(BIN_FULLPATH) already exists.
endif

endif

matrix:
	python ./tools/MatrixGen.py -r $(DATA_FOLDER)/ramdata.txt -t $(DATA_FOLDER)/testdata.txt

test: 
	python ./tools/Test.py -d $(DATA_FOLDER)/dumpdata.txt -t $(DATA_FOLDER)/testdata.txt

run: clean matrix compile sim test
	@echo Done

pack:
	@git log > log.txt
	@git log -p > log_p.txt
	tar -zcvf $(TOP_PATH)/../$(PROJECT_NAME).tar.gz ../$(PROJECT_NAME)

