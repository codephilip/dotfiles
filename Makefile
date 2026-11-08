# =========================================================
# Dotfiles
#
#   make install   symlink configs into place, report missing tools
#   make verify    dry-run of install; changes nothing
#   make tools     print the brew install lines for a new machine (macOS or Linux)
#   make windows   install everything on Windows (scoop + MSYS2 zsh/tmux)
#   make serve     live-reload docs at http://127.0.0.1:8000
#   make docs      build the static site into ./site
#   make readme    check the README tool table covers every tool in bootstrap
#   make pdf       render the executive brief to PDF
#   make all       docs + pdf
# =========================================================

SHELL      := /bin/bash
BRIEF_SRC  := brief/executive-brief.html
BRIEF_PDF  := docs/assets/executive-brief.pdf
# Override on Linux: make pdf CHROME=google-chrome (or chromium)
CHROME     ?= /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

.PHONY: all install verify tools windows serve docs readme pdf clean check help

help:
	@grep -E '^#   make' $(MAKEFILE_LIST) | sed 's/^#   //'

all: pdf docs

install:
	@./bootstrap

verify:
	@./bootstrap --check

# Prints the brew lines from bootstrap's own BREW_FORMULAE/BREW_CASKS,
# so there is nowhere for a second copy of the list to drift.
tools:
	@./bootstrap --tools

# bootstrap is Homebrew/macOS-only; this is the Windows equivalent.
windows:
	@./scripts/windows-setup

serve:
	mkdocs serve

docs: readme pdf
	mkdocs build --strict

# The README describes every tool in bootstrap. The list itself stays in
# bootstrap; this only fails when a tool there has no row in the README.
readme:
	@missing=$$(./bootstrap --tools | sed 's/^brew install //; s/^--cask //' | grep -v '^\#' | tr ' ' '\n' \
		| grep . | while read -r t; do grep -q "\`$$t\`" README.md || echo "$$t"; done); \
	if [ -n "$$missing" ]; then echo "✗ in bootstrap but not in the README Tools table:" $$missing; exit 1; fi; \
	echo "✓ README lists every bootstrap tool"

# Chrome headless is the only PDF renderer on this machine. --no-pdf-header-footer
# drops the default URL/date chrome; the @media print block in the HTML handles
# page breaks and colour.
pdf: $(BRIEF_PDF)

$(BRIEF_PDF): $(BRIEF_SRC)
	@# The PDF is committed, so a machine without Chrome (most Linux boxes)
	@# keeps the tracked copy instead of failing the docs build.
	@if ! command -v "$(CHROME)" >/dev/null 2>&1 && [ ! -x "$(CHROME)" ]; then \
		if [ -s $@ ]; then echo "! Chrome not found — keeping committed $@"; touch $@; exit 0; \
		else echo "✗ Chrome not found and no committed PDF (set CHROME=...)"; exit 1; fi; \
	fi
	@mkdir -p $(dir $@)
	@echo "→ rendering $< to $@"
	@"$(CHROME)" \
		--headless \
		--disable-gpu \
		--no-pdf-header-footer \
		--print-to-pdf-no-header \
		--print-to-pdf="$(CURDIR)/$@" \
		"file://$(CURDIR)/$<" 2>/dev/null || true
	@test -s $@ && echo "✓ $@ ($$(du -h $@ | cut -f1))" || (echo "✗ PDF render failed"; exit 1)

check:
	@command -v mkdocs >/dev/null || { echo "mkdocs missing: brew install mkdocs-material"; exit 1; }
	@test -x "$(CHROME)" || { echo "Google Chrome not found - needed for make pdf"; exit 1; }
	@echo "✓ toolchain ok"

clean:
	rm -rf site $(BRIEF_PDF)
