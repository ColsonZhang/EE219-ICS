TOP_PATH=$(shell pwd)
# =====================================
# You can modify the code here
# =====================================
# Instruction
NAME=hello-str
# Data-Image
DATA=fc1
# Save-File-Name
SAVE=data

# only for hello-str
# INST_FOLDER:=$(TOP_PATH)/data/bin/
INST_FOLDER:=$(TOP_PATH)/sw/build/
DATA_FOLDER:=$(TOP_PATH)/data/bin/
# =====================================
# DO NOT Modify the below code
# =====================================
PROJECT_NAME=$(notdir $(CURDIR:%/=%))
PROJECT_SRC=$(PROJECT_NAME)/hw

IMG_SUFFIX=-riscv64-mycpu
IMG=$(NAME)$(IMG_SUFFIX)
INST_FILE:=$(IMG).bin 
INST_FULLPATH:=$(INST_FOLDER)$(INST_FILE)

DATA_FULLPATH:=$(DATA_FOLDER)$(DATA).bin 
SAVE_FULLPATH:=$(DATA_FOLDER)$(SAVE).bin 

build:
	./../../build.sh -e $(PROJECT_SRC) -b 

sim: build 
	./../../build.sh -e $(PROJECT_SRC) -s -a "$(INST_FULLPATH) $(IMG_PULLPATH) $(DATA_FULLPATH) $(SAVE_FULLPATH) "

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

