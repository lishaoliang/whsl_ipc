--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/05/07
--
-- @file    l_http_sa.lua
-- @brief   内置库require("l_http_sa"), http client arm模块
--  \n require("l_net_a")
-- @version 0.1
-- @history 修改历史
--  \n 2019/05/07 0.1 创建文件
-- @warning 没有警告
--]]

local l_http_sa = {}


-- @brief 创建http对象
-- @param [in]  	name[string]		http名称
-- @param [in]  	l_skdr[l_skdr_a]	l_skdr_a对象userdata(lightuserdata)
-- @return [nil, l_http_sa] 创建成功的l_http_ca对象
-- @note
--  \n 非线程安全; 必须在l_net_a.init之后, l_net_a.start之前调用
l_http_sa.create = function (name, l_skdr)
	return l_nsm
	-- return nil
end


-- @brief 获取http对象
-- @param [in]  	name[string]	nsm名称
-- @return [nil, l_http_sa] 创建成功的l_nsm_a对象
-- @note
--  \n 非线程安全;
l_http_sa.get = function (name)
	return l_nsm
	-- return nil
end


-- @brief 将socket交给http模块管理
-- @param [in]	http[l_http_sa]			http对象
-- @param [in]	l_socket[l_socket_a]	监听函数l_nmps_a.get_socket函数得到l_socket
-- @param [in]	id[number]				连接id
-- @param [in]	proto_main[number] 		主协议
-- @return [boolean] true.成功; false.失败
-- @note false.失败后, 需自行处理 l_socket
l_http_sa.push = function (http, l_socket, id, proto_main)
	return true
end


-- @brief 关闭值为id的socket
-- @param [in]	http[l_http_sa]	http对象
-- @param [in]	id[number]		连接id
-- @return [boolean] true.成功; false.失败
l_http_sa.close = function (http, id)
	return true
end


-- @brief 向id发送文本数据
-- @param [in]	http[l_http_sa]	http对象
-- @param [in]	id[number]		连接id
-- @param [in]	body[string]	文本字符串
-- @return [boolean] true.成功; false.失败
l_http_sa.send = function (http, id, body)
	return true
end


-- @brief 从http中获取文本数据
-- @param [in]	http[l_http_sa]	http对象
-- @return [boolean]			true.有数据; false.无数据
--  \n 		code[number]		0.成功; 非0.网络错误码
--  \n		head[string]		http头部
--  \n		body[string]		http的body
--  \n		id[number]			连接id
--  \n		proto_main[number]	主协议
l_http_sa.recv = function (http)
	return false, 0, '', '', id, proto_main
end

return l_http_sa
