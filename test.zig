const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;

    var src = try std.Io.Dir.cwd().openDir(io, "src", .{ .iterate = true });
    defer src.close(io);

    var walker = try src.walk(allocator);
    defer walker.deinit();

    while (try walker.next(io)) |entry| {
        if (entry.kind != .file or !std.mem.endsWith(u8, entry.path, ".zig")) {
            continue;
        }
        const file = try std.mem.concat(allocator, u8, &.{ "src/", entry.path });
        defer allocator.free(file);

        std.debug.print("testing {s}...\n", .{file});

        const argv = [_][]const u8{ "zig", "test", file, "--cache-dir", ".cache/zig" };
        var child = try std.process.spawn(io, .{
            .argv = &argv,
            .stdin = .inherit,
            .stdout = .inherit,
            .stderr = .inherit,
        });

        _ = try child.wait(io);
    }
}
