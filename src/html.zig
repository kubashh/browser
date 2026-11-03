const std = @import("std");

const HtmlParser = struct {
    html: []u8,
    i: usize,
};

const HtmlNode = struct {
    tag: []const u8,
    text: ?[]const u8 = null,
    children: ?[]const *HtmlNode = &.{},
    attributes: []const Attribute = &.{},
};

const Attribute = struct {
    name: []const u8,
    value: []const u8,
};

pub fn parseHtml(html: []u8) void {
    var htmlParser: HtmlParser = .{ .html = html, .i = 0 };
    std.debug.print("{s}\n\n", .{htmlParser.html});
    const node = next(&htmlParser);

    std.debug.print("{any}\n", .{node});
}

fn next(parser: *HtmlParser) ?HtmlNode {
    if (parser.i >= parser.html.len)
        return null;

    // skip whitespace
    if (parser.html[parser.i] == ' ' or parser.html[parser.i] == '\n') {
        parser.i += 1;
        return next(parser);
    }

    // element
    if (parser.html[parser.i] == '<') {
        var node: HtmlNode = .{ .tag = "", .text = "", .children = null, .attributes = &.{} };

        parser.i += 1;

        var name_buf: [64]u8 = undefined;
        var name_buf_i: usize = 0;

        // get tag name
        while (parser.i < parser.html.len and (parser.html[parser.i] != ' ' and parser.html[parser.i] != '/' and parser.html[parser.i] != '>')) : (parser.i += 1) {
            name_buf[name_buf_i] = parser.html[parser.i];
            name_buf_i += 1;
        }

        node.tag = name_buf[0..name_buf_i];

        // get attibutes
        if (parser.html[parser.i] == ' ') {
            parser.i += 1;
            std.debug.print("name_buf: {s}\n", .{name_buf[0..name_buf_i]});
        } else if (parser.html[parser.i] == '\\') {} else parser.i += 1;

        std.debug.print("name_buf: {s}\n", .{name_buf[0..name_buf_i]});

        if (parser.i >= parser.html.len)
            return null;

        while (parser.i < parser.html.len) : (parser.i += 1) {
            std.debug.print("in: {c}\n", .{parser.html[parser.i]});
        }

        parser.i += 1;
        return node;
    }

    std.debug.print("unchndled: {c}\n", .{parser.html[parser.i]});
    parser.i += 1;
    return next(parser);
}

test "parse html div" {}
