# Aoc

An Advent of Code puzzle engine for OCaml.

## Features
- Run Advent of Code puzzle solutions

## Prerequisites
- OCaml toolchain (>= 5.4.0)
- OPAM
- Dune
- Direnv (to automatically enable the `aoc` command)
- libcurl-devel

## Installation
From your command line:
```
# Clone the repository
$ git clone https://github.com/rhdCode0x7C3/aoc

# Enter the repository
$ cd aoc

# Install dependencies
$ opam install aoc --deps-only

# Build the project
$ dune build
```

All commands should then be run from the project root directory.

## Usage
aoc exposes the following commands:
- `run` Run a puzzle solution

## License
MIT
