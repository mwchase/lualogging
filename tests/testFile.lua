local GLOBAL_OS_DATE = os.date
local GLOBAL_IO_OPEN = io.open

local mock = {
	date = nil,
	handle = {}
}

io.open = function (file, mode)
	if (not string.find(file, "^__TEST*")) then
		return GLOBAL_IO_OPEN(file, mode)
	end

	mock.handle[file] = {}
	mock.handle[file].lines = {}
	mock.handle[file].mode = mode
	return {
		setvbuf = function (_, s)
			mock.handle[file].setvbuf = s
		end,
		write = function (_, s)
			table.insert(mock.handle[file].lines, s)
		end,
	}
end

os.date = function (...)
	return mock.date
end

local log_file = require "log4l.file"

mock.date = "2008-01-01"
local logger = log_file("__TEST%s.log", "%Y-%m-%d")

assert(mock.handle["__TEST"..mock.date..".log"] == nil)

assert(logger:info("log4l.file test"))

assert(mock.handle["__TEST"..mock.date..".log"].mode == "a")
assert(#mock.handle["__TEST"..mock.date..".log"].lines == 1)
assert(mock.handle["__TEST"..mock.date..".log"].setvbuf == "line")
assert(mock.handle["__TEST"..mock.date..".log"].lines[1] == "2008-01-01 INFO log4l.file test\n")

mock.date = "2008-01-02"

assert(logger:debug("debugging..."))
assert(logger:error("error!"))

assert(mock.handle["__TEST"..mock.date..".log"].mode == "a")
assert(#mock.handle["__TEST"..mock.date..".log"].lines == 2)
assert(mock.handle["__TEST"..mock.date..".log"].setvbuf == "line")
assert(mock.handle["__TEST"..mock.date..".log"].lines[1] == "2008-01-02 DEBUG debugging...\n")
assert(mock.handle["__TEST"..mock.date..".log"].lines[2] == "2008-01-02 ERROR error!\n")

mock.date = "2008-01-03"

assert(logger:info({id = "1"}))

assert(mock.handle["__TEST"..mock.date..".log"].mode == "a")
assert(#mock.handle["__TEST"..mock.date..".log"].lines == 1)
assert(mock.handle["__TEST"..mock.date..".log"].setvbuf == "line")
assert(mock.handle["__TEST"..mock.date..".log"].lines[1] == '2008-01-03 INFO {id = "1"}\n')

os.date = GLOBAL_OS_DATE
io.open = GLOBAL_IO_OPEN

print("File Logging OK")

