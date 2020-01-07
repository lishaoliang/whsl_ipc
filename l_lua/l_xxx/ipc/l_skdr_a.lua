--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/20
--
-- @file    l_skdr_a.lua
-- @brief   内置库require("l_skdr_a"), 网络异步io驱动线程
--  \n require("l_net_a")
--  \n 必须在l_net_a.init之后, l_net_a.start之前完成所线程的l_skdr_a.create工作
--  \n 进程运行过程中, 不可动态修改
-- @version 0.1
-- @history 修改历史
--  \n 2019/14/20 0.1 创建文件
-- @warning 没有警告
--]]

local l_skdr_a = {}


-- @brief 创建skdr线程
-- @param [in]  	name[string]	名称
-- @return [nil, l_skdr_a] l_skdr_a对象
l_skdr_a.create = function (name)
	return l_skdr_a
end


-- @brief 获取skdr线程
-- @param [in]  	name[string]	名称
-- @return [nil, l_skdr_a] l_skdr_a对象
l_skdr_a.get = function (name)
	return l_skdr_a
end


return l_skdr_a
