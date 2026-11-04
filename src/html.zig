const std = @import("std");

const HtmlParser = struct {
    html: []u8,
    i: usize,
};

pub const HtmlNode = struct {
    tag: []const u8,
    text: ?[]const u8,
    children: []const HtmlNode,
    attributes: []const Attribute,

    // this fn is only for debbuging purposes
    pub fn print(self: *const HtmlNode, depth: usize) void {
        std.debug.print("{{\n", .{});

        for (0..depth + 2) |_|
            std.debug.print(" ", .{});
        std.debug.print(
            "tag: \"{s}\", text: \"{s}\", attributes: [",
            .{
                self.tag,
                self.text orelse "null",
            },
        );
        for (self.attributes) |attribute| {
            std.debug.print("{{ name: \"{s}\", value: \"{s}\" }}, ", .{ attribute.name, attribute.value });
        }
        std.debug.print("], children: [ ", .{});
        if (self.children.len > 0) {
            for (self.children) |child| {
                child.print(depth + 2);
                std.debug.print(", ", .{});
            }

            std.debug.print("], ", .{});
        } else std.debug.print("] ", .{});

        std.debug.print("}}", .{});
        if (depth == 0)
            std.debug.print("\n", .{});
    }
};

const Attribute = struct {
    name: []const u8,
    value: []const u8,
};

const self_cloasing_tags: []const []const u8 = &.{ "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr" };

pub fn parseHtmlAlloc(allocator: std.mem.Allocator, html: []u8) error{OutOfMemory}!HtmlNode {
    var parser: HtmlParser = .{ .html = html, .i = 0 };
    skipWhitespace(&parser);
    skipDoctypeHtml(&parser);
    skipWhitespace(&parser);

    if (try next(allocator, &parser)) |node| {
        return node;
    } else {
        return .{ .tag = "", .text = null, .children = &.{}, .attributes = &.{} };
    }
}

fn next(allocator: std.mem.Allocator, parser: *HtmlParser) error{OutOfMemory}!?HtmlNode {
    if (parser.i >= parser.html.len)
        return null;

    skipWhitespace(parser);
    if (parser.i >= parser.html.len)
        return null;

    // element
    if (parser.html[parser.i] == '<' and parser.html[parser.i + 1] != '/') {
        var node: HtmlNode = .{ .tag = "", .text = null, .children = &.{}, .attributes = &.{} };

        parser.i += 1;

        node.tag = parseTagName(parser);

        // get attibutes
        if (parser.html[parser.i] == ' ') {
            var attributes_list = try std.ArrayList(Attribute).initCapacity(allocator, 8);
            parser.i += 1;
            while (parseAttribute(parser)) |attribute| {
                try attributes_list.append(allocator, attribute);
            }
            node.attributes = attributes_list.items;
        }

        skipWhitespace(parser);

        if (parser.html[parser.i] == '/') { // <tag />
            parser.i += 1;
            if (parser.html[parser.i] == '>')
                parser.i += 1;

            return node;
        } else parser.i += 1;

        // check self closing
        for (self_cloasing_tags) |sc_tag| {
            if (std.mem.eql(u8, node.tag, sc_tag))
                return node;
        }

        skipWhitespace(parser);

        node.text = parseText(parser);

        var children_list = try std.ArrayList(HtmlNode).initCapacity(allocator, 8);

        while (try next(allocator, parser)) |nnode| {
            try children_list.append(allocator, nnode);
        }

        node.children = children_list.items;

        parseTagEnd(parser);

        return node;
    }

    if (parser.html[parser.i] == '<' and parser.html[parser.i + 1] == '/') {
        return null;
    }

    std.log.err("unchndled: {c}\n", .{parser.html[parser.i]});
    parser.i += 1;
    return null;
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

fn parseAttribute(parser: *HtmlParser) ?Attribute {
    skipWhitespace(parser);
    if (parser.html[parser.i] == '>' or parser.html[parser.i] == '/') return null;

    const name_start = parser.i;

    while (parser.html[parser.i] != '=' and parser.html[parser.i] != '>' and parser.html[parser.i] != '/') : (parser.i += 1) {}

    const name_end = parser.i;
    parser.i += 2;

    const value_start = parser.i;
    while (parser.html[parser.i] != '"' and parser.html[parser.i] != '>' and parser.html[parser.i] != '/') : (parser.i += 1) {}
    const value_end = parser.i;

    if (parser.i != '/' and parser.i != '>')
        parser.i += 1;

    if (name_start != name_end)
        return .{
            .name = parser.html[name_start..name_end],
            .value = parser.html[value_start..value_end],
        };
    return null;
}

fn parseText(parser: *HtmlParser) ?[]const u8 {
    const text_start: usize = parser.i;

    while (parser.html[parser.i] != '<') : (parser.i += 1) {}

    if (text_start != parser.i) {
        return parser.html[text_start..parser.i];
    } else return null;
}

fn parseTagEnd(parser: *HtmlParser) void {
    while (parser.html[parser.i] != '>') : (parser.i += 1) {}
    parser.i += 1;
}

pub fn parseHtmlFree(allocator: std.mem.Allocator, node: HtmlNode) void {
    _ = allocator;
    for (node.children) |child| {
        std.debug.print("{any}\n", .{child});
    }
}

//
// tests
//

test "parse div" {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();

    var buf: [22]u8 = undefined;
    @memcpy(&buf, "<div>Hello html!</div>");

    const str: []u8 = &buf;

    const node = try parseHtmlAlloc(allocator, str);

    try std.testing.expect(std.mem.eql(u8, node.tag, "div"));
    try std.testing.expect(std.mem.eql(u8, node.text orelse "null", "Hello html!"));
}

test "parse simple html document" {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();

    const str = try getTestStr(allocator,
        \\<!doctype html>
        \\<html lang="en">
        \\  <head>
        \\    <meta charset="UTF-8" />
        \\    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        \\    <title>Document</title>
        \\  </head>
        \\  <body class="body" styles="background-color: black; color: white;">
        \\    <div>My content!</div>
        \\  </body>
        \\</html>
        \\
    );

    const node = try parseHtmlAlloc(allocator, str);

    try std.testing.expect(std.mem.eql(u8, node.tag, "html"));
    try std.testing.expect(node.children.len == 2);

    const head = node.children[0];
    try std.testing.expect(std.mem.eql(u8, head.tag, "head"));
    try std.testing.expect(std.mem.eql(u8, head.children[0].attributes[0].value, "UTF-8"));

    const body = node.children[1];
    try std.testing.expect(std.mem.eql(u8, body.tag, "body"));
}

test "self-closing edge case" {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();

    const str = try getTestStr(allocator,
        \\<!doctype html>
        \\<html lang="en">
        \\  <head>
        \\    <meta charset="UTF-8">
        \\    <meta name="viewport" content="width=device-width, initial-scale=1.0">
        \\    <title>Document</title>
        \\  </head>
        \\  <body class="body" styles="background-color: black; color: white;">
        \\    <div>My content!</div>
        \\    <br>
        \\    <div>Sth</div>
        \\    <p>Some text</p>
        \\  </body>
        \\</html>
        \\
    );

    const node = try parseHtmlAlloc(allocator, str);

    node.print(0);

    try std.testing.expect(std.mem.eql(u8, node.tag, "html"));
    try std.testing.expect(node.children.len == 2);

    const head = node.children[0];
    try std.testing.expect(std.mem.eql(u8, head.tag, "head"));
    try std.testing.expect(std.mem.eql(u8, head.children[1].attributes[1].name, "content"));
    try std.testing.expect(std.mem.eql(u8, head.children[1].attributes[1].value, "width=device-width, initial-scale=1.0"));

    const body = node.children[1];
    try std.testing.expect(std.mem.eql(u8, body.children[0].tag, "div"));
    try std.testing.expect(std.mem.eql(u8, body.children[1].tag, "br"));
}

//
// test helpers
//

fn getTestStr(allocator: std.mem.Allocator, comptime str: []const u8) error{OutOfMemory}![]u8 {
    const buf = try allocator.alloc(u8, str.len);
    @memcpy(buf, str);

    return buf;
}
