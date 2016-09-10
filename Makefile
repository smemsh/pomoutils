#

SCRIPTS = $(shell find -mindepth 1 -maxdepth 1 -type f -perm -01)
SYMLINKS = $(shell find -mindepth 1 -maxdepth 1 -type l)
PREFIX = ${HOME}
INSTALLDIR = $(PREFIX)/bin

none:

install:
	@test -d $(INSTALLDIR)
	@cp -av $(SCRIPTS) $(SYMLINKS) $(INSTALLDIR)/
	@echo "installed to $(INSTALLDIR)"
