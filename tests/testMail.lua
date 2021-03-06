local log_email = require"log4l.email"

local logger = log_email {
	rcpt = "mail@localhost",
	from = "mail@localhost",
	headers = {
		subject = "[%level] log4l.email test",
	},
}

assert(logger:info("log4l.email test"))
assert(logger:debug("debugging..."))
assert(logger:error("error!"))

local no_header_logger = log_email {
    rcpt = "mail@localhost",
    from = "mail@localhost",
}

assert(no_header_logger:info("log4l.email test"))
assert(no_header_logger:debug("debugging..."))
assert(no_header_logger:error("error!"))

local bad_logger = log_email {
    rcpt = "mail@5",
    from = "mail@5",
    headers = {
        subject = "[%level] log4l.email test",
    },
}

assert(not bad_logger:info("log4l.email test"))
assert(not bad_logger:debug("debugging..."))
assert(not bad_logger:error("error!"))

assert(not log_email{rcpt = "mail@localhost"})
assert(not log_email{from = "mail@localhost"})

print("Mail Logging OK")

