--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/15
--
-- @file    hnsm_pack.lua
-- @brief   打包http回复头部
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local table = require("table")

local h_code = require("ipc.http.h_code")

local hnsm_pack = {}


--local status_200 = 'HTTP/1.1 200 OK\r\n'
--local status_401 = 'HTTP/1.1 401 Unauthorized\r\n'
--local ser = string.format('Server: %s\r\n', h_code.HTTP_SERVER)
--local ct = 'Content-Type: application/json\r\n'


hnsm_pack.pack_200 = function (req, body_len)
	--local cl = string.format('Content-Length: %d\r\n', body_len)
	
	--local llssid = ''
	--local llauth = ''
	
	--if '' == req['llssid'] then
	--	llssid = string.format('Set-Cookie: llssid=%s\r\n', '123456')
	--end
	
	--if '' == req['llauth'] then
	--	llauth = string.format('Set-Cookie: llauth=%s\r\n', '123456')
	--end
	
	--return string.format('%s%sConnection: close\r\n%s%s%s%s\r\n', status_200, ser, ct, llssid, llauth, cl)

	local t = {}
	
	table.insert(t, 'HTTP/1.1 200 OK\r\n')
	table.insert(t, string.format('Server: %s\r\n', h_code.HTTP_SERVER))
	table.insert(t, 'Connection: close\r\n')				-- 短连接关闭
	table.insert(t, 'Content-Type: application/json\r\n')	-- 数据类型

	-- cookie
	if '' == req['llssid'] then
		table.insert(t, string.format('Set-Cookie: llssid=%s\r\n', '123456'))
	end
	
	if '' == req['llauth'] then
		table.insert(t, string.format('Set-Cookie: llauth=%s\r\n', '123456'))
	end

	table.insert(t, string.format('Content-Length: %d\r\n', body_len))	-- 数据长度
	table.insert(t, 'Access-Control-Allow-Origin: *\r\n')	-- 许可跨域请求	
	table.insert(t, '\r\n')
	
	return table.concat(t)
end


hnsm_pack.pack_401 = function (req, body_len)
	--local cl = string.format('Content-Length: %d\r\n', body_len)
	
	--local llssid = string.format('Set-Cookie: llssid=%s\r\n', '123456')
	--local llauth = string.format('Set-Cookie: llauth=%s\r\n', '123456')
	
	--return string.format('%s%sConnection: close\r\n%s%s%s%s\r\n', status_401, ser, ct, llssid, llauth, cl)
	
	
	local t = {}
	
	table.insert(t, 'HTTP/1.1 401 Unauthorized\r\n')
	table.insert(t, string.format('Server: %s\r\n', h_code.HTTP_SERVER))
	table.insert(t, 'Connection: close\r\n')				-- 短连接关闭
	table.insert(t, 'Content-Type: application/json\r\n')	-- 数据类型

	-- cookie
	table.insert(t, string.format('Set-Cookie: llssid=%s\r\n', '123456'))
	table.insert(t, string.format('Set-Cookie: llauth=%s\r\n', '123456'))

	table.insert(t, string.format('Content-Length: %d\r\n', body_len))	-- 数据长度
	table.insert(t, 'Access-Control-Allow-Origin: *\r\n')	-- 许可跨域请求	
	table.insert(t, '\r\n')
	
	return table.concat(t)
end

return hnsm_pack
