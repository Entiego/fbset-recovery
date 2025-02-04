#
# Linux Frame Buffer Device Configuration (with AARCH32 and AARCH64 support)
#

# default is arm64
ARCH ?= aarch64

# choose compiler
ifeq ($(ARCH), aarch32)
  CC = arm-linux-gnueabihf-gcc -Wall -O2 -I.  # AARCH32 (32-bit ARM -- ARMv6 and ARMv7)
else
  CC = aarch64-linux-gnu-gcc -Wall -O2 -I.  # AARCH64 (64-bit ARM -- ARMv8-A and ARMv9-A)
endif

BISON =        bison -d
FLEX =         flex
INSTALL =      ginstall
RM =           rm -f
LDFLAGS =      -static  # static linking flag

all:        fbset

fbset:      fbset.o modes.tab.o lex.yy.o
	$(CC) $(LDFLAGS) fbset.o modes.tab.o lex.yy.o -o fbset  # link statically
# rest is same
fbset.o:    fbset.c fbset.h fb.h
modes.tab.o:    modes.tab.c fbset.h fb.h
lex.yy.o:   lex.yy.c fbset.h modes.tab.h

lex.yy.c:   modes.l
	$(FLEX) modes.l

modes.tab.c:    modes.y
	$(BISON) modes.y
modes.tab.h:    modes.tab.c

install:	fbset
		@echo "The install option have been removed so that user wont install unsupported binary to their machine"

clean:
	$(RM) *.o fbset lex.yy.c modes.tab.c modes.tab.h
