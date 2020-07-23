--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/20
--
-- @file    l_nmps_a.lua
-- @brief   内置库require("l_nmps_a"), 监听端口多路复用
--  \n require("l_net_a")
-- @version 0.1
-- @history 修改历史
--  \n 2019/14/20 0.1 创建文件
-- @warning 没有警告
--]]

local l_nmps_a = {}


-- @brief 打开监听端口
-- @param [in]  	name[string]	名称 < 64
-- @param [in]  	port[number]	监听端口
-- @return [boolean] true.成功; false.失败
l_nmps_a.open = function (name, port)
	return true
end

-- @brief 打开监听端口,
-- @param [in]  	name[string]	名称 < 64
-- @param [in]  	port[number]	监听端口
-- @param [in]		path[string]	unix本地socket路径; 例如"/tmp/xxx.xxx"
-- @return [boolean] true.成功; false.失败
-- @note unix下使用本地socket
--  \n windows下使用port创建一般socket
l_nmps_a.open_unix = function (name, port, path)
	return true
end


-- @brief 关闭监听端口
-- @param [in]  	name[string]	名称 < 64
-- @return [boolean] true.成功; false.失败
l_nmps_a.close = function (name)
	return true
end


-- @brief 获取监听得到的socket
-- @return  [nil,l_socket] l_obj对象: l_socket
--  \n 		20 [number]		主协议
--  \n 		0 [number]		子协议
--  \n 		x [string]		如果是文本协议, 则为请求的URL前一部分(最多约64字节)
l_nmps_a.get_socket = function ()
	return l_socket, 20, 0, 'xxx'
	-- return nil, 0, 0, ''
end


return l_nmps_a
