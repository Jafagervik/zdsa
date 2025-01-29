const std = @import("std");
const Allocator = std.mem.Allocator;

fn Node(comptime T: type) type {
    return struct {
        const Self = @This();

        value: T,
        parent: ?*Self = null,
        left: ?*Self = null,
        right: ?*Self = null,
    };
}

/// Generic Binary tree representation
pub fn BinaryTree(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: Allocator,
        root: ?*Node = null,

        pub fn init(allocator: Allocator) Self {
            return .{
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }

        /// Initialize from already existing arraylist
        pub fn from_arraylist(d: std.ArrayList(T)) Self {
            return .{
                .allocator = d.allocator,
            };
        }

        /// Add node
        pub fn add(self: *Self, value: T) !void {
            if (self.root == null) {
                self.root = Node{ .value = value };
                return;
            }
            return;
        }
    };
}
