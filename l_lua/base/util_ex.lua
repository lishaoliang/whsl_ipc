--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief  扩展公共模块,必须支持基础库: "cjson"
-- @author 李绍良
--]]
local cjson = require("cjson")

local util_ex = {}


local copy_t_p = nil
copy_t_p = function(t)
	local dst = {}
	
	for k, v in pairs(t) do
		if type(v) == 'table' then
			dst[k] = copy_t_p(v)
		elseif type(v) == 'string' or type(v) == 'number' or type(v) == 'boolean' then
			dst[k] = v
		else
			dst[k] = tostring(v)
		end
	end
	
	return dst
end

-- 按json方式打印
-- 此函数可以打印所有Lua对象, 但效率低下; 只可临时测试使用
util_ex.printf = function(...)
	local arg = {...} -- arg 为数组
	local tmp = copy_t_p(arg)

	print(cjson.encode(tmp))
end

return util_ex
