--[[
-- Copyright(c) 2020, 武汉舜立软件, All Rights Reserved
-- Created: 2020/7/29
--
-- @file  flv_ws_ser.lua
-- @brief WS-FLV server协议流程
-- @author 李绍良
-- @note 
--
-- eg. HTTP GET
--  GET /luawsflv/chnn0/idx0 HTTP/1.1
--  Host: 127.0.0.1:3456
--  User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0
--  Accept: */*
--  Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
--  Accept-Encoding: gzip, deflate
--  Sec-WebSocket-Version: 13
--  Origin: http://127.0.0.1:3456
--  Sec-WebSocket-Extensions: permessage-deflate
--  Sec-WebSocket-Key: fcoOCnZknPpAcsTt5Ptf0w==
--  Connection: keep-alive, Upgrade
--  Pragma: no-cache
--  Cache-Control: no-cache
--  Upgrade: websocket
--	
--  HTTP/1.1 101 Switching Protocols
--  Server: Tengine
--  Upgrade: websocket
--  Connection: Upgrade
--  Sec-WebSocket-Version: 13
--  Sec-WebSocket-Accept: Fj7XdyEHoofF8bmO5PD4sTQW+Z4=
--  Content-Length: 0
--  Access-Control-Allow-Origin: *
--]]
local string = require("string")
local table = require("table")
local cjson = require("cjson")
local l_crypto = require("l_crypto")
local l_nsm = require("l_nsm")

local util = require("base.util")
local h_code = require("ipc.http.h_code")
local hnsm_parser = require("ipc.nsm.hnsm_parser")
local iworker = require("ipc.iworker")


local flv_ws_ser = {}

local conns = {}	-- 存储的连接

local get_conn = function (id)
	local k = tostring(id)
	local conn = conns[k]
	if nil == conn then
		conn = {
			id = id,
			first = true
		}
		conns[k] = conn
	end
	
	return conn
end

local remove_conn = function (id)
	local k = tostring(id)
	local t = {}
	
	for k1, v1 in pairs(conns) do
		if k ~= k1 then
			t[k1] = v1
		end
	end
	
	conns = t
end


local pack_101 = function (version, accept_key)
	local t = {}
	
	table.insert(t, 'HTTP/1.1 101 Switching Protocols\r\n')
	table.insert(t, string.format('Server: %s\r\n', h_code.HTTP_SERVER))
	table.insert(t, 'Connection: Upgrade\r\n')	-- 升级连接
	table.insert(t, 'Upgrade: websocket\r\n')				-- 升级连接
	table.insert(t, string.format('Sec-WebSocket-Version: %s\r\n', version))
	table.insert(t, string.format('Sec-WebSocket-Accept: %s\r\n', accept_key))
	table.insert(t, 'Content-Length: 0\r\n')				--
	table.insert(t, 'Access-Control-Allow-Origin: *\r\n')	-- 许可跨域请求
	table.insert(t, '\r\n')
	
	return table.concat(t)
end

local send = function (id, msg)
	l_nsm.send(id, msg)
end

local get_ws_key = function(head)
	local ws_key = ''
	local ws_ver = '13'
	
	-- 提取请求头信息
	local first = true
	for line in string.gmatch(head, '[^\r\n]+[\r\n]*') do
		--print(line)
		if first then
			first = false
		else
			local k, v = string.match(line, '([^:]+):(.*)') -- 匹配参数
			if nil ~= k and nil ~= v then
				k = util.trim(k)
				v = util.trim(v)
				
				local low_k = string.lower(k)
				if 'sec-websocket-key' == low_k then
					ws_key = v
				elseif 'sec-websocket-version' == low_k then
					ws_ver = v
				end
			end
		end
	end
	
	return ws_key, ws_ver
end

-- @brief nspp-http协议请求流程
-- @param [in]	id[number]	连接id
-- @param [in]	txt[string]	请求的http文本
-- @return [number]		错误码
--			[string]	回复给客户端的http-chunked数据
flv_ws_ser.request = function (id, txt)
	--print('ws-flv:', id, txt)
	
	local ret = 0
	local ret_txt = ''
	
	local conn = get_conn(id)

	-- 切割请求头和请求体
	local head, body = string.match(txt, '(.*)\r\n\r\n(.*)')
	local ws_key, ws_ver = get_ws_key(head)	
	if '' == ws_key then
		return 1 -- 断开连接
	end
	
	local req = hnsm_parser(id, head)
	local path = string.lower(req.url)

	local chnn = 0
	local idx = 1

	-- 从请求路径中, 解析出通道/流id
	if nil ~= path then
		for line in string.gmatch(path, '([%w]+)') do
			if nil ~= line then
				local k, v = string.match(line, '([%a]+)([%d]+)')
				if nil ~= k and nil ~= v then
					k = string.lower(util.trim(k))
					v = util.trim(v)
					
					if 'chnn' == k then
						chnn = tonumber(v)
					elseif 'idx' == k then
						idx = tonumber(v)
					end
				end
			end
		end
	end

	-- 只支持0通道
	if 0 ~= chnn then
		chnn = 0
	end
	
	-- 只支持主子码流
	if 0 ~= idx and 1 ~= idx then
		idx = 1
	end
	
	if conn['first'] then
		conn['first'] = false
		
		local head_txt = pack_101(ws_ver, l_crypto.ws_encode(ws_key))
		send(id, head_txt)
		
		local code = l_nsm.open_stream(id, chnn, idx, 0)		
		if 0 == code then	
			local obj_chnn = {
				chnn = chnn,
				idx = idx
			}
			
			local str_chnn = cjson.encode(obj_chnn)
			iworker.post(iworker.lw_dev_ipc, 'request_i', '{}', str_chnn)
		end
	end	
	
	return 0
end


-- @brief rtsp连接断开处理
-- @param [in]	id[number]	连接id
-- @return 无
flv_ws_ser.on_disconnect = function (id)
	remove_conn(id)
end

return flv_ws_ser
