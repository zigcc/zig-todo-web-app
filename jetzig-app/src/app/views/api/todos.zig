const std = @import("std");
const jetzig = @import("jetzig");

const Todo = struct {
    content: []const u8,
    id: ?[]const u8,
};

/// List all Todos
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    std.debug.print("index!\n", .{});
    var root = try data.root(.object);
    // TODO: currently there is no way to iterate over all keys in the store.
    try root.put("ids", null);
    return request.render(.ok);
}

/// Create new TODO
pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    std.debug.print("post, {s}!\n", .{request.body});
    var root = try data.root(.object);

    const allocator = request.allocator;
    const json_body = try std.json.parseFromSlice(Todo, allocator, request.body, .{
        .ignore_unknown_fields = true,
    });
    defer json_body.deinit();

    const todo = json_body.value;

    const now: i128 = @intCast(std.time.timestamp());
    var obj = try data.object();
    try obj.put("content", data.string(todo.content));
    try obj.put("created_at", data.integer(now));
    try obj.put("updated_at", data.integer(now));

    const id = todo.id orelse return error.MissingId;
    try request.store.put(id, obj);
    try root.put("id", id);
    return request.render(.ok);
}

/// GET a TODO
pub fn get(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    std.debug.print("get {s}!\n", .{id});
    var root = try data.root(.object);

    if (try request.store.get(id)) |todo| {
        try root.put("data", todo);
        try root.put("found", data.boolean(true));
    } else {
        try root.put("found", data.boolean(false));
    }
    return request.render(.ok);
}

/// Update a TODO
pub fn put(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    std.debug.print("update {s}!\n", .{id});
    var root = try data.root(.object);

    if (try request.store.get(id)) |todo| {
        const json_body = try std.json.parseFromSlice(Todo, request.allocator, request.body, .{
            .ignore_unknown_fields = true,
        });
        defer json_body.deinit();

        try todo.put("content", json_body.value.content);
        const now: i128 = @intCast(std.time.timestamp());
        try todo.put("updated_at", data.integer(now));
        try request.store.put(id, todo);
        try root.put("ok", data.boolean(true));
    } else {
        try root.put("ok", data.boolean(false));
    }
    return request.render(.ok);
}

/// Delete a TODO
pub fn delete(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    std.debug.print("delete {s}!\n", .{id});
    var root = try data.root(.object);
    try request.store.remove(id);
    try root.put("ok", data.boolean(true));
    return request.render(.ok);
}

test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/api/todos", .{});
    try response.expectStatus(.ok);
}
