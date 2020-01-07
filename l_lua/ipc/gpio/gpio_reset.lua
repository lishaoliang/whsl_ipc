--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/09/17
--
-- @file    gpio_reset.lua
-- @brief   gpio_reset长按复位
-- @author	李绍良
-- @version 0.1
-- @warning 没有警告
--]]
local table = require("table")
local l_sys = require("l_sys")
local gpio = require("base.gpio")
local gpio_reset_compatible = require("ipc.gpio.gpio_reset_compatible")
local chip = l_sys.chip	-- 芯片型号


local gpio_reset = {}


local enable = false	-- 是否使用 reset
local grp = 3			-- gpio组
local idx = 4			-- gpio组内序号


if 'hi_3519' == chip or 'hi_3516av200' == chip then	-- 3519使用GPIO3_4
	enable = true
	grp = 3
	idx = 4
elseif 'hi_3516a' == chip then -- 3516a使用GPIO10_3
	enable = true
	grp = 10
	idx = 3
	gpio = require("ipc.gpio.gpio_my") -- 3516a使用自定义gpio实现
end


local check_tc = 500	-- 检查时间间隔
local check_num = 6		-- 检查个数, 需要总时间为: check_tc * check_num

local gpio_values = {}


-- 是否需要复位
local need_reset = function ()
	if check_num ~= #gpio_values then
		return false
	end

	-- 按住按键后, 是 将高电平转换为低电平
	-- 这里检查低电平个数
	local low_num = 0
	for k, v in pairs(gpio_values) do
		if 0 == v then
			low_num = low_num + 1 
		end
	end

	-- 至少 check_num - 1 个低电平, 就认为触发复位
	if check_num <= low_num + 1 then
		return true
	end	
	
	return false
end


-- 初始化
gpio_reset.init = function ()
	if not enable then
		print('gpio not enable.', grp, idx)
		return
	end	
	
	gpio.open(grp, idx)
	gpio.set_in(grp, idx)
end


-- 退出
gpio_reset.quit = function ()
	if not enable then
		return
	end
	
	gpio.close(grp, idx)
end

local time_tc = 0 

-- 检查流程
gpio_reset.check_proc = function (tc)
	if not enable then
		return
	end

	-- 计时
	time_tc = time_tc + tc
	if time_tc < check_tc then
		return
	end
	time_tc = 0
	
	
	-- 获取值
	local value = gpio.get_value(grp, idx)

	-- 兼容性旧板逻辑, 决定是否生效后续复位判定
	if not gpio_reset_compatible(value) then
		return false
	end
	
	-- 并将值插入table 
	table.insert(gpio_values, 1, value)
	
	-- 保证数组中只有最新的几个值
	while check_num < #gpio_values do
		table.remove(gpio_values)
	end
	
	-- 检查是否需要复位
	return need_reset()
end


return gpio_reset
