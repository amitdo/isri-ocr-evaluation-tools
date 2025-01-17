include common.mk

TOOLS = accci accdist accsum accuracy editop editopcost editopsum \
		groupacc ngram nonstopacc synctext vote wordacc wordaccci \
		wordaccdist wordaccsum wordfreq

PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

EXECUTABLES = $(foreach D,$(TOOLS),$D/$D)
MANPAGES = $(EXECUTABLES:=.1)
LIB = Modules

all: $(TOOLS)

# Create every subexecutable.
$(TOOLS): $(LIB)
	$(MAKE) -C $@

$(LIB): Modules/word_break_property.h
	$(MAKE) -C $@

install: install-bin install-man

install-bin: $(TOOLS)
	mkdir -p $(BINDIR)
	cp $(EXECUTABLES) $(BINDIR)/

install-man: $(TOOLS)
	mkdir -p $(MANDIR)
	cp $(MANPAGES) $(MANDIR)/

clean: clean-lib clean-execs

clean-lib:
	$(MAKE) -C Modules clean

clean-execs:
	$(RM) $(EXECUTABLES)

TEST_ARGS =
test: $(LIB)
	$(MAKE) -C Tests

# Uses https://github.com/alexch/rerun
# $ gem install rerun
watch:
	rerun --clear --exit --pattern '**/*.{c,h}' -- make test

# Generate the include file, required by libisri.a
Modules/word_break_property.h: Supplement/generate_word_break.py Supplement/WordBreakProperty.txt.gz
	./$< > $@

.PHONY: all clean clean-lib clean-execs install install-bin install-bin
.PHONY: test watch
# Always remake subdirs.
.PHONY: $(LIB) $(MODULES)
