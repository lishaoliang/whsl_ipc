--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_ncm.lua
-- @brief   内置库"l_ncm", 函数说明
-- @version 0.1
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_ncm = {}


-- @brief 设置sdk接口操作
-- @param [in] cb_login[function] 当接口login被调用时的回调
-- @param [in] cb_logout[function] 当接口logout被调用时的回调
-- @param [in] cb_request[function] 当接口request被调用时的回调
-- @return [boolean] 返回是否成功
-- @note 
--  \n [number][number] = cb_login(seq, id, param)
--  \n [in] seq[number] 会话序列
--  \n [in] id[number] 登录id(即连接id)
--  \n [in] param[string] 登录字符串参数(json)
--  \n return [number] 错误码
--  \n [number] = cb_logout(seq, id)
--  \n [in] seq[number] 会话序列
--  \n [in] id[number] 登录id(即连接id)
--  \n return [number] 错误码
--  \n [number] = cb_request(seq, id, str_req)
--  \n [in] seq[number] 会话序列
--  \n [in] id[number] 登录id(即连接id)
--  \n [in] str_req[string] 请求字符串(json)
--  \n return [number] 错误码
l_ncm.set_sdk = function (cb_login, cb_logout, cb_request)
	return 0
end


l_ncm.set_sdk_discover = function (cb_discover_open, cb_discover_close, cb_discover_run, cb_discover_get_devs, cb_discover_request)
	return 0
end

-- @brief 回复sdk数据
-- @param [in] seq[number]	会话序列号
-- @param [in] id[number]	登录id
-- @param [in] code[number]	错误码
-- @param [in] str_res[string] 文本数据
-- @return [boolean] 是否回复成功
l_ncm.response_sdk = function (seq, id, code, str_res)
	return true
end


-- @brief 设置数据回调处理函数
-- @param [in] cb[function] 当网络上来数据的回调函数
-- @return [boolean] 返回是否成功
-- @note [number] = cb(id, protocol, body)
--  \n [in] id[number] 连接id
--  \n [in] protocol[number] 协议值;参考 base.np_id
--  \n [in] body[string] 客户端发送过来的文本数据体
--  \n return [number] 0.表示保持连接; 非0.断开连接
l_ncm.set_recv = function (cb)
	return true
	-- return false
end


-- @brief 设置连接断开的回调处理函数
-- @param [in] cb[function] 当连接断开的回调函数
-- @return [boolean] 返回是否成功
-- @note [number] = cb(id, code)
--  \n [in] id[number] 连接id
--  \n [in] code[number] 错误码
--  \n return [number] 0.成功
l_ncm.set_disconnect = function (cb)
	return true
	-- return false
end


-- @brief 向网络发送数据
-- @param [in] id[number]	发送的连接id
-- @param [in] body[string] 文本数据
-- @return [boolean] 返回是否发送成功
l_ncm.send = function (id, body)
	return true
	-- return false
end


-- @brief 发起连接
-- @param [in] ip[string]	目标ip
-- @param [in] port[number]	目标端口
-- @param [in] id[number]	客户端id(即连接id)
-- @param [in] protocol[number] 目标协议(默认np_id.NSPP)
-- @return [boolean] 是否发起连接
-- @note 这只是发起连接, 是否连接成功, 在 set_recv的回调函数中给出结果
l_ncm.connect = function (ip, port, id, protocol)
	return true,10000
	-- return false,0
end


-- @brief 获取ncm对象
-- @param [in] name[string] 对象名称: 'upgrade'
-- @return [nil, l_ncm_x] 返回l_ncm_x对象
l_ncm.get_ncm = function (name)
	return nil
	-- return l_ncm_x
end


return l_ncm
