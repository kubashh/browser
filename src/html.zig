const std = @import("std");

const HtmlParser = struct {
    html: []u8,
    i: usize,
};

const HtmlNode = struct {
    tag: []const u8,
    text: ?[]const u8 = null,
    children: []const *HtmlNode = &.{},
    attributes: []const Attribute = &.{},

    fn print(self: *const HtmlNode, depth: usize) void {
        for (0..depth) |_|
            std.debug.print(" ", .{});
        std.debug.print("{{\n", .{});

        for (0..depth + 2) |_|
            std.debug.print(" ", .{});
        std.debug.print("tag: {s}\n", .{self.tag});

        for (0..depth + 2) |_|
            std.debug.print(" ", .{});
        std.debug.print("text: {s}\n", .{self.text orelse "null"});

        for (0..depth + 2) |_|
            std.debug.print(" ", .{});
        std.debug.print("attrimutes: {any}\n", .{self.attributes});

        for (0..depth + 2) |_|
            std.debug.print(" ", .{});
        std.debug.print("children: {{\n", .{});
        for (self.children) |child| {
            child.print(depth + 2);
        }
        for (0..depth + 2) |_|
            std.debug.print(" ", .{});
        std.debug.print("}}\n", .{});

        for (0..depth) |_|
            std.debug.print(" ", .{});
        std.debug.print("}}\n", .{});
    }
};

const Attribute = struct {
    name: []const u8,
    value: []const u8,
};

pub fn parseHtml(html: []u8) HtmlNode {
    var parser: HtmlParser = .{ .html = html, .i = 0 };
    std.debug.print("input: {s}\n\n", .{parser.html});
    skipWhitespace(&parser);
    skipDoctypeHtml(&parser);
    skipWhitespace(&parser);

    if (next(&parser)) |node| {
        return node;
    } else {
        return .{ .tag = "", .text = null, .children = &.{}, .attributes = &.{} };
    }
}

fn next(parser: *HtmlParser) ?HtmlNode {
    if (parser.i >= parser.html.len)
        return null;

    skipWhitespace(parser);
    if (parser.i >= parser.html.len)
        return null;

    // element
    if (parser.html[parser.i] == '<') {
        var node: HtmlNode = .{ .tag = "", .text = null, .children = &.{}, .attributes = &.{} };

        parser.i += 1;

        node.tag = parseTagName(parser);

        // get attibutes
        if (parser.html[parser.i] == ' ') {
            parser.i += 1;
            std.debug.print("name_buf: {s}\n", .{node.tag});
        }

        skipWhitespace(parser);

        if (parser.html[parser.i] == '\\') { // <tag /> - selfclosing
            parser.i += 1;
            if (parser.html[parser.i] == '>')
                parser.i += 1;

            return node;
        } else parser.i += 1;

        node.text = parseText(parser);

        parseTagEnd(parser);

        return node;
    }

    std.debug.print("unchndled: {c}\n", .{parser.html[parser.i]});
    parser.i += 1;
    return next(parser);
}

fn skipDoctypeHtml(parser: *HtmlParser) void {
    if (parser.html[parser.i] == '<' and parser.html[parser.i + 1] == '!') {
        while (parser.html[parser.i] != '>') : (parser.i += 1) {}
        parser.i += 1;
    }
}

fn parseTagName(parser: *HtmlParser) []const u8 {
    const name_start: usize = parser.i;

    while (parser.i < parser.html.len and (parser.html[parser.i] != ' ' and parser.html[parser.i] != '/' and parser.html[parser.i] != '>')) : (parser.i += 1) {}

    return parser.html[name_start..parser.i];
}

fn skipWhitespace(parser: *HtmlParser) void {
    while (parser.html[parser.i] == ' ' or parser.html[parser.i] == '\n') : (parser.i += 1) {}
}

fn parseText(parser: *HtmlParser) []const u8 {
    const text_start: usize = parser.i;

    while (parser.html[parser.i] != '<') : (parser.i += 1) {}

    return parser.html[text_start..parser.i];
}

fn parseTagEnd(parser: *HtmlParser) void {
    while (parser.html[parser.i] != '>') : (parser.i += 1) {}
    parser.i += 1;
}

test "parse div" {
    var buf: [22]u8 = undefined;
    @memcpy(&buf, "<div>Hello html!</div>");

    const str: []u8 = &buf;

    const node = parseHtml(str);

    node.print(0);

    try std.testing.expect(std.mem.eql(u8, node.tag, "div"));
    try std.testing.expect(std.mem.eql(u8, node.text orelse "null", "Hello html!"));
}

test "parse simple html document" {
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

    const str: []u8 = &buf;

    const node = parseHtml(str);

    node.print(0);

    try std.testing.expect(std.mem.eql(u8, node.tag, "html"));
    try std.testing.expect(node.children.len == 1);
}
