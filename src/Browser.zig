const std = @import("std");
const html = @import("./html.zig");

const LoadFetchError = std.http.Client.FetchError;
const LoadFileError = std.Io.Dir.ReadFileAllocError;

pub const Browser = struct {
    io: std.Io,
    const allocator = std.heap.page_allocator;

    pub fn init(io: std.Io) Browser {
        return .{ .io = io };
    }

    pub fn loadSite(self: *const Browser, url: []const u8) void {
        const html_str = self.loadResourceAlloc(url);
        defer if (html_str) |valid_html| allocator.free(valid_html);

        if (html_str) |valid_html| {
            std.debug.print("{s}\n", .{valid_html});

            if (std.mem.endsWith(u8, url, ".html")) {
                const node = self.parseHtmlAlloc(valid_html) catch |err| {
                    std.debug.print("OutOfMemory parsing file {s}: {}\n", .{ url, err });
                    return;
                };
                defer self.parseHtmlFree(node);

                node.print(0);
            }
        }
    }

    fn loadResourceAlloc(self: *const Browser, url: []const u8) ?[]u8 {
        if (std.mem.startsWith(u8, url, "http")) {
            return self.loadFetchAlloc(url) catch |err| {
                std.debug.print("err: {}\n", .{err});
                return null;
            };
        } else {
            return self.loadFileAlloc(url) catch |err| {
                std.debug.print("Could not read {s}: {}\n", .{ url, err });
                return null;
            };
        }

        return null;
    }

    fn loadFetchAlloc(self: *const Browser, url: []const u8) LoadFetchError!?[]u8 {
        var client: std.http.Client = .{
            .allocator = allocator,
            .io = self.io,
        };
        defer client.deinit();

        var body: std.Io.Writer.Allocating = .init(allocator);
        defer body.deinit();

        var redirect_buffer: [8 * 1024]u8 = undefined;
        const response = try client.fetch(.{
            .location = .{ .url = url },
            .method = .GET,
            .redirect_buffer = &redirect_buffer,
            .response_writer = &body.writer,
        });

        if (response.status != .ok) {
            return null;
        }

        return try body.toOwnedSlice();
    }

    fn loadFileAlloc(self: *const Browser, path: []const u8) LoadFileError!?[]u8 {
        const text = try std.Io.Dir.readFileAlloc(
            std.Io.Dir.cwd(),
            self.io,
            path,
            allocator,
            .unlimited,
        );

        return text;
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
