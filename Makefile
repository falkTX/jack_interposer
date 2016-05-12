
CC  ?= gcc
CXX ?= g++

CFLAGS  += $(shell pkg-config --cflags jack)
LDFLAGS += $(shell pkg-config --libs jack)

TESTS=test_new test_cond_wait test_cond_wait_simple test_printf

all: jack_interposer.so

jack_interposer.so: jack_interposer.c checkers.c manual.c
	$(CC) $< -o $@ $(CFLAGS) -Wall -fPIC $(LDFLAGS) -Wl,--no-undefined -shared -pthread -ldl

checkers.c: functions checker_fragment.c
	./generate_checkers.pl < functions

.PHONY clean:
	rm -f jack_interposer.so test_cond_wait test_cond_wait_simple

test: $(TESTS) jack_interposer.so
	LD_PRELOAD=./jack_interposer.so ./test_cond_wait_simple
	LD_PRELOAD=./jack_interposer.so ./test_cond_wait
	LD_PRELOAD=./jack_interposer.so ./test_new
	LD_PRELOAD=./jack_interposer.so ./test_printf

test_new: test_new.cpp
	$(CXX) $< -o $@ $(CFLAGS) $(LDFLAGS)

test_cond_wait_simple: test_cond_wait_simple.c
	$(CC) $< -o $@ $(CFLAGS) $(LDFLAGS) -pthread -ldl

test_cond_wait: test_cond_wait.c
	$(CC) $< -o $@ $(CFLAGS) $(LDFLAGS) -pthread

test_printf: test_printf.c
	$(CC) $< -o $@ $(CFLAGS) $(LDFLAGS)
