const std = @import("std");
const html = @import("./html.zig");

pub fn main() void {
    var buf: [17]u8 = undefined;
    @memcpy(&buf, "<div>Hello!</div>");

    const str: []u8 = &buf;

    const node = html.parseHtml(str);

    node.print(0);
}
