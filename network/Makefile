CC=cc
CFLAGS=-std=c99
LIBS=-lfann -lm
TARGETS:=urnn_train urnn_run urnn_train_reverse urnn_run_reverse

all:
	@for target in $(TARGETS); do \
		$(CC) $$target.c -o $$target $(LIBS) $(CFLAGS); \
	done
