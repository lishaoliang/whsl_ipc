--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief  默认配置处理模块
-- @author 李绍良
--]]
local util = require("base.util")

local default = {}

default.default_v = require("ipc.cfg.default_v")
default.default_r = require("ipc.cfg.default_r")

default.keys = {}


-- @brief 初始化
--  \n 初始化keys 
default.init = function ()
	local t = {}
	
	for k, v in pairs(default.default_v) do
		if 'string' == type(k) then
			table.insert(t, k)
		end
	end

	for k, v in pairs(default.default_r) do
		if 'string' == type(k) and nil == t[k] then
			table.insert(t, k)
		end
	end
	
	default.keys = t
end



-- brief 获取可变配置项目
-- key [string]		  配置名称
-- return [nil,table] 被拷贝的数据, 可以任意使用
default.get_v = function (key)
	local value = default.default_v[key]
	
	if nil ~= value then
		-- 默认配置的数据不得被外部污染
		return util.t_copy(value)
	end
	
	return nil
end

-- brief 获取只读项
-- key [string]		  配置名称
-- return [nil,table] 被拷贝的数据, 可以任意使用
default.get_r = function (key)
	local value = default.default_r[key]
	
	if nil ~= value then
		-- 默认配置的数据不得被外部污染
		return util.t_copy(value)
	end
	
	return nil
end

return default
