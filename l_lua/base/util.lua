--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief  基础公共模块
-- @author 李绍良
--]]
local string = require("string")

local util = {}


local socket_id = 1000


-- @brief 获取下一个socket id (1000, 2147418112)
util.next_socket_id = function ()
	socket_id = socket_id + 1
	if 2147418112 <= socket_id then -- (1000 0x7FFF0000)
		socket_id = 1000
	end	
	
	return socket_id
end

-- @brief 去除字符串首尾空格
-- @param [in]		s[string]	字符串
-- @return [string] 去除首尾空格的字符串
util.trim = function(s)
	return (string.gsub(s, '^%s*(.-)%s*$', '%1'))
end


-- @brief 去除字符串首尾控制字符'\n'
util.trim_c = function(s)
	return (string.gsub(s, '^%c*(.-)%c*$', '%1'))
end


-- @brief 去除字符串首尾:控制字符'\n',空格
util.trim_cs = function(s)
	return (string.gsub(s, '^%c*%s*(.-)%c*%s*$', '%1'))
end

-- 判定table是否为数组
-- t [table,nil] table对象
-- return [boolean]
util.t_is_array = function(t)
	if 'table' ~= type(t) then 
		return false
	end
	
	local n = #t
	for i, v in pairs(t) do
		if 'number' ~= type(i) then
			return false  
		end
		
		if n < i then
			return false
		end
	end
	
	return true
end

-- 判定table是否为空
-- t [table,{}] table对象
-- return [boolean]
util.t_is_empty = function(t)
	if 'table' ~= type(t) then
		return true
	end

	if nil ~= next(t) then
		return false
	end
	
	return true
end

-- brief 判定table不为空
-- t [table,nil,{}] table对象
-- return [boolean]
util.t_is_not_empty = function(t)
	if 'table' == type(t) then
		if nil ~= next(t) then
			return true
		end
	end
	
	return false
end


-- brief 获取table的子项
-- t [table] 表
-- {...}	 key字符串
-- return nil, .
util.t_item = function (t, ...)
	local o = t
	for k, v in ipairs({...}) do
		if 'table' ~= type(o) then
			return nil
		end
		o = o[v]
	end
	return o
end


-- brief 求取 dst, src 的并集, 放置在 dst 中
-- dst [table] 目标表
-- src [table] 原表
-- return [table] dst
-- note 只处理 [number, string, boolean]
-- 如果有相同key, 则 src会覆盖 dst中的同key值
util.t_union = function (dst, src)
	if nil == dst then
		return util.t_copy(src)
	end
	
	if nil ~= src then
		for k, v in pairs(src) do
			local skt = type(src[k])
			local dkt = type(dst[k])
			
			if 'number' == skt or 'string' == skt or 'boolean' == skt then
				dst[k] = src[k]
			end
				
			if 'table' == skt then
				if 'table' == dkt then
					dst[k] = util.t_union(dst[k], src[k])
				else
					dst[k] = util.t_copy(src[k])
				end
			end
		end
	end
	
	return dst
end


-- brief 将表src中的[number, string, boolean]复制到对应的dst中
-- dst [table] 目标表
-- src [table] 原表
-- return [table] dst
util.t_cp_by = function (dst, src)
	
	if nil ~= dst then
		for k, v in pairs(dst) do
			local dkt = type(dst[k])
			local skt = type(src[k])
			
			if dkt == skt then
				if 'number' == dkt or 'string' == dkt or 'boolean' == dkt then
					dst[k] = src[k]
				end
				
				if 'table' == dkt then
					util.t_cp_by(dst[k], src[k])
				end
			end
		end
	end
	
	return dst
end


-- brief 复制一个table,只复制:number, string, boolean
-- src [table]	  原始table
-- return [table] 被复制的新table
util.t_copy = function(src)
	if nil == src then
		return nil
	end

	local dst = {}
	for k, v in pairs(src) do
		if 'table' == type(src[k]) then
			dst[k] = util.t_copy(v)
		elseif 'number' == type(src[k]) or 'string' == type(src[k]) or 'boolean' == type(src[k]) then
			dst[k] = v
		else
			
		end
	end
	
	return dst
end

return util
