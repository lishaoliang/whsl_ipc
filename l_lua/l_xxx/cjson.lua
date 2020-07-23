--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    cjson.lua
-- @brief   内置库 require("cjson"), 函数说明
--  \n 内置库 require("cjson.safe"), 不抛出异常版本
-- @version 2.1.0
-- @author  Mark Pulford
--  \n 源码地址: 
--  \n 官方手册: 
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
-- @note 注意使用 内置的cjson库会抛出异常
--]]
local cjson = {}


-- @brief 将对象编码成json
-- @param [in] t[table] table对象
-- @return [string] json字符串
cjson.encode = function (t)
	return ''
end


-- @brief 将json字符串解码成table对象
-- @param [in] json[string] json字符串
-- @return [table] table对象
-- @note 注意此函数会抛出异常, 调用方法如下
-- local ret, obj = pcall(cjson.decode, txt)
cjson.decode = function (json)
	return {}
end


return cjson
