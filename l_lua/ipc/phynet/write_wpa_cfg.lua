--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/04
--
-- @file    write_wpa_cfg.lua
-- @brief   写wpa的配置文件
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/04 0.1 创建文件
-- @warning 没有警告
--]]
local io = require("io")

local write_wpa_cfg = function (ssid, passwd)
	local content = "ctrl_interface=/var/run/wpa_supplicant\n".."update_config=1\n".."network={\nssid=\""..ssid.."\"\npsk=\""..passwd.."\"\n}"
	local f = assert(io.open("/opt/configfile/wpa_0_8.conf", 'w'))
    f:write(content)
	f:close()
end

return write_wpa_cfg
