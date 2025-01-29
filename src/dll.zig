const std = @import("std");
const Allocator = std.mem.Allocator;

fn Node(comptime T: type) type {
    return struct {
        const Self = @This();
        value: T,
        prev: ?*Self = null,
        next: ?*Self = null,
    };
}

pub fn DoublyLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
        const NT = Node(T);

        allocator: Allocator,
        root: ?*NT = null,

        pub fn init(allocator: Allocator) Self {
            return .{
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            var node = self.root;
            while (node) |n| {
                const next = n.next;
                self.allocator.destroy(n);
                node = next;
            }
        }

        pub fn insert_beginning(self: *Self, value: T) !void {
            const newnode = try self.allocator.create(NT);
            newnode.* = NT{ .value = value, .next = self.root };
            self.root = newnode;
        }

        pub fn insert_end(self: *Self, value: T) !void {
            const newnode = try self.allocator.create(NT);
            newnode.* = NT{ .value = value };

            if (self.root == null) {
                self.root = newnode;
                return;
            }

            var node = self.root;
            while (node.?.next) |n| {
                node = n;
            }
            node.?.next = newnode;
        }

        pub fn remove(self: *Self, value: T) void {
            var node = &self.root;
            while (node.*) |n| {
                if (n.value == value) {
                    node.* = n.next;
                    self.allocator.destroy(n);
                    return;
                }
                node = &n.next;
            }
        }

        pub fn find(self: *const Self, value: T) ?*NT {
            var node = self.root;
            while (node) |n| {
                if (n.value == value) return n;
                node = n.next;
            }
            return null;
        }

        pub fn length(self: *const Self) usize {
            var node = self.root;
            var l: usize = 0;
            while (node) |n| {
                l += 1;
                node = n.next;
            }
            return l;
        }

        pub fn contains(self: *const Self, value: T) bool {
            var node = self.root;
            while (node) |n| {
                if (n.value == value) return true;
                node = n.next;
            }
            return false;
        }
    };
}

test "dll" {
    const t = std.testing;
    const allocator = t.allocator;

    var list = DoublyLinkedList(i32).init(allocator);
    defer list.deinit();

    try list.insert_beginning(10);
    try list.insert_end(20);
    try list.insert_end(30);

    try t.expectEqual(true, list.contains(20));
    try t.expectEqual(false, list.contains(40));

    list.remove(20);

    try t.expectEqual(false, list.contains(20));
    try t.expectEqual(2, list.length());
}
