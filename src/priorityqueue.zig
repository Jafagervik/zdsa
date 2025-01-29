const std = @import("std");
const Allocator = std.mem.Allocator;

fn Item(comptime T: type) type {
    return struct {
        value: T,
        priority: i32,
    };
}

/// Simple Priority Queue using initialized stack
pub fn PriorityQueue(comptime T: type) type {
    return struct {
        const Self = @This();
        const IT = Item(T);

        allocator: Allocator,
        data: std.ArrayList(T),

        var pr: [100_000]IT = undefined;
        var size: i32 = -1;

        pub fn init(allocator: Allocator) Self {
            return .{
                .allocator = allocator,
                .data = std.ArrayList(IT).init(allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }

        /// Adds to the top of the stack
        pub fn enqueue(self: *Self, value: T) void {
            self.size += 1;

            self.pr[size].value = value;
            self.pr[size].priority = value;
        }

        /// Pops the front element of the list
        /// If the stack is already empty, return null
        pub fn dequeue(self: *Self) !T {
            if (self.length() < 1) return error.StackEmpty;

            const ind = try self.peek();

            for (ind..size) |i| {
                self.pr[i] = self.pr[i + 1];
            }

            self.size -= 1;
        }

        /// Clears the entire stack
        pub fn clear(self: *Self) void {
            self.pr = undefined;
        }

        /// Get the length of the priority queue
        pub inline fn length(self: *Self) usize {
            return @as(usize, self.size);
        }

        /// Returns the front of the queue without removing it
        pub inline fn peek(self: *Self) !T {
            if (self.length() < 1) return error.QueueEmpty;

            var hiPrio: i32 = std.math.minInt(i32);
            var ind: i32 = -1;

            for (0..size) |i| {
                if (hiPrio == self.pr[i] and ind > -1 and self.pr[ind].value < self.pr[i].value) {
                    hiPrio = self.pr[i].priority;
                    ind = i;
                } else if (hiPrio < self.pr[i].priority) {
                    hiPrio = self.pr[i].priority;
                    ind = i;
                }
            }

            return ind;
        }
    };
}

// test "Priority Queue" {
//     const t = std.testing;
//     const allocator = t.allocator;
//
//     var queue = PriorityQueue(i32).init(allocator);
//     defer queue.deinit();
//
//     try queue.add(1);
//     try queue.add(2);
//     try queue.add(3);
//
//     try t.expectEqual(3, queue.length());
//
//     try t.expectEqual(1, queue.front());
//
//     const popped = queue.dequeue() catch unreachable;
//
//     try t.expectEqual(1, popped);
//     try t.expectEqual(2, queue.length());
//
//     queue.clear();
//     try t.expectEqual(0, queue.length());
// }
