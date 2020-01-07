--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_hash.lua
-- @brief   内置库 require("l_hash"), 函数说明
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]
local l_hash = {}


-- @brief 获取字符串的hash值
-- @param [in] str[string] 字符串
-- @return [string] hash数值(uint32)
l_hash.dx = function (str)
	return '123456'
end


-- @brief 获取字符串的hash值
-- @param [in] str[string] 字符串
-- @return [string] hash数值(uint32)
l_hash.rs = function (str)
	return '123456'
end

-- @brief 获取字符串的hash值
-- @param [in] str[string] 字符串
-- @return [string] hash数值(uint32)
l_hash.js = function (str)
	return '123456'
end

-- @brief 获取字符串的hash值
-- @param [in] str[string] 字符串
-- @return [string] hash数值(uint32)
l_hash.ap = function (str)
	return '123456'
end


return l_hash
