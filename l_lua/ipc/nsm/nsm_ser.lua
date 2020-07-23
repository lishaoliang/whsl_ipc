--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- Created: 2018/12/21
--
-- @file   nsm_ser.lua
-- @brief  nsm服务端对应的处理部分
-- @author 李绍良
--]]
local string = require("string")
local cjson = require("cjson")
local l_nsm = require("l_nsm")

local np_id = require("base.np_id")
local json_request = require("ipc.nsm.json_request")
local rtsp_ser = require("ipc.nsm.rtsp_ser")
local nspp_http_ser = require("ipc.nsm.nspp_http_ser")
local flv_http_ser = require("ipc.nsm.flv_http_ser")

local nsm_ser = {
	b_res = true
}


local send = function (id, body)
	local t = type(body)
	
	if 'string' == t then
		l_nsm.send(id, body)
		nsm_ser.b_res = true
	elseif 'table' == t then
		local txt = cjson.encode(body)
		l_nsm.send(id, txt)
		nsm_ser.b_res = true
	else
		assert(false)
	end
end


local parser_req = function(id, txt)
	local req ={
		id = id,			-- 连接id
		cmd = '',			-- cmd,llssid,llauth 这三项必须被提取出来
		llssid = '',		-- 客户端 llssid
		llauth = '',		-- 客户端授权码 llauth
		
		local_unix = false, -- 是否为本地请求
		body = {}			-- 请求的数据体, 最后的结果必须为table
	}

	-- txt 数据从网络而来, 不可完全信任
	if 'string' == type(txt) and 0 < string.len(txt) then
		local ret, obj = pcall(cjson.decode, txt)		
		--print(ret, obj)
		
		if ret and 'table' == type(obj) then
			req.body = obj
		end	
		
		if 'string' == type(req.body['cmd']) then
			req.cmd = req.body['cmd']
		end
		
		if 'string' == type(req.body['llssid']) then
			req.llssid = req.body['llssid']
		end
		
		if 'string' == type(req.body['llauth']) then
			req.llauth = req.body['llauth']
		end
	end
	
	return req
end


-- @brief 接收到文本数据处理
-- @param [in]	id[number]			连接id
-- @param [in]	protocol[number]	协议类型
-- @param [in]	body[string]		文本数据
-- @return 0.保存连接; 1.断开连接
local on_recv = function (id, protocol, body)
	nsm_ser.b_res = false -- 请求过来, 标记必须回复
	local ret = 1	

	if np_id.NSPP == protocol then
		
		local req = parser_req(id, body)	-- 解析请求数据
		req.local_unix = false
		
		local res = {}
		
		ret = json_request(req, res)	-- 请求处理
		
		send(id, res)					-- 回复对端
	elseif np_id.NSPP_LOCAL == protocol then
		local req = parser_req(id, body)	-- 解析请求数据
		req.local_unix = true
		
		local res = {}
		
		ret = json_request(req, res)	-- 请求处理
		
		send(id, res)					-- 回复对端
	elseif np_id.RTSP == protocol then
		
		local res = ''
		ret, res = rtsp_ser.sdp_request(id, body)
		
		send(id, res)					-- 回复对端
	elseif np_id.NSPP_HTTP == protocol then
		ret = nspp_http_ser.request(id, body)
		nsm_ser.b_res = true
	elseif np_id.HTTP_FLV == protocol then
		ret = flv_http_ser.request(id, body)
		nsm_ser.b_res = true
	end

	if 0 == ret then
		assert(true == nsm_ser.b_res)	-- 检查每条请求是否响应
	end
	
	return ret -- 返回0 表示保持连接, 非0表示断开连接
end


-- @brief 连接断开处理
-- @param [in]	id[number]			连接id
-- @param [in]	protocol[number]	协议类型
-- @return 0
local on_disconnect = function (id, protocol)
	if np_id.RTSP == protocol then
		rtsp_ser.on_disconnect(id)
	elseif np_id.NSPP_HTTP == protocol then
		nspp_http_ser.on_disconnect(id)
	elseif np_id.HTTP_FLV == protocol then
		flv_http_ser.on_disconnect(id)
	end
	
	return 0
end


-- @brief 初始化设置
-- @return 无
nsm_ser.setup = function ()
	
	l_nsm.set_recv(on_recv)					-- 注册数据接收函数
	l_nsm.set_disconnect(on_disconnect)		-- 注册当连接断开的回调处理
end

return nsm_ser
