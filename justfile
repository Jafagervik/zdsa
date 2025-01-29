alias c := cover
alias t := test
alias b := build

cover:
    @zig build cover

test:
    @zig build test

build:
    @zig build
