--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/4/23
--
-- @file    lw_upgrade.lua
-- @brief   轻量级升级线程
-- @version 0.1
-- @author	李绍良
-- @history 修改历史
--  \n 2019/4/23 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local cjson = require("cjson")
local l_sys = require("l_sys")

local util = require("base.util")
local np_id = require("base.np_id")

local inet = require("ipc.inet")
local upgrade = require("ipc.upgrade.upgrade")


local lt_name = ''


local on_timer_recv = function (id, count, interval, tc, last_tc)
	
	-- upgrade定时调用
	upgrade.on_recv()
	
	return 0
end


init = function (param)
	--print('init .....', param)
	lt_name = param

	local nsm_upgrade = inet.get_nsm(inet.nsm_upgrade)
	assert(nsm_upgrade)
	
	upgrade.init(nsm_upgrade)
	
	-- 添加定时器
	l_sys.add_timer(100, 10, on_timer_recv)		-- 定时取消息
		
	return 0
end

quit = function ()
	--print('quit .....')
	
	l_sys.remove_timer(100)

	upgrade.quit()
	
	return 0
end

on_cmd = function (msg, lparam, wparam, cobj)
	--print('on_cmd.name:'..lt_name, msg, lparam, wparam)
	
	local cmd_low = string.lower(msg) -- 不区分key字段大小写
	
	return 0
end
