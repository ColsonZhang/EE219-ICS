# =====================================
# You can modify the code here
# =====================================

# your ASM file name
IMG=task1
# use the transposed result or not
TRANSPOSE=false

# =====================================
# DO NOT Modify the below code
# =====================================
PROJECT_NAME=$(notdir $(CURDIR:%/=%))
PROJECT_SRC=$(PROJECT_NAME)/src

ASM_FILE:=$(IMG).asm
BIN_FILE:=$(IMG).bin 

IMG_FILE=ramdata.txt
DUMP1_FILE=dumpdata_D.txt
DUMP2_FILE=dumpdata_DT.txt
DUMP3_FILE=dumpdata_task1.txt
DUMP4_FILE=dumpdata_task3.txt

TOP_PATH=$(shell pwd)

ASM_FOLDER:=$(TOP_PATH)/asm/
BIN_FOLDER:=$(TOP_PATH)/bin/
DATA_FOLDER:=$(TOP_PATH)/data/

ASM_FULLPATH:=$(ASM_FOLDER)$(ASM_FILE)
BIN_FULLPATH:=$(BIN_FOLDER)$(BIN_FILE)

INST_FULLPATH:=$(BIN_FULLPATH)
IMG_PULLPATH:=$(DATA_FOLDER)$(IMG_FILE)
DUMP1_PULLPATH:=$(DATA_FOLDER)$(DUMP1_FILE)
DUMP2_PULLPATH:=$(DATA_FOLDER)$(DUMP2_FILE)
DUMP3_PULLPATH:=$(DATA_FOLDER)$(DUMP3_FILE)
DUMP4_PULLPATH:=$(DATA_FOLDER)$(DUMP4_FILE)

build: compile
	./../../build.sh -e $(PROJECT_SRC) -b 

sim: build 
	./../../build.sh -e $(PROJECT_SRC) -s -a "$(INST_FULLPATH) $(IMG_PULLPATH) $(DUMP1_PULLPATH) $(DUMP2_PULLPATH) $(DUMP3_PULLPATH) $(DUMP4_PULLPATH)"

clean:
	-rm -r ./src/build_test/emu-compile 
	-rm ./src/build_test/emu

clear:
	-rm -r ./src/build_test

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
	python ./tools/MatrixGen.py -r $(DATA_FOLDER)/ramdata.txt -t $(DATA_FOLDER)/testdata.txt -T $(DATA_FOLDER)/testdata_T.txt

test_inst:
ifeq ($(IMG), task1)
	python ./tools/TestInst1.py -d $(DUMP3_PULLPATH)
else
	python ./tools/TestInst2.py -d $(DUMP4_PULLPATH)
endif

test_mac: 
ifeq ($(TRANSPOSE), true)
	python ./tools/TestMac.py -d $(DUMP2_PULLPATH) -t $(DATA_FOLDER)/testdata_T.txt
else
	python ./tools/TestMac.py -d $(DUMP1_PULLPATH) -t $(DATA_FOLDER)/testdata.txt
endif 


ifneq ($(findstring $(IMG),  task2  task4),)
test: test_mac
else
test: test_inst
endif

run: clean matrix compile sim test
	@echo Done

pack:
	@git log > log.txt
	@git log -p > log_p.txt
	tar -zcvf $(TOP_PATH)/../$(PROJECT_NAME).tar.gz ../$(PROJECT_NAME)

