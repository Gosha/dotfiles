PREFIX ?= $(HOME)/.local

smartword.so: smartword.c
	$(CC) -shared -fPIC -O2 -Wall -Wl,-z,nodelete -o $@ $< -ldl

install: smartword.so
	install -Dm644 smartword.so $(PREFIX)/lib/smartword.so

test: smartword.so
	python3 test.py

clean:
	rm -f smartword.so

.PHONY: install test clean
