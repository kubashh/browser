const std = @import("std");
const Browser = @import("./Browser.zig");

pub fn main(init: std.process.Init) error{OutOfMemory}!void {
    var buf: [210]u8 = undefined;
    @memcpy(&buf,
        \\<!doctype html>
        \\<html lang="en">
        \\  <head>
        \\    <meta charset="UTF-8" />
        \\    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        \\    <title>Document</title>
        \\  </head>
        \\  <body></body>
        \\</html>
        \\
    );

    const browser: Browser.Browser = .init(init.io);

    const str: []u8 = &buf;

    const node = try browser.parseHtmlAlloc(str);

    node.print(0);

    browser.parseHtmlFree(node);
}
