const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn Dequeue(comptime T: type) type {
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

        /// Adds to the back of the dequeue
        pub fn add_front(self: *Self, value: T) !void {
            try self.data.insert(0, value);
        }

        /// Adds to the back of the dequeue
        pub fn add_back(self: *Self, value: T) !void {
            try self.data.append(value);
        }

        /// Pops the front element of the dequeue
        /// If the dequeue is already empty, return null
        pub fn pop_front(self: *Self) !T {
            if (self.size() < 1) return error.StackEmpty;
            return self.data.orderedRemove(0);
        }

        /// Pops the front element of the dequeue
        /// If the dequeue is already empty, return null
        pub fn pop_back(self: *Self) !T {
            if (self.size() < 1) return error.StackEmpty;
            return self.data.pop();
        }

        /// Returns the front of the queue without removing it
        pub inline fn front(self: *Self) !T {
            if (self.size() < 1) return error.QueueEmpty;
            return self.data.items[0];
        }

        /// Returns the back of the dequeue without removing it
        pub inline fn back(self: *Self) !T {
            if (self.size() < 1) return error.QueueEmpty;
            return self.data.getLast();
        }

        /// Clears the entire dequeue
        pub fn clear(self: *Self) void {
            self.data.clearAndFree();
        }

        /// Get the size of the dequeue
        pub inline fn size(self: *Self) usize {
            return self.data.items.len;
        }
    };
}

test "Dequeue" {
    const t = std.testing;
    const allocator = t.allocator;

    var queue = Dequeue(i32).init(allocator);
    defer queue.deinit();

    try queue.add_back(1);
    try queue.add_front(2);
    try queue.add_back(3);

    try t.expectEqual(3, queue.size());
    try t.expectEqual(2, queue.front());

    const popped = queue.pop_front() catch unreachable;

    try t.expectEqual(2, popped);

    try t.expectEqual(2, queue.size());

    queue.clear();
    try t.expectEqual(0, queue.size());
}

test "from" {
    const t = std.testing;
    const allocator = t.allocator;

    var al = std.ArrayList(i32).init(allocator);
    // We do not defer a deinit here, as queue takes ownership

    try al.append(1);
    try al.append(2);
    try al.append(3);

    try t.expectEqual(3, al.items.len);

    var queue = Dequeue(i32).from_arraylist(al);
    defer queue.deinit();

    try t.expectEqual(3, queue.size());

    try queue.add_back(4);

    try t.expectEqual(4, queue.size());

    try t.expectEqual(1, queue.front());
}
