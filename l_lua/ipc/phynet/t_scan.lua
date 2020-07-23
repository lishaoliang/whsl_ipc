--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/04
--
-- @file    t_scan.lua
-- @brief   扫描wifi
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/04 0.1 创建文件
-- @warning 没有警告
--]]

local string = require("string")
local l_sys = require("l_sys")

local util = require("base.util")
local util_ex = require("base.util_ex")

local wlan = require("ipc.phynet.wlan")
local wpa_cli = require("ipc.phynet.wpa_cli")



local wpa, ping = wpa_cli.ping()

if not wpa then
	wlan.env_sta()			-- 没有启用wpa_supplicant, 则先设置sta环境
else
	wpa_cli.disconnect()	-- 已经启用wpa_supplicant, 则断开连接, 搜索全部wifi
end

-- 再次ping 
wpa, ping = wpa_cli.ping()

-- 如果成功, 则可以开始搜索
if ping then	
	wpa_cli.scan()	
	
	local count = 5
	while 0 < count do
		count = count - 1	
		--wpa_cli.scan()

		l_sys.sleep(1000)	
		util_ex.printf('scan_results:', wpa_cli.scan_results())
	end
	
	wpa_cli.reconnect()
end

print('t_scan over...')
