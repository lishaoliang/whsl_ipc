
local l_sys = require("l_sys")

local version = {
	hw_ver = 'h1.0.6',
	sw_ver = l_sys.sw_ver,
	build_time = l_sys.build_time
}

return version
