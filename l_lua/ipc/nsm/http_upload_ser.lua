--[[
-- Copyright(c) 2019, 武汉舜立软件, All Rights Reserved
-- Created: 2019/12/11
--
-- @file  http_upload_ser.lua
-- @brief HTTP-UPLOAD server协议流程
-- @author 李绍良
-- @note 
--
-- eg. HTTP POST
--  POST /luaupload/upgrade undefined
--  Host: 127.0.0.1:3456
--  User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
--  Accept: */*
--  Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
--  Accept-Encoding: gzip, deflate
--  Content-Type: multipart/form-data; boundary=---------------------------47947640518269516431526544107
--  Content-Length: 1043
--  Origin: http://127.0.0.1:3456
--  Connection: keep-alive
--  Referer: http://127.0.0.1:3456/demo/upgrade.html
--  Pragma: no-cache
--  Cache-Control: no-cache
--
--  -----------------------------47947640518269516431526544107
--  Content-Disposition: form-data; name="upgrade"; filename="ipc_upgrade_file.lpk"
--  Content-Type: application/octet-stream
--  
--  ...
--  ...
--  ...
--  -----------------------------47947640518269516431526544107--
--]]
local string = require("string")
local table = require("table")
local cjson = require("cjson")

local l_nsm = require("l_nsm")

local util = require("base.util")
local h_code = require("ipc.http.h_code")
local hnsm_parser = require("ipc.nsm.hnsm_parser")
local iworker = require("ipc.iworker")


local http_upload_ser = {}

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


local pack_200 = function ()
	local t = {}
	
	table.insert(t, 'HTTP/1.1 200 OK\r\n')
	table.insert(t, string.format('Server: %s\r\n', h_code.HTTP_SERVER))
	table.insert(t, 'Connection: close\r\n')				-- 短连接关闭
	table.insert(t, 'Content-Type: video/x-flv\r\n')		-- 数据类型
	table.insert(t, 'Access-Control-Allow-Origin: *\r\n')	-- 许可跨域请求
	table.insert(t, '\r\n')
	
	return table.concat(t)
end

local send = function (id, msg)
	l_nsm.send(id, msg)
end


-- @brief nspp-http协议请求流程
-- @param [in]	id[number]	连接id
-- @param [in]	txt[string]	请求的http文本
-- @return [number]		错误码
--			[string]	回复给客户端的http-chunked数据
http_upload_ser.on_recv = function (id, txt)
	local ret = 0
	local ret_txt = ''
	
	local conn = get_conn(id)

	-- 切割请求头和请求体
	local head, body = string.match(txt, '(.*)\r\n\r\n(.*)')	
	local req = hnsm_parser(id, head)	
	local path = string.lower(req.url)
	
	
	
	if conn['first'] then
		conn['first'] = false
		
		local head_txt = pack_200()
		send(id, head_txt)
	end	
	
	return 0
end


-- @brief rtsp连接断开处理
-- @param [in]	id[number]	连接id
-- @return 无
http_upload_ser.on_disconnect = function (id)
	remove_conn(id)
end

return http_upload_ser
