namegen
=======

Simple CLI command to generate random names suitable for use as usernames or somewhat weak passwords.

## Usage

```
usage: namegen [ <option> ... ]

<option> is one of

  -c, --color
     Use colors instead of cities
  --help, -h
     Show this help
```

## Examples

```
% namegen

AntimonyMerzenich

% namegen -c

TelluriumMauve
```

## Details

Source data lives in `/data` as either JSON or CSV files. These are converted to [FASL](https://docs.racket-lang.org/reference/fasl.html) files for use in the program (so we don't need to do any parsing/conversion when running).

There are additional CLI programs for converting the original data sources:

```
cities-converter.rkt
colors-converter.rkt
periodic-converter.rkt
```


