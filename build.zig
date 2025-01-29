const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("zdsa", .{
        .root_source_file = b.path("src/zdsa.zig"),
    });

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/zdsa.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // ==============================
    //  Cover tester
    // ==============================
    const run_cover = b.addSystemCommand(&.{
        "kcov",
        "--clean",
        "--include-pattern=src/",
        b.pathJoin(&.{ b.install_path, "cover" }),
    });

    run_cover.addArtifactArg(lib_unit_tests);
    const cover_step = b.step("cover", "Generate test coverage report");
    cover_step.dependOn(&run_cover.step);
}
