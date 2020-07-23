--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/20
--
-- @file    l_net_a.lua
-- @brief   扩展库 require("l_net_a"), 模块化网络支持
--  \n require("l_net_a")
--  \n 本库网络采用异步io模型, 部分模块 init,start,stop,quit有持续要求
--  \n l_net_a适用于: 内存紧张,高效环境
-- @version 0.1
-- @history 修改历史
--  \n 2019/14/20 0.1 创建文件
-- @warning 没有警告
--]]

local l_net_a = {}


-- @brief 网络模块初始化
-- @return [number]	0.成功; 非0.错误码
l_net_a.init = function ()
	return 0
end


-- @brief 网络模块反初始化
-- @return 无
l_net_a.quit = function ()
	return
end


-- @brief 网络模块启动线程
-- @return [number]	0.成功; 非0.错误码
--  \n 依次序启动 l_skdr_a 中创建的skdr线程
l_net_a.start = function ()
	return 0
end


-- @brief 网络模块反初始化
-- @return 无
l_net_a.stop = function ()
	return
end


return l_net_a
