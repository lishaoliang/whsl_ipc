--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/09/12
--
-- @file    gpio.lua
-- @brief   gpio通用操作
-- @author	李绍良
-- @version 0.1
-- @warning 没有警告
--]]

local string = require("string")
local unix = require("base.unix")
local gpio = {}


-- @brief 获取gpio编号
-- @param [in]  	grp[number]	组号
-- @param [in]		idx[number]	组内序号
-- @return [number] 编号
local get_grp_id = function (grp, idx)
	return 8 * grp + idx
end


-- @brief 打开gpio
-- @param [in]  	grp[number]	组号
-- @param [in]		idx[number]	组内序号
-- @return 无
gpio.open = function (grp, idx)
	local id = get_grp_id(grp, idx)
	local cmd = string.format('echo %d > /sys/class/gpio/export', id)	
	local ret, str = unix.shell(cmd)
	
	print('gpio.open:', grp, idx)
end


-- @brief 关闭gpio
-- @param [in]  	grp[number]	组号
-- @param [in]		idx[number]	组内序号
-- @return 无
gpio.close = function (grp, idx)
	local id = get_grp_id(grp, idx)
	local cmd = string.format('echo %d > /sys/class/gpio/unexport', id)	
	local ret, str = unix.shell(cmd)
	
	print('gpio.close:', grp, idx)
end


-- @brief 设置gpio为输入
-- @param [in]  	grp[number]	组号
-- @param [in]		idx[number]	组内序号
-- @return 无
-- @note 从外部获取信号, 默认1(高电平)
gpio.set_in = function (grp, idx)
	local id = get_grp_id(grp, idx)
	local cmd = string.format('echo in > /sys/class/gpio/gpio%d/direction', id)	
	local ret, str = unix.shell(cmd)
	
	print('gpio.set_in:', grp, idx)
end


-- @brief 设置gpio为输出
-- @param [in]  	grp[number]	组号
-- @param [in]		idx[number]	组内序号
-- @return 无
-- @note 向外部输出信号, 默认0(低电平)
gpio.set_out = function (grp, idx)
	local id = get_grp_id(grp, idx)
	local cmd = string.format('echo out > /sys/class/gpio/gpio%d/direction', id)	
	local ret, str = unix.shell(cmd)
	
	print('gpio.set_out:', grp, idx)
end


-- @brief 设置gpio信号值
-- @param [in]  	grp[number]		组号
-- @param [in]		idx[number]		组内序号
-- @param [in]		value[number]	信号值[0, 1]; 0.低电平; 1.高电平
-- @return 无
-- @note 设置gpio为输出时, 有效
gpio.set_value = function (grp, idx, value)
	if 0 ~= value then
		value = 1 -- 0, 1
	end
	
	local id = get_grp_id(grp, idx)
	local cmd = string.format('echo %d > /sys/class/gpio/gpio%d/value', value, id)	
	local ret, str = unix.shell(cmd)
	
	--print('gpio.set_value:', grp, idx, ret, str)
end


-- @brief 获取gpio信号值
-- @param [in]  	grp[number]		组号
-- @param [in]		idx[number]		组内序号
-- @return [number] 信号值[0, 1]
gpio.get_value = function (grp, idx)
	local id = get_grp_id(grp, idx)
	local cmd = string.format('cat /sys/class/gpio/gpio%d/value', id)	
	local ret, str = unix.shell(cmd)
	
	--print('gpio.get_value:', grp, idx, ret, str)
	local value = tonumber(str)
	return value
end

return gpio
