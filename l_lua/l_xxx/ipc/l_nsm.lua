--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_nsm.lua
-- @brief   内置库"l_nsm", 函数说明
-- @version 0.1
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_nsm = {}



-- @brief 设置数据回调处理函数
-- @param [in] cb[function] 
-- @return [boolean] 返回是否成功
-- @note [number] = cb(id, protocol, body)
--  \n [in] id[number] 连接id
--  \n [in] protocol[number] 协议值;参考 base.np_id
--  \n [in] body 客户端发送过来的文本数据体
--  \n return [number] 0.表示保持连接; 非0.断开连接
l_nsm.set_recv = function (cb)
	return true
	-- return false
end

-- @brief 设置连接断开回调处理函数
-- @param [in] cb[function] 
-- @return [boolean] 返回是否成功
-- @note [number] = cb(id, protocol, body)
--  \n [in] id[number] 连接id
--  \n [in] protocol[number] 协议值;参考 base.np_id
--  \n return [number] 0.表示保持连接; 非0.断开连接
l_nsm.set_disconnect = function (cb)
	return true
	-- return false
end

-- @brief 发送数据
-- @param [in] id[number]	发送的连接id
-- @param [in] body[string] 文本数据
-- @return [boolean] 返回是否发送成功
l_nsm.send = function (id, body)
	return true
	-- return false
end


-- @brief 开启发送媒体流
-- @param [in] id[number]	 发送的连接id
-- @param [in] chnn[number]	 通道
-- @param [in] idx[number]	 流序号
-- @param [in] md_id[number] 媒体id
-- @return [number]
l_nsm.open_stream =  function (id, chnn, idx, md_id)
	return 0
end


-- @brief 关闭发送媒体流
-- @param [in] id[number]	 发送的连接id
-- @param [in] chnn[number]	 通道
-- @param [in] idx[number]	 流序号
-- @param [in] md_id[number] 媒体id
-- @return [number]
l_nsm.close_stream =  function (id, chnn, idx, md_id)
	return 0
end

-- @brief 获取通道流的SPS/PPS(base64编码字符串)
-- @param [in] chnn[number]	 通道
-- @param [in] idx[number]	 流序号
-- @return [string],[string] SPS/PPS
l_nsm.get_sps_pps = function (chnn, idx)
	return '', ''
end

-- @brief 获取通道流的SPS/PPS(base64编码字符串)
-- @param [in] chnn[number]	 通道
-- @param [in] idx[number]	 流序号
-- @return [nil, l_obj_buf_t]	数据块
--			size[number]		读到的数据大小
--			[string]			类型: 'jpeg'
l_nsm.get_frame = function (chnn, idx)
	return nil, 0, ''
	-- return xxx, 1200, 'jpeg'
end

return l_nsm
