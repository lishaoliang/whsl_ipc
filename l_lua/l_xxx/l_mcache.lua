--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/20
--
-- @file    l_mcache.lua
-- @brief   内置库require("l_mcache"), Lua各个线程之间的k, v格式共享缓存
--  \n require("l_tpool")
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/14/20 0.1 创建文件
-- @warning 没有警告
--]]

local l_mcache = {}


-- @brief 缓存模块初始化
-- @param [in]  	ht_size[number]	hash table 大小(默认4096, 最小100)
--l_mcache.init = function (ht_size)
--	return
--end


-- @brief 缓存模块反初始化
--l_mcache.quit = function ()
--	return
--end


-- @brief 清空所有k, v
l_mcache.clear = function ()
	return
end


-- @brief 设置k, v
-- @param [in]  	k[string]	关键字
-- @param [in]		v[~]		值
--  \n v = l_obj, boolean, number, string
-- @return [boolean] true.成功; false.失败
--  \n 同k会替换成新值
l_mcache.set = function (k, v)
	return true
end


-- @brief 获取k的v值
-- @param [in]  	k[string]	关键字
-- @return v	= nil, l_obj, boolean, number, string
--  \n     type	= 'nil', 'l_obj', 'boolean', 'number', 'string'
l_mcache.get = function (k)
	return nil, 'nil'
	-- return l_obj, 'l_obj'
	-- return true, 'boolean'
	-- return 0, 'number'
	-- return '', 'string'
end


return l_mcache
