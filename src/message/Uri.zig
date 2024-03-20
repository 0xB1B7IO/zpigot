

const SipUri = @This();
const std = @import("std");
const ALlocator = std.mem.Allocator;

const scheme = enum {
    sip,
    sips,
};

scheme: scheme,
userinfo: ?[]const u8 = null,
authority: []const u8,
parameters: []const u8,
headers: ?[]const u8 = null,
host: []const u8,
port: ?u16 = null,

