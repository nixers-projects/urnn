PREFIX=/usr/local
MANDIR=/usr/share/man
BIN_NAME=urnn

CFLAGS=-std=c99
LIBS=-lfann -lm


all:
	$(CC) src/main.c -o $(BIN_NAME) $(LIBS) $(CFLAGS);

debug:
	$(CC) src/main.c -o $(BIN_NAME) $(LIBS) $(CFLAGS);

clean:
	rm $(BIN_NAME)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN_NAME);

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BIN_NAME) $(DESTDIR)$(PREFIX)/bin

