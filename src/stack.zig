const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: Allocator,
        data: std.ArrayList(T),

        pub fn init(allocator: Allocator) !Self {
            return .{
                .allocator = allocator,
                .data = std.ArrayList(T).init(allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }

        /// Adds to the top of the stack
        pub fn add(self: *Self, value: T) !void {
            try self.data.append(value);
        }

        /// Pops last element of the list
        /// If the stack is already empty, return null
        pub fn pop(self: *Self) !T {
            if (self.size() < 1) return error.StackEmpty;
            return self.data.pop();
        }

        /// Clears the entire stack
        pub fn clear(self: *Self) void {
            self.data.clearAndFree();
        }

        /// Get the size of the stack
        pub inline fn size(self: *Self) usize {
            return self.data.items.len;
        }
    };
}

test "Stack" {
    const t = std.testing;
    const allocator = t.allocator;

    var stack = try Stack(i32).init(allocator);
    defer stack.deinit();

    try stack.add(1);
    try stack.add(2);
    try stack.add(3);

    try t.expectEqual(3, stack.size());

    const popped = stack.pop() catch unreachable;

    try t.expectEqual(3, popped);
    try t.expectEqual(2, stack.size());

    stack.clear();
    try t.expectEqual(0, stack.size());
}
