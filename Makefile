
default: check doc

.PHONY: check doc install

doc: check
	pod2man --release="farg" --name="farg" --center=" " farg.1.pod > farg.1

check:
	shellcheck farg.sh
	podchecker farg.1.pod

install: doc
	install -m755 -D farg.sh $(DESTDIR)/usr/bin/farg
	install -m644 -D farg.1 $(DESTDIR)/usr/share/man/man1/farg.1
