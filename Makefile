
LUA     := lua
VERSION := $(shell cd src && $(LUA) -e "m = require [[Test.More]]; print(m._VERSION)")
TARBALL := lua-testmore-$(VERSION).tar.gz
REV     := 1

LUAVER  := 5.1
PREFIX  := /usr/local
DPREFIX := $(DESTDIR)$(PREFIX)
LIBDIR  := $(DPREFIX)/share/lua/$(LUAVER)
INSTALL := install

all:
	@echo "Nothing to build here, you can just make install"

install:
	$(INSTALL) -m 644 -D src/Test/More.lua                  $(LIBDIR)/Test/More.lua
	$(INSTALL) -m 644 -D src/Test/Builder.lua               $(LIBDIR)/Test/Builder.lua
	$(INSTALL) -m 644 -D src/Test/Builder/SocketOutput.lua  $(LIBDIR)/Test/Builder/SocketOutput.lua
	$(INSTALL) -m 644 -D src/Test/Builder/Tester.lua        $(LIBDIR)/Test/Builder/Tester.lua
	$(INSTALL) -m 644 -D src/Test/Builder/Tester/File.lua   $(LIBDIR)/Test/Builder/Tester/File.lua

uninstall:
	rm -f $(LIBDIR)/Test/More.lua
	rm -f $(LIBDIR)/Test/Builder.lua
	rm -f $(LIBDIR)/Test/Builder/SocketOutput.lua
	rm -f $(LIBDIR)/Test/Builder/Tester.lua
	rm -f $(LIBDIR)/Test/Builder/Tester/File.lua

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
    next if m{/\.}; \
    next if m{^doc/\.}; \
    next if m{^doc/cover}; \
    next if m{^doc/google}; \
    next if m{^doc/lua}; \
    next if m{^rockspec/}; \
    push @files, $$_; \
} \
print join qq{\n}, sort @files;

rockspec_pl := \
use strict; \
use warnings; \
use Digest::MD5; \
open my $$FH, q{<}, q{$(TARBALL)} \
    or die qq{Cannot open $(TARBALL) ($$!)}; \
binmode $$FH; \
my %config = ( \
    version => q{$(VERSION)}, \
    rev     => q{$(REV)}, \
    md5     => Digest::MD5->new->addfile($$FH)->hexdigest(), \
); \
close $$FH; \
while (<>) { \
    s{@(\w+)@}{$$config{$$1}}g; \
    print; \
}

version:
	@echo $(VERSION)

CHANGES: dist.info
	perl -i.bak -pe "s{^$(VERSION).*}{q{$(VERSION)  }.localtime()}e" CHANGES

dist.info:
	perl -i.bak -pe "s{^version.*}{version = \"$(VERSION)\"}" dist.info

tag:
	git tag -a -m 'tag release $(VERSION)' $(VERSION)

doc:
	git read-tree --prefix=doc/ -u remotes/origin/gh-pages

MANIFEST: doc
	git ls-files | perl -e '$(manifest_pl)' > MANIFEST

$(TARBALL): MANIFEST
	[ -d lua-TestMore-$(VERSION) ] || ln -s . lua-TestMore-$(VERSION)
	perl -ne 'print qq{lua-TestMore-$(VERSION)/$$_};' MANIFEST | \
	    tar -zc -T - -f $(TARBALL)
	rm lua-TestMore-$(VERSION)
	rm -rf doc
	git rm doc/*

dist: $(TARBALL)

rockspec: $(TARBALL)
	perl -e '$(rockspec_pl)' rockspec.in > rockspec/lua-testmore-$(VERSION)-$(REV).rockspec

check: test

test:
	cd src && prove --exec=$(LUA) ../test/*.t ../test/subtest/*.t

coverage:
	rm -f src/luacov.stats.out src/luacov.report.out
	cd src && prove --exec="$(LUA) -lluacov" ../test/*.t ../test/subtest/*.t
	cd src && luacov

coveralls:
	rm -f src/luacov.stats.out src/luacov.report.out
	cd src && prove --exec="$(LUA) -lluacov" ../test/*.t ../test/subtest/*.t
	cd src && luacov-coveralls -v

README.html: README.md
	Markdown.pl README.md > README.html

clean:
	rm -rf doc
	rm -f MANIFEST *.bak src/luacov.*.out README.html

realclean: clean

.PHONY: test rockspec CHANGES dist.info

