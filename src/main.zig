const std = @import("std");
const html = @import("./html.zig");

pub fn main() void {
    std.debug.print("Hello Browser!\n", .{});

    var buf: [17]u8 = undefined;
    @memcpy(&buf, "<div>Hello!</div>");

    const str: []u8 = &buf;

    html.parseHtml(str);
}
