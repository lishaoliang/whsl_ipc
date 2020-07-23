--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/10/14
--
-- @file    gpio_reset_compatible.lua
-- @brief   gpio_reset长按复位,兼容性检查
-- @author	李绍良
-- @version 0.1
-- @warning 没有警告
-- @note
--  3519旧板(2019/9前)将GPIO3_4复用为JTAG, 从GPIO3_4读取的值一直为低电平0;
--  3519新板将GPIO3_4复用为gpio口, 从高电平变为低电平, 则表示需要复位;
--  为解决兼容性问题: 3519板先必须得到一系列高电平, 再生效复位模块
--]]
local table = require("table")
local l_sys = require("l_sys")
local chip = l_sys.chip	-- 芯片型号


local enable = true			-- 默认使能

if 'hi_3519' == chip or 'hi_3516av200' == chip then
	enable = false			-- 3519, 3516av200默认不使能, 需要兼容处理
end


local check_num = 6		-- 检查个数

local gpio_values = {}


-- 检查是否可以使能
local check_enable_reset = function ()
	if check_num ~= #gpio_values then
		return false
	end

	-- 检查高电平个数
	local hi_num = 0
	for k, v in pairs(gpio_values) do
		if 0 ~= v then
			hi_num = hi_num + 1 
		end
	end

	-- 至少 check_num - 1 个高电平, 则认为可以使能
	if check_num <= hi_num + 1 then
		return true
	end	
	
	return false
end


-- 复位模块是否使能
-- 做兼容之后, 要求用户需要间歇性按复位键
local gpio_reset_compatible = function (v)	
	if enable then
		return true -- 如果是使能状态, 则后面不再检查
	end

	-- 并将值插入table 
	table.insert(gpio_values, 1, v)
	
	-- 保证数组中只有最新的几个值
	while check_num < #gpio_values do
		table.remove(gpio_values)
	end

	-- 检查是否可以使能
	-- 连续监测到多个高电平, 则认为可以使能
	enable = check_enable_reset()
	
	if enable then
		print('ipc.gpio.gpio_reset_compatible, check enable true!')
		
		gpio_values = {}
	end
	
	return enable
end


return gpio_reset_compatible
