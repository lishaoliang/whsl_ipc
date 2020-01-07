--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/29
--
-- @file    inet.lua
-- @brief	服务端所有公共网络环境初始化
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/29 0.1 创建文件
-- @warning 没有警告
--]]

local inet = {}


local l_net_a = require("l_net_a")
local l_nmps_a = require("l_nmps_a")
local l_skdr_a = require("l_skdr_a")
local l_nsm_a = require("l_nsm_a")
local l_discover = require("l_discover")

local l_ipc = require("l_ipc")


-- @name   inet.skdr_com
-- @export 通用skdr, 用于业务压力小的模块
--  \n 例如: 1. 升级模块
inet.skdr_com = 'skdr_com'


-- @name   inet.nsm_upgrade
-- @export 升级子协议nsm管理模块
inet.nsm_upgrade = 'nsm_upgrade'



inet.init = function ()
	-- @1 公共网络基础初始化
	l_net_a.init()

	-- @2 创建 skdr
	local skdr_com = l_skdr_a.create(inet.skdr_com)
	
	-- @3 创建管理模块
	l_nsm_a.create(inet.nsm_upgrade, skdr_com)
	
	-- 网络发现模块
	l_discover.init()
	
	-- 主ipc业务
	l_ipc.init()
end


inet.quit = function ()
	l_ipc.quit()
	l_discover.quit()	
	l_net_a.quit()
end


inet.start = function ()
	l_net_a.start()	
	l_discover.start()	
	l_ipc.start()
end

inet.stop = function ()
	l_ipc.stop()
	l_discover.stop()	
	l_net_a.stop()
end


inet.get_nsm = function (nsm_name)
	return l_nsm_a.get(nsm_name)
end


inet.get_listener = function ()
	return l_ipc.get_push_stream()
end


return inet
