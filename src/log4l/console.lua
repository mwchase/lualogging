-------------------------------------------------------------------------------
-- Prints logging information to console
--
-- @author Thiago Costa Ponte (thiago@ideais.com.br)
--
-- @copyright 2004-2013 Kepler Project
--
-------------------------------------------------------------------------------

local logging = require"log4l"

function logging.console(logPattern, datePattern)
	return logging.new( function(self, level, message)
		io.stdout:write(logging.prepareLogMsg(logPattern, os.date(datePattern), level, message))
		return true
	end)
end

return logging.console

