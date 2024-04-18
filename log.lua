G_PRINT_MODE = {
	TRACE = 0, 
	DEBUG = 1, 
	INFO = 2, 
	ERROR = 3,
}

function get_filename()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("^.*/(.*).lua$") or str
end

function get_linenumber()
	return debug.getinfo(1).currentline
end

-- TODO:
-- log time
-- log line number
-- log file name
-- print to stderror
-- or choose file output
function log(x, mode)
	local file_name = get_filename()
	local line_number = get_linenumber()
	local time = os.date('%Y-%m-%d:%H-%M-%S')

	-- set default print mode
	if G_CURRENT_PRINT_MODE == nil then
		G_CURRENT_PRINT_MODE = G_PRINT_MODE.ERROR
	end

	if mode >= G_CURRENT_PRINT_MODE then
		print(time .. ":" .. file_name .. ".lua" .. ":" .. line_number .. " " .. x)
	end
end

function log_trace(x) 
	log(x, G_PRINT_MODE.TRACE)	
end

function log_debug(x)
	log(x, G_PRINT_MODE.DEBUG)
end

function log_info(x)
	log(x, G_PRINT_MODE.INFO)
end

function log_error(x)
	log(x, G_PRINT_MODE.ERROR)
end
