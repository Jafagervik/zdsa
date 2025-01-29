const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: Allocator,
        data: std.ArrayList(T),

        pub fn init(allocator: Allocator) Self {
            return .{
                .allocator = allocator,
                .data = std.ArrayList(T).init(allocator),
            };
        }

        /// Initialize from already existing arraylist
        pub fn from_arraylist(d: std.ArrayList(T)) Self {
            return .{
                .allocator = d.allocator,
                .data = d,
            };
        }

        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }

        /// Pushes to the top of the stack
        pub fn push(self: *Self, value: T) !void {
            try self.data.append(value);
        }

        /// Pops last element of the list
        /// If the stack is already empty, return null
        pub fn pop(self: *Self) !T {
            if (self.size() < 1) return error.StackEmpty;
            return self.data.pop();
        }

        /// Returns the top of the stack without removing it
        pub inline fn top(self: *Self) !T {
            if (self.size() < 1) return error.StackEmpty;
            return self.data.getLast();
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

    var stack = Stack(i32).init(allocator);
    defer stack.deinit();

    try stack.push(1);
    try stack.push(2);
    try stack.push(3);

    try t.expectEqual(3, stack.size());

    try t.expectEqual(3, stack.top());

    const popped = stack.pop() catch unreachable;

    try t.expectEqual(3, popped);
    try t.expectEqual(2, stack.size());

    stack.clear();
    try t.expectEqual(0, stack.size());
}

test "from" {
    const t = std.testing;
    const allocator = t.allocator;

    var al = std.ArrayList(i32).init(allocator);
    // We do not defer a deinit here, as stack takes ownership

    try al.append(1);
    try al.append(1);
    try al.append(1);

    try t.expectEqual(3, al.items.len);

    var stack = Stack(i32).from_arraylist(al);
    defer stack.deinit();

    try t.expectEqual(3, stack.size());

    try stack.push(4);

    try t.expectEqual(4, stack.size());
}
