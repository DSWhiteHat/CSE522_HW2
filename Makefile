#
# File          : Makefile
#

# Environment Setup
LIBDIRS=-L. -L/usr/lib64/
INCLUDES=-I. -I/usr/include/
CC=gcc
AFLDIR=~/CSE522/HW2/afl-2.52b
# remove -DDEBUG to remove debugging output
CFLAGS=-c $(INCLUDES) -g -Wall -DDEBUG
LINK=gcc -g
LDFLAGS=$(LIBDIRS)
AR=ar rc
RANLIB=ranlib

# Suffix rules
.c.o :
	${CC} ${CFLAGS} $< -o $@

#
# Setup builds

TARGETS=vulnerable

all : $(TARGETS)

test : vulnerable.c
	$(CC) $(LDFLAGS) vulnerable.c  -o $@

.PHONY: afl
afl : vulnerable.c
	$(AFLDIR)/afl-gcc $(LDFLAGS) vulnerable.c -o vulnerable

.PHONY: aflfuzz
aflfuzz :
	export AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1; \
	export AFL_SKIP_CPUFREQ=1; \
	$(AFLDIR)/afl-fuzz -i testcase -o output4 ./vulnerable

.PHONY: clean
clean:
	rm -f *.o *~ $(TARGETS)
