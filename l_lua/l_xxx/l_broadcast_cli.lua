--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/04/12
--
-- @file    l_broadcast_cli.lua
-- @brief   扩展库"l_broadcast_cli", 广播客户端
--  \n 所有函数必须 l_discover.init, l_discover.start 之后才可以调用
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/12 创建文件
-- @warning 没有警告
--]]

local l_broadcast_cli = {}


-- @brief 打开广播
-- @param [in]  	id[number]	id号
-- @param [in]		idx[number]	idx序号
-- @param [in]		ip[string]	广播ip地址: 例如'255.255.255.255', '192.168.255.255'
-- @param [in]		port[number] 广播端口
-- @return [boolean] true, false
l_broadcast_cli.open = function (id, idx, ip, port)
	return true
end


-- @brief 关闭广播
-- @param [in]  	id[number]	id号
-- @param [in]		idx[number]	idx序号
-- @return [boolean] true, false
l_broadcast_cli.close = function (id, idx)
	return true
end


-- @brief 关闭所有同一id的广播
-- @param [in]  	id[number]	id号
-- @return [boolean] true, false
l_broadcast_cli.close_all = function (id)
	return true
end


-- @brief 发送一次'discover'请求数据包
-- @param [in]  	id[number]	id号
-- @return [boolean] true, false
l_broadcast_cli.discover = function (id)
	return true
end


-- @brief 获取广播数据
-- @return  ret[boolean]	true.获取到数据; false.没有数据
--	\n	code[number]		0.获取广播消息; 非0.获取到错误码
--	\n	body[string]		广播消息
--	\n	protocol[number]	协议
--	\n	id[number]			id号
--	\n	ip[string]			发送广播的IP
--	\n	port[number]		端口
-- @note 注意事项,参见xxx
l_broadcast_cli.recv = function ()
	return true, 0, '{}', 22, 900, '192.168.1.247', 25354
end


-- @brief 发送广播数据[string.len(body) <= 1340]
-- @param [in]  	id[number]		id号
-- @param [in]		body[string]	待发送的的数据
-- @return [boolean] true, false
l_broadcast_cli.send = function (id, body)
	return true
end


return l_broadcast_cli
