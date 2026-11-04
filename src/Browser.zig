const std = @import("std");
const html = @import("./html.zig");

pub const Browser = struct {
    io: std.Io,
    const allocator = std.heap.page_allocator;

    pub fn init(io: std.Io) Browser {
        return .{ .io = io };
    }

    pub fn loadSite(self: *const Browser, url: []const u8) void {
        _ = self;
        _ = url;
        // TODO check is file path or url
    }

    pub fn parseHtmlAlloc(self: *const Browser, html_text: []u8) error{OutOfMemory}!html.HtmlNode {
        _ = self;
        return try html.parseHtmlAlloc(allocator, html_text);
    }

    pub fn parseHtmlFree(self: *const Browser, node: html.HtmlNode) void {
        _ = self;
        html.parseHtmlFree(allocator, node);
    }
};
