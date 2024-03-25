const std = @import("std");
const mem = @import("mem");
const builtin = @import("builtin");

const Uri = @import("./message/Uri.zig");

const Message = struct {
    start_line: (RequestLine || StatusLine),
    headers: []Header,
    body: []const u8,
};

pub const Version = enum { @"SIP/2.0" };

const RequestLine = struct {
    method: Method,
    request_uri: []const u8,
    version: Version,
};

const StatusLine = struct {
    version: []const u8,
    status: Status,
};

const Method = enum {
    ACK,
    BYE,
    CANCEL,
    INFO,
    INVITE,
    MESSAGE,
    NOTIFY,
    OPTIONS,
    PRACK,
    PUBLISH,
    PULL,
    PUSH,
    REFER,
    REGISTER,
    STORE,
    SUBSCRIBE,
    UPDATE
};

const From = struct {
    display: ?[]const u8,
    from_uri: ?[]const u8,
    tag: ?[]const u8,
};

const To = struct {
    display: ?[]const u8,
    to_uri: ?[]const u8,
    tag: ?[]const u8,
};

const Via = struct {
    version: Version,
    transport: Transport,
    sent_by: []const u8,
    branch: ?branch,
    received: ?[]const u8,
    rport: ?u16,
};

const branch = struct {
    value: []const u8,
};

const Transport = enum {
    udp,
    tcp,
    tls,
    ws,
    wss,
    sctp,
    tls_sctp,

    pub fn toString(self: Transport) ![]const u8 {
        return switch (self) {
            .udp => "UDP", // RFC3261
            .tcp => "TCP", // RFC3261
            .tls => "TLS", // RFC3261
            .ws => "WS", // RFC7118
            .wss => "WSS", // RFC7118
            .sctp => "SCTP", // RFC4168
            .tls_sctp => "TLS-SCTP", // RFC4168
        };
    }
};

const Status = enum(u10) {
    trying = 100,
    ringing = 180,
    call_is_being_forwarded = 181,
    queued = 182,
    session_progress = 183,
    early_dialog_terminated = 199,

    ok = 200,
    accepted = 202,
    no_notification = 204,

    multiple_choices = 300,
    moved_permanently = 301,
    moved_temporarily = 302,
    use_proxy = 305,
    alternative_service = 380,

    bad_request = 400,
    unauthorized = 401,
    payment_required = 402,
    forbidden = 403,
    not_found = 404,
    method_not_allowed = 405,
    not_acceptable = 406,
    proxy_authentication_required = 407,
    request_timeout = 408,
    gone = 410,
    request_entity_too_large = 413,
    request_uri_too_long = 414,
    unsupported_media_type = 415,
    requested_range_not_satisfiable = 416,
    expectation_failed = 417,
    im_a_teapot = 418,
    bad_extension = 420,
    extension_required = 421,
    session_interval_too_small = 422,
    interval_too_brief = 423,
    use_identity_header = 428,
    provide_referrer_identity = 429,
    flow_failed = 430,
    anonymity_disallowed = 433,
    bad_identity_info = 436,
    unsupported_certificate = 437,
    invalid_identity_header = 438,
    first_hop_lacks_outbound_support = 439,
    max_breadth_exceeded = 440,
    bad_info_package = 469,
    consent_needed = 470,
    temporary_unavailable = 480,
    call_leg_transaction_does_not_exist = 481,
    loop_detected = 482,
    too_many_hops = 483,
    address_incomplete = 484,
    ambiguous = 485,
    busy_here = 486,
    request_terminated = 487,
    not_acceptable_here = 488,
    bad_event = 489,
    request_pending = 491,
    undecipherable = 493,
    security_agreement_required = 494,

    server_internal_error = 500,
    not_implemented = 501,
    bad_gateway = 502,
    service_unavailable = 503,
    server_timeout = 504,
    version_not_supported = 505,
    message_too_large = 513,
    pre_condition_failure = 580,

    busy_everywhere = 600,
    decline = 603,
    does_not_exist_anywhere = 604,
    not_acceptable_anywhere = 606,

    _,

    pub fn phrase(self: Status) ?[]const u8 {
        return switch (self) {
            .trying => "Trying",
            .ringing => "Ringing",
            .call_is_being_forwarded => "Call Is Being Forwarded",
            .queued => "Queued",
            .session_progress => "Session Progress",
            .early_dialog_terminated => "Early Dialog Terminated",
            .ok => "OK",
            .accepted => "Accepted",
            .no_notification => "No Notification",
            .multiple_choices => "Multiple Choices",
            .moved_permanently => "Moved Permanently",
            .moved_temporarily => "Moved Temporarily",
            .use_proxy => "Use Proxy",
            .alternative_service => "Alternative Service",
            .bad_request => "Bad Request",
            .unauthorized => "Unauthorized",
            .payment_required => "Payment Required",
            .forbidden => "Forbidden",
            .not_found => "Not Found",
            .method_not_allowed => "Method Not Allowed",
            .not_acceptable => "Not Acceptable",
            .proxy_authentication_required => "Proxy Authentication Required",
            .request_timeout => "Request Timeout",
            .gone => "Gone",
            .request_entity_too_large => "Request Entity Too Large",
            .request_uri_too_long => "Request-URI Too Long",
            .unsupported_media_type => "Unsupported Media Type",
            .requested_range_not_satisfiable => "Requested Range Not Satisfiable",
            .expectation_failed => "Expectation Failed",
            .im_a_teapot => "I'm a teapot",
            .bad_extension => "Bad Extension",
            .extension_required => "Extension Required",
            .session_interval_too_small => "Session Interval Too Small",
            .interval_too_brief => "Interval Too Brief",
            .use_identity_header => "Use Identity Header",
            .provide_referrer_identity => "Provide Referrer Identity",
            .flow_failed => "Flow Failed",
            .anonymity_disallowed => "Anonymity Disallowed",
            .bad_identity_info => "Bad Identity Info",
            .unsupported_certificate => "Unsupported Certificate",
            .invalid_identity_header => "Invalid Identity Header",
            .first_hop_lacks_outbound_support => "First Hop Lacks Outbound Support",
            .max_breadth_exceeded => "Max-Breadth Exceeded",
            .bad_info_package => "Bad Info Package",
            .consent_needed => "Consent Needed",
            .temporary_unavailable => "Temporary Unavailable",
            .call_leg_transaction_does_not_exist => "Call Leg/Transaction Does Not Exist",
            .loop_detected => "Loop Detected",
            .too_many_hops => "Too Many Hops",
            .address_incomplete => "Address Incomplete",
            .ambiguous => "Ambiguous",
            .busy_here => "Busy Here",
            .request_terminated => "Request Terminated",
            .not_acceptable_here => "Not Acceptable Here",
            .bad_event => "Bad Event",
            .request_pending => "Request Pending",
            .undecipherable => "Undecipherable",
            .security_agreement_required => "Security Agreement Required",
            .server_internal_error => "Server Internal Error",
            .not_implemented => "Not Implemented",
            .bad_gateway => "Bad Gateway",
            .service_unavailable => "Service Unavailable",
            .server_timeout => "Server Timeout",
            .version_not_supported => "Version Not Supported",
            .message_too_large => "Message Too Large",
            .pre_condition_failure => "Pre-Condition Failure",
            .busy_everywhere => "Busy Everywhere",
            .decline => "Decline",
            .does_not_exist_anywhere => "Does Not Exist Anywhere",
            .not_acceptable_anywhere => "Not Acceptable Anywhere",

            else => return null,
        };
    }
};

// https://www.iana.org/assignments/sip-parameters/sip-parameters.xhtml
const Header = enum {
    Accept,
    Accept_Encoding,
    Accept_Language,
    Alert_Info,
    Allow,
    Authentication_Info,
    Authorization,
    Call_ID,
    Call_Info,
    Contact,
    Content_Disposition,
    Content_Encoding,
    Content_Language,
    Content_Length,
    Content_Type,
    CSeq,
    Date,
    Error_Info,
    Expires,
    From,
    In_Reply_To,
    Max_Forwards,
    MIME_Version,
    Min_Expires,
    Organization,
    Priority,
    Proxy_Authenticate,
    Proxy_Require,
    Record_Route,
    Reply_To,
    Require,
    Retry_After,
    Route,
    Server,
    Session_ID,
    Subject,
    Supported,
    Timestamp,
    To,
    Unsupported,
    User_Agent,
    Via,
    Warning,
    WWW_Authenticate,

    pub fn toString(self: Header) ![]const u8 {
        return switch (self) {
            .Accept => "Accept",
            .Accept_Encoding => "Accept-Encoding",
            .Accept_Language => "Accept-Language",
            .Alert_Info => "Alert-Info",
            .Allow => "Allow",
            .Authentication_Info => "Authentication-Info",
            .Authorization => "Authorization",
            .Call_ID => "Call-ID",
            .Call_Info => "Call-Info",
            .Contact => "Contact",
            .Content_Disposition => "Content-Disposition",
            .Content_Encoding => "Content-Encoding",
            .Content_Language => "Content-Language",
            .Content_Length => "Content-Length",
            .Content_Type => "Content-Type",
            .CSeq => "CSeq",
            .Date => "Date",
            .Error_Info => "Error-Info",
            .Expires => "Expires",
            .From => "From",
            .In_Reply_To => "In-Reply-To",
            .Max_Forwards => "Max-Forwards",
            .MIME_Version => "MIME-Version",
            .Min_Expires => "Min-Expires",
            .Organization => "Organization",
            .Priority => "Priority",
            .Proxy_Authenticate => "Proxy-Authenticate",
            .Proxy_Require => "Proxy-Require",
            .Record_Route => "Record-Route",
            .Reply_To => "Reply-To",
            .Require => "Require",
            .Retry_After => "Retry-After",
            .Route => "Route",
            .Server => "Server",
            .Session_ID => "Session-ID",
            .Subject => "Subject",
            .Supported => "Supported",
            .Timestamp => "Timestamp",
            .To => "To",
            .Unsupported => "Unsupported",
            .User_Agent => "User-Agent",
            .Via => "Via",
            .Warning => "Warning",
            .WWW_Authenticate => "WWW-Authenticate"
        };
    }
};