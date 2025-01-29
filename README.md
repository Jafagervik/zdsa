# ZDSA - Zig Data structures and algorithms

## Goal

To create a simple collection of DSAs for further use
All should be generic

## Usage

```zig
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var stack = try Stack(i32).init(allocator);
    defer stack.deinit();

    try stack.add(1);
    try stack.add(2);
    try stack.add(3);

    const popped = try stack.pop();

    stack.clear();
}
```

For more, see tests or example folders

## Road to 1.0

- [x] Stack
- [x] Queue
- [x] Dequeue
- [x] Singly Linked List
- [ ] Doubly Linked List
- [ ] Binary Tree

## Install (Per 0.14 beta)

Run this command in the parent directory of your project

```sh
zig fetch --save https://github.com/Jafagervik/zdsa/tarball/v0.4.0
```

Or alternatively use master or another version

Then add these lines to build.zig before b.installArtifact(exe)

```zig
const zdsa = b.dependency("zdsa", .{});

exe.root_module.addImport("zdsa", zdsa.module("zdsa"));

```
