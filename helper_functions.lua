
--- Logs a message with optional traceback.
--
--  @local log_message
--  @tparam string level
--    Log verbosity level.
--  @tparam string message.
--    Text to be logged.
--  @tparam[opt] traceback
--    Toggles printing traceback (default: `false`).
local function log_message(level, message, traceback)
	if traceback then
		core.log(level, message .. "\n" .. debug.traceback())
	else
		core.log(level, mesage)
	end
end

--- Logs an error message with optional traceback.
--
--  @local log_error
--  @tparam string message
--    Message to be logged.
--  @tparam[opt] boolean traceback
--    Toggles printing traceback (default: `true`).
local function log_error(message, traceback)
	log_message("error", message, traceback or traceback == nil)
end

--- Logs a warning message with optional traceback.
--
--  @local log_error
--  @tparam string message
--    Message to be logged.
--  @tparam[opt] boolean traceback
--    Toggles printing traceback (default: `false`).
local function log_warn(message, traceback)
	log_message("warning", message, traceback)
end

return log_error, log_warn
