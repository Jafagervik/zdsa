const std = @import("std");

pub const Stack = @import("stack.zig").Stack;
// pub const Queue = @import("queue.zig").Queue;
// pub const Dequeue = @import("dequeue.zig").Dequeue;

test {
    std.testing.refAllDecls(@This());
}
