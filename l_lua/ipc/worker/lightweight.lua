--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
--
-- @file    lightweight.lua
-- @brief   轻量级工作线程入口
-- @version 0.1
-- @author	李绍良
--]]

local lt_name = ''

init = function (param)
	--print('init .....', param)
	lt_name = param
	return 0
end

quit = function ()
	--print('quit .....')
	return 0
end

on_cmd = function (msg, lparam, wparam, cobj)
	print('on_cmd.name:'..lt_name, msg, lparam, wparam)
	return 0
end
