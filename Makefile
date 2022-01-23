PROG ?= check
PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(PREFIX)/share/man

SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions

BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions

all:
	@echo "pass-$(PROG) is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo

install:
	@install -vd "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/" "$(DESTDIR)$(MANDIR)/man1" \
				 "$(DESTDIR)$(BASHCOMPDIR)"
	@install -vm 0755 "src/$(PROG).bash" "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash"
	@install -vm 0644 "pass-$(PROG).1" "$(DESTDIR)$(MANDIR)/man1/pass-$(PROG).1"
	@install -vm 0644 "src/completions/pass-$(PROG)" "$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)"
	@echo
	@echo "pass-$(PROG) is installed succesfully"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash" \
		"$(DESTDIR)$(MANDIR)/man1/pass-$(PROG).1" \
		"$(DESTDIR)$(ZSHCOMPDIR)/_pass-$(PROG)" \
		"$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)"

