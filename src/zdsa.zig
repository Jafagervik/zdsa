const std = @import("std");

pub const Stack = @import("stack.zig").Stack;
pub const Queue = @import("queue.zig").Queue;

test {
    std.testing.refAllDecls(@This());
}
