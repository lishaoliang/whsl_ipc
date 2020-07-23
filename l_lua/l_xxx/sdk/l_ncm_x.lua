--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/20
--
-- @file    l_ncm_x.lua
-- @brief   内置库require("l_ncm_x"), net client man x86模块
--  \n require("l_ncm_x")
-- @version 0.1
-- @history 修改历史
--  \n 2019/14/20 0.1 创建文件
-- @warning 没有警告
--]]

local l_ncm_x = {}


-- @brief 创建nsm对象
-- @param [in]  	name[string]	nsm名称
-- @param [in]  	l_skdr[l_skdr_x]	l_skdr_x对象userdata(lightuserdata)
-- @return [nil, l_ncm_x] 创建成功的l_ncm_x对象
-- @note
--  \n 非线程安全; 必须在l_net_x.init之后, l_net_x.start之前调用
l_ncm_x.create = function (name, l_skdr)
	return l_ncm
	-- return nil
end


-- @brief 获取nsm对象
-- @param [in]  	name[string]	nsm名称
-- @return [nil, l_ncm_x] 创建成功的l_ncm_x对象
-- @note
--  \n 非线程安全;
l_ncm_x.get = function (name)
	return l_ncm
	-- return nil
end


-- @brief 使用proto_main:proto_sub协议 向ip:port 发起连接
-- @param [in]	l_ncm[l_ncm_x]			ncm对象
-- @param [in]	id[number]				连接id
-- @param [in]	proto_main[number] 		主协议
-- @param [in]	proto_sub[number] 		子协议
-- @param [in]	ip[string]				IP地址
-- @param [in]  port[number]			端口
-- @return [boolean] true.成功; false.失败
l_ncm_x.connect = function (l_ncm, id, proto_main, proto_sub, ip, port)
	return true
	-- return false
end



-- @brief 关闭值为id的socket
-- @param [in]	l_ncm[l_ncm_x]			nsm对象
-- @param [in]	id[number]				连接id
-- @return [boolean] true.成功; false.失败
l_ncm_x.close = function (l_ncm, id)
	return true
end


-- @brief 向id发送文本数据
-- @param [in]	l_ncm[l_ncm_x]	nsm对象
-- @param [in]	id[number]		连接id
-- @param [in]	body[string]	文本字符串
-- @return [boolean] true.成功; false.失败
l_ncm_x.send = function (l_ncm, id, body)
	return true
end


-- @brief 从nsm中获取文本数据
-- @param [in]	l_ncm[l_ncm_a]	nsm对象
-- @return [boolean]			true.有数据; false.无数据
--  \n 		code[number]		0.成功; 非0.网络错误码
--  \n		body[string]		从网络获取的字符串
--  \n		id[number]			连接id
--  \n		proto_main[number]	主协议
--  \n		proto_sub[number]	子协议
l_ncm_x.recv = function (l_ncm)
	return false, 0, '', id, proto_main, proto_sub
end


-- @brief 向id发送非文本数据(媒体OR二进制)
-- @param [in]	l_ncm[l_ncm_a]	nsm对象
-- @param [in]	id[number]		连接id
-- @param [in]	l_buf[l_buf]	缓存对象
-- @return [boolean]			true.成功; false.失败
l_ncm_x.send_md = function (l_ncm, id, l_buf)
	return true
	-- return false		-- 返回 false时, 调用者需要自行清理 l_buf
end


-- @brief 从nsm中获取媒体(二进制)数据
-- @param [in]	l_ncm[l_ncm_a]	ncm对象
-- @return [l_buf]				nil无数据, lightuserdata
--  \n		id[number]			连接id
--  \n		proto_main[number]	主协议
--  \n		proto_sub[number]	子协议
l_ncm_x.recv_md = function (l_ncm)
	return nil, id, proto_main, proto_sub
	-- return l_buf, id, proto_main, proto_sub
end

return l_ncm_x
