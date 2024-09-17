const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zlib_dep = b.dependency("zlib", .{
        .target = target,
        .optimize = optimize,
    });
    const lib = b.addStaticLibrary(.{
        .name = "spng",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.linkLibrary(zlib_dep.artifact("z"));

    lib.addCSourceFiles(.{
        .files = &.{
            "spng/spng.c",
        },
    });

    lib.installHeader(b.path("spng/spng.h"), "spng.h");
    b.installArtifact(lib);

    const module = b.addModule("spng", .{
        .root_source_file = b.path("lib.zig"),
    });
    module.addIncludePath(b.path("spng"));
}
