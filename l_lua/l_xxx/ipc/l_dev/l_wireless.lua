--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_wireless.lua
-- @brief   扩展内置库"l_wireless", 函数说明
-- @version 0.1
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_wireless = {}


-- @brief 获取wifi运行模式
-- @return [string] "ap", "sta", "other"
l_wireless.mode_probe = function ()
	return 'ap'
	-- return false
end


-- @brief 切换到"ap"模式(作为wifi热点)
l_wireless.mode_switch2ap = function ()

end


-- @brief 在ap模式,获取连接的终端数目
-- @return [number] 连接上的终端数目
l_wireless.ap_connected_count = function()
	return 0
end


-- @brief 初次启动按 'sta'模式
l_wireless.boot_mode_sta = function ()

end


-- @brief 切换到"sta"模式(作为终端)
l_wireless.mode_switch2sta =  function ()

end


-- @brief 在ap模式,获取连接的终端数目
-- @return [number][string]
-- @note
--  \n 0 无连接
--  \n 1 已连接, 暂无ssid
--  \n 2 已连接, 取得了ssid
l_wireless.sta_get_linkstatus = function ()
	return 0, 'ssid'
end


-- @brief 在sta模式下, scan功能初始化
l_wireless.sta_wpa_cli_start = function ()

end


-- @brief 在sta模式下, scan功能反初始化
l_wireless.sta_wpa_cli_cleanup = function ()

end


-- @brief 在sta模式下, 扫描热点
-- @return [table] 热点数组
--  \n {
--       {ssid="xxx",flags="xxx",signal="xxx", freq="xxx", bssid="xxx"},...
--  \n }
l_wireless.sta_get_scan_result = function ()
	return {}
end


-- @brief 'sta'模式连接到热点
-- @param [in] ssid[string]		ssid
-- @param [in] passwd[string]	密码
-- @param [in] flags[string]	连接标记
-- @return [boolean] 成功,失败
l_wireless.sta_connect2ap = function (ssid, passwd, flags)
	return true
end


-- @brief 'sta'模式下开启dhcpc客户端
l_wireless.sta_dhcpc_start = function ()

end


-- @brief 'sta'模式下关闭dhcpc客户端
l_wireless.sta_dhcpc_exit = function ()

end


-- @brief 'sta'模式下设置ip地址
-- @param [in] name[string]		网卡名称,例如"wlan0"
-- @param [in] ip[string]		ip地址
-- @param [in] netmask[string]	掩码
-- @param [in] gateway[string]	网关
l_wireless.set_ipaddr = function (name, ip, netmask, gateway)

end


return l_wireless
