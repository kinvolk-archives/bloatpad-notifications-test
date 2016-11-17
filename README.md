This is to test notifications with both freedesktop and gtk
GNotification backends in eos-shell.

To use it do `make all && sudo make install && make
install-gsettings`. This will install the bloatpad application and put
two icons in the desktop grid. One for running bloatpad with the
freedesktop GNotification backend and the other one for running
bloatpad with the gtk GNotification backend.
