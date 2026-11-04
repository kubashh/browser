const std = @import("std");
const Browser = @import("./Browser.zig");

pub fn main(init: std.process.Init) error{OutOfMemory}!void {
    const browser: Browser.Browser = .init(init.io);

    browser.loadSite("./test/index.html");
    browser.loadSite("https://example.com");
}
