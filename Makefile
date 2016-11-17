# make vars:
# DESTDIR - where to put/remove files during install/uninstall

all: bloatpad org.gtk.bloatpad-gtk.desktop org.gtk.bloatpad-freedesktop.desktop org.gtk.bloatpad-gtk.service org.gtk.bloatpad-freedesktop.service

bloatpad-gresources.c: bloatpad.gresources.xml gtk/menus.ui
	glib-compile-resources --target=$@ --sourcedir=. --generate-source $<

%.o: %.c
	$(CC) -c -Wall -o $@ `pkg-config --cflags gtk+-3.0` $<

bloatpad: bloatpad.o bloatpad-gresources.o
	$(CC) -o $@ $^ `pkg-config --libs gtk+-3.0`

clean:
	NULL= rm -f \
		bloatpad \
		bloatpad.o \
		bloatpad-gresources.c \
		bloatpad-gresources.o \
		org.gtk.bloatpad-gtk.desktop \
		org.gtk.bloatpad-freedesktop.desktop \
		org.gtk.bloatpad-gtk.service \
		org.gtk.bloatpad-freedesktop.service \
		$${NULL}

org.gtk.bloatpad-%.desktop: org.gtk.bloatpad.desktop
	sed -e 's/%GNB%/$*/g' $< >$@.tmp
	mv -f $@.tmp $@

org.gtk.bloatpad-%.service: org.gtk.bloatpad.service
	sed -e 's/%GNB%/$*/g' $< >$@.tmp
	mv -f $@.tmp $@

install: all
	if test ! -d $(DESTDIR)/usr/bin; then mkdir -p $(DESTDIR)/usr/bin; fi
	install --mode=0755 bloatpad $(DESTDIR)/usr/bin
	if test ! -d $(DESTDIR)/usr/share/applications; then mkdir -p $(DESTDIR)/usr/share/applications; fi
	install --mode=0644 org.gtk.bloatpad-gtk.desktop org.gtk.bloatpad-freedesktop.desktop $(DESTDIR)/usr/share/applications
	if test ! -d $(DESTDIR)/usr/share/dbus-1/services; then mkdir -p $(DESTDIR)/usr/share/dbus-1/services; fi
	install --mode=0644 org.gtk.bloatpad-gtk.service org.gtk.bloatpad-freedesktop.service $(DESTDIR)/usr/share/dbus-1/services

install-gsettings:
	SETTING=`gsettings get org.gnome.shell icon-grid-layout | sed -e "s/\('desktop': \[\)/\1'org.gtk.bloatpad-gtk.desktop', 'org.gtk.bloatpad-freedesktop.desktop', /"` && gsettings set org.gnome.shell icon-grid-layout "$${SETTING}"

uninstall:
	NULL= rm -f \
		$(DESTDIR)/usr/bin/bloatpad \
		$(DESTDIR)/usr/share/applications/org.gtk.bloatpad-gtk.desktop \
		$(DESTDIR)/usr/share/applications/org.gtk.bloatpad-freedesktop.desktop \
		$(DESTDIR)/usr/share/dbus-1/services/org.gtk.bloatpad-gtk.service \
		$(DESTDIR)/usr/share/dbus-1/services/org.gtk.bloatpad-freedesktop.service \
		$${NULL}

uninstall-gsettings:
	SETTING=`gsettings get org.gnome.shell icon-grid-layout | sed -e "s/'org.gtk.bloatpad-gtk.desktop', 'org.gtk.bloatpad-freedesktop.desktop', //"` && gsettings set org.gnome.shell icon-grid-layout "$${SETTING}"


.PHONY: all clean install uninstall install-gsettings uninstall-gsettings
