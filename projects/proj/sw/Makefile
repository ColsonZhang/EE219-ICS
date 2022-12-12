.PHONY: all run clean latest $(ALL)

ARCH=riscv64-mycpu

ALL=$(basename $(notdir $(shell find src/. -name "*.c")))

all: $(addprefix Makefile., $(ALL))
	echo "" $(ALL)

$(ALL): %: Makefile.%

Makefile.%: src/%.c latest
	/bin/echo -e "NAME = $*\nSRCS = $<\nLIBS += klib\ninclude $${AM_HOME}/Makefile" > $@
	make -s -f $@ ARCH=$(ARCH) $(MAKECMDGOALS)
	rm -f Makefile.$*

run: all

clean:
	rm -rf Makefile.* build/

latest:
