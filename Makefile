SRC_DIR := ./src
INCLUDE_DIR := ./include

CC	= gcc
AR	= ar
W	= -W -Wall -Wno-unused-parameter -Wbad-function-cast -Wuninitialized
THREADS = -pthread
OPT = -O2 -g
INCLUDES = -I$(INCLUDE_DIR)
CFLAGS	= $(THREADS) $(OPT) $(W) $(XCFLAGS) $(INCLUDES)
SOEXT	= .so
LDLIBS	=
SOLIBS	=


all: liblmdb.a liblmdb$(SOEXT)

liblmdb.a:	mdb.o midl.o
	$(AR) rs $@ mdb.o midl.o

liblmdb$(SOEXT): mdb.lo midl.lo
#	$(CC) $(LDFLAGS) -pthread -shared -Wl,-Bsymbolic -o $@ mdb.o midl.o $(SOLIBS)
	$(CC) $(LDFLAGS) -pthread -shared -o $@ mdb.lo midl.lo $(SOLIBS)

mdb.o: $(SRC_DIR)/mdb.c $(INCLUDE_DIR)/lmdb.h $(SRC_DIR)/midl.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $(SRC_DIR)/mdb.c

midl.o: $(SRC_DIR)/midl.c $(SRC_DIR)/midl.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $(SRC_DIR)/midl.c

mdb.lo: $(SRC_DIR)/mdb.c $(INCLUDE_DIR)/lmdb.h $(SRC_DIR)/midl.h
	$(CC) $(CFLAGS) -fPIC $(CPPFLAGS) -c $(SRC_DIR)/mdb.c -o $@

midl.lo: $(SRC_DIR)/midl.c $(SRC_DIR)/midl.h
	$(CC) $(CFLAGS) -fPIC $(CPPFLAGS) -c $(SRC_DIR)/midl.c -o $@

clean:
	rm -rf $(PROGS) *.[ao] *.[ls]o *~ testdb
