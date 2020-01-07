--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/20
--
-- @file    l_nsm_a.lua
-- @brief   内置库require("l_nsm_a"), net server man arm模块
--  \n require("l_net_a")
-- @version 0.1
-- @history 修改历史
--  \n 2019/14/20 0.1 创建文件
-- @warning 没有警告
--]]

local l_nsm_a = {}


-- @brief 创建nsm对象
-- @param [in]  	name[string]		nsm名称
-- @param [in]  	l_skdr[l_skdr_a]	l_skdr_a对象userdata(lightuserdata)
-- @return [nil, l_nsm_a] 创建成功的l_nsm_a对象
-- @note
--  \n 非线程安全; 必须在l_net_a.init之后, l_net_a.start之前调用
l_nsm_a.create = function (name, l_skdr)
	return l_nsm
	-- return nil
end


-- @brief 获取nsm对象
-- @param [in]  	name[string]	nsm名称
-- @return [nil, l_nsm_a] 创建成功的l_nsm_a对象
-- @note
--  \n 非线程安全;
l_nsm_a.get = function (name)
	return l_nsm
	-- return nil
end


-- @brief 将socket交给nsm模块管理
-- @param [in]	l_nsm[l_nsm_a]			nsm对象
-- @param [in]	l_socket[l_socket_a]	监听函数l_nmps_a.get_socket函数得到l_socket
-- @param [in]	id[number]				连接id
-- @param [in]	proto_main[number] 		主协议
-- @param [in]	proto_sub[number] 		子协议
-- @return [boolean] true.成功; false.失败
-- @note false.失败后, 需自行处理 l_socket
l_nsm_a.push = function (l_nsm, l_socket, id, proto_main, proto_sub)
	return true
end


-- @brief 关闭值为id的socket
-- @param [in]	l_nsm[l_nsm_a]			nsm对象
-- @param [in]	id[number]				连接id
-- @return [boolean] true.成功; false.失败
l_nsm_a.close = function (l_nsm, id)
	return true
end


-- @brief 向id发送文本数据
-- @param [in]	l_nsm[l_nsm_a]	nsm对象
-- @param [in]	id[number]		连接id
-- @param [in]	body[string]	文本字符串
-- @return [boolean] true.成功; false.失败
l_nsm_a.send = function (l_nsm, id, body)
	return true
end


-- @brief 从nsm中获取文本数据
-- @param [in]	l_nsm[l_nsm_a]	nsm对象
-- @return [boolean]			true.有数据; false.无数据
--  \n 		code[number]		0.成功; 非0.网络错误码
--  \n		body[string]		从网络获取的字符串
--  \n		id[number]			连接id
--  \n		proto_main[number]	主协议
--  \n		proto_sub[number]	子协议
l_nsm_a.recv = function (l_nsm)
	return false, 0, '', id, proto_main, proto_sub
end


-- @brief 向id发送非文本数据(媒体OR二进制)
-- @param [in]	l_nsm[l_nsm_a]	nsm对象
-- @param [in]	id[number]		连接id
-- @param [in]	l_buf[l_buf]	缓存对象
-- @return [boolean]			true.成功; false.失败
l_nsm_a.send_md = function (l_nsm, id, l_buf)
	return true
	-- return false		-- 返回 false时, 调用者需要自行清理 l_buf
end


-- @brief 从nsm中获取媒体(二进制)数据
-- @param [in]	l_nsm[l_nsm_a]	nsm对象
-- @return [l_buf]				nil无数据, lightuserdata
--  \n		id[number]			连接id
--  \n		proto_main[number]	主协议
--  \n		proto_sub[number]	子协议
l_nsm_a.recv_md = function (l_nsm)
	return nil, id, proto_main, proto_sub
	-- return l_buf, id, proto_main, proto_sub
end

return l_nsm_a
