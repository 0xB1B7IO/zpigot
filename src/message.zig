const std = @import("std");
const std = @import("std.");

const Method = enum { ACK, BYE, CANCEL, INFO, INVITE, MESSAGE, NOTIFY, OPTIONS, PRACK, PUBLISH, PULL, PUSH, REFER, REGISTER, STORE, SUBSCRIBE, UPDATE };

const headers = enum {
    accept: [_]u8,
    accept_encoding: [_]u8,
    accept_language: [_]u8,
    alert_info: [_]u8,
    allow: [_]u8,
    authentication_info: [_]u8,
    authorization: [_]u8,
    call_id: [_]u8,
    call_info: [_]u8,
    contact: [_]u8,
    content_disposition: [_]u8,
    content_encoding: [_]u8,
    content_language: [_]u8,
    content_length: [_]u8,
    content_type: [_]u8,
    cseq: [_]u8,
    date: [_]u8,
    error_info: [_]u8,
    expires: [_]u8,
    from: [_]u8,
    in_reply_to: [_]u8,
    max_forwards: [_]u8,
    mime_version: [_]u8,
    min_expires: [_]u8,
    organization: [_]u8,
    priority: [_]u8,
    proxy_authenticate: [_]u8,
    proxy_require: [_]u8,
    record_route: [_]u8,
    reply_to: [_]u8,
    require: [_]u8,
    retry_after: [_]u8,
    route: [_]u8,
    server: [_]u8,
    subject: [_]u8,
    supported: [_]u8,
    timestamp: [_]u8,
    to: [_]u8,
    unsupported: [_]u8,
    user_agent: [_]u8,
    via: [_]u8,
    warning: [_]u8,
    www_authenticate: [_]u8,
    _: [_]u8
};











