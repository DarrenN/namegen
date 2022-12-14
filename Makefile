.PHONY: build clean

BLUE=\n\033[0;34m

PACKAGE-NAME=namegen

BUILD-DIR=build

BIN-DIR=/Users/yuzu/bin

# Racket 6.1 adds pkg dep checking.
ifeq ($(findstring "$(RACKET_VERSION)", "6.0", "6.0.1"),)
	DEPS-FLAGS=--check-pkg-deps --unused-pkg-deps
else
	DEPS-FLAGS=
endif

ifeq ($(findstring "$(OSTYPE)", "linux-gnu"), "linux-gnu")
	CMD=raco exe --orig-exe -o $(PACKAGE-NAME) main.rkt
else
	CMD=raco exe -o $(PACKAGE-NAME) main.rkt
endif

all: setup

# Setup, build and moves to BIN-DIR
build:
	@echo "$(BLUE) @@@ (build) Building distributable..."
	raco make main.rkt
	$(CMD)
	mkdir -p $(BUILD-DIR)
	raco distribute $(BUILD-DIR) $(PACKAGE-NAME)
	rm $(PACKAGE-NAME)
	cp -r $(BUILD-DIR) $(BIN-DIR)/$(PACKAGE-NAME)

# Primarily for use by CI.
# Installs dependencies as well as linking this as a package.
install:
	raco pkg install --deps search-auto

remove:
	raco pkg remove $(PACKAGE-NAME)

# Primarily for day-to-day dev.
# Note: Also builds docs (if any) and checks deps.
setup:
	raco setup --tidy $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

# Note: Each collection's info.rkt can say what to clean, for example
# (define clean '("compiled" "doc" "doc/<collect>")) to clean
# generated docs, too.
clean:
	raco setup --fast-clean --pkgs $(PACKAGE-NAME)
	@echo "Removing build files"
	rm -rf $(BUILD-DIR)

# Primarily for use by CI, after make install -- since that already
# does the equivalent of make setup, this tries to do as little as
# possible except checking deps.
check-deps:
	raco setup --no-docs $(DEPS-FLAGS) $(PACKAGE-NAME)

# Suitable for both day-to-day dev and CI
test:
	raco test -x -p $(PACKAGE-NAME)
