--[[
-- @brief 网口检查
--]]
local l_sys = require("l_sys")

local l_ipc = require("l_ipc")
local check_arping = require("ipc.env.check_arping")
local phynet = require("ipc.phynet.phynet")

local lt_name = ''


local on_timer_recv = function (id, count, interval, tc, last_tc)
	
	phynet.check_proc(100)
	
	return 0
end


init = function (param)
	--print('init .....', param)
	lt_name = param
	
	l_sys.add_timer(100, 100, on_timer_recv)		-- 定时取消息	
	

	phynet.setup()	
	
	return 0
end


quit = function ()
	--print('quit .....')
	l_sys.remove_timer(100)
	
	return 0
end



on_cmd = function (msg, lparam, wparam, cobj)
	--print('on_cmd.name:'..lt_name, msg, lparam, wparam)
	local cmd_low = string.lower(msg) -- 不区分key字段大小写	

	if 'arping' == cmd_low then
		check_arping() 	-- arping一次网络
	end
	
	return 0
end
