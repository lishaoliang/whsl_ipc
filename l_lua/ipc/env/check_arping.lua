--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/16
--
-- @file    check_arping.lua
-- @brief   对网卡做 arping 
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/16 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local io = require("io")
local unix = require("base.unix")

local l_sys = require("l_sys")
local sh = l_sys.sh


local arping = function (name, ip)
	-- arping 格式: arping -I eth0 -c 3 192.168.1.247
	local cmd = string.format('arping -I %s -c 3 %s', name, ip)
	local ret, str = sh(cmd)
	
	print('arping cmd:'..cmd, ret, str)
end


local check_arping = function ()
	local ifs = unix.get_ifconfig()	
	for k, v in pairs(ifs) do
		local name = v['name']
		local ipv4 = v['ipv4']
		
		arping(name, ipv4)
	end
end

return check_arping
