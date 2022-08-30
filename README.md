namegen
=======

Simple CLI command to generate random names suitable for use as usernames or somewhat weak passwords.

## Usage

```
usage: namegen [ <option> ... ]

<option> is one of

  -c, --color
     Use colors instead of cities
  -r, --release
     Generate Ubuntu style release name (ex: chubbyCesium)
  --help, -h
     Show this help
```

## Examples

```
% namegen

AntimonyMerzenich

% namegen -c

TelluriumMauve

% namegen -r

limpingLanthanum
```

## Install

1. You will need [Racket](https://racket-lang.org/) because Lisp is the Way.
2. Update `BIN-DIR` in `Makefile` with the directory you keep your CLI scripts in.
3. `make install`
4. `make build`
5. Update your `$PATH` to include `$(BIN-DIR)/namegen/bin`

## Details

Source data lives in `/data` as either JSON or CSV files. These are converted to [FASL](https://docs.racket-lang.org/reference/fasl.html) files for use in the program (so we don't need to do any parsing/conversion when running).

There are additional CLI programs for converting the original data sources:

```
adjectives-converter.rkt
cities-converter.rkt
colors-converter.rkt
periodic-converter.rkt
```


