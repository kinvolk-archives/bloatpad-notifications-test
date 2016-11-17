all: bloatpad

bloatpad-gresources.c: bloatpad.gresources.xml gtk/menus.ui
	glib-compile-resources --target=$@ --sourcedir=. --generate-source $<

%.o: %.c
	$(CC) -c -Wall -o $@ `pkg-config --cflags gtk+-3.0` $<

bloatpad: bloatpad.o bloatpad-gresources.o
	$(CC) -o $@ `pkg-config --libs gtk+-3.0` $<

clean:
	rm -f bloatpad bloatpad.o bloatpad-gresources.c bloatpad-gresources.o

.PHONY: all clean
