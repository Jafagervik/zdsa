const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn Queue(comptime T: type) type {
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

        /// Adds to the top of the queue
        pub fn enqueue(self: *Self, value: T) !void {
            try self.data.append(value);
        }

        /// Pops the front element of the queue
        /// If the queue is already empty, return null
        pub fn dequeue(self: *Self) !T {
            if (self.length() < 1) return error.StackEmpty;
            return self.data.orderedRemove(0);
        }

        /// Clears the entire queue
        pub fn clear(self: *Self) void {
            self.data.clearAndFree();
        }

        /// Get the size length of the queue
        pub inline fn length(self: *Self) usize {
            return self.data.items.len;
        }

        /// Returns the front of the queue without removing it
        pub inline fn front(self: *Self) !T {
            if (self.length() < 1) return error.QueueEmpty;
            return self.data.items[0];
        }
    };
}

test "Queue" {
    const t = std.testing;
    const allocator = t.allocator;

    var queue = Queue(i32).init(allocator);
    defer queue.deinit();

    try queue.enqueue(1);
    try queue.enqueue(2);
    try queue.enqueue(3);

    try t.expectEqual(3, queue.length());

    try t.expectEqual(1, queue.front());

    const popped = queue.dequeue() catch unreachable;

    try t.expectEqual(1, popped);
    try t.expectEqual(2, queue.length());

    queue.clear();
    try t.expectEqual(0, queue.length());
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

    var queue = Queue(i32).from_arraylist(al);
    defer queue.deinit();

    try t.expectEqual(3, queue.length());

    try queue.enqueue(4);

    try t.expectEqual(4, queue.length());

    try t.expectEqual(1, queue.front());
}
