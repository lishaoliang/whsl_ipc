--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- brief  http ser 模块
-- @author 李绍良
--]]
local string = require("string")
local cjson = require("cjson")
local l_sys = require("l_sys")
local l_http = require("l_http")
local l_nsm = require("l_nsm")


local util = require("base.util")
local h_code = require("ipc.http.h_code")
local http_file = require("ipc.http.http_file")

local hnsm_parser = require("ipc.nsm.hnsm_parser")
local hnsm_pack = require("ipc.nsm.hnsm_pack")
local json_request = require("ipc.nsm.json_request")

local http_ser = {
	s_http = nil,
	b_res = true
}

local send = function (id, head, body)
	http_ser.s_http:send(id, head, body)
	http_ser.b_res = true
end

local send_err = function (id, code)
	if h_code.HTTP_403 == code then
		send(id, h_code.HTTP_403_HEAD, '')
	else
		send(id, h_code.HTTP_404_HEAD, h_code.HTTP_404_BODY)
	end	
end

-- brief 解析http的body部分
-- req [table]   请求对象
-- txt [string]  HTTP的body数据
local parser_body = function (req, txt)
	if 0 == string.len(txt) then
		return false
	end
	
	-- 将body 数据转换为 lua 的table
	local ret, obj = pcall(cjson.decode, txt)
	--print(ret, obj)

	if ret and 'table' == type(obj) then
		req.body = obj
	end
	
	-- 检查body 有无 llssid, llauth, 有则更新到 req.ck, 以确保权限检查ok
	if nil ~= req.body then
		if 'string' == type(req.body['llssid']) then
			req['llssid'] = req.body['llssid']		-- 提取llssid
		end
		
		if 'string' == type(req.body['llauth']) then
			req['llauth'] = req.body['llauth']		-- 提取llauth
		end
		
		if 'string' == type(req.body['cmd']) then
			req['cmd'] = req.body['cmd']			-- 提取cmd
		end
	end	
end

-- brief 解析http的url部分
-- req [table]   请求对象
-- url [string]  url
local parser_url = function (req, url)
	-- url 规则 /luajson?cmd=support&llssid=123456&llauth=123456
	-- 仅测试使用
	-- ','属于url保留字符并不十分规范
	
	for k, v in string.gmatch(url, '([%w_,]+)=([%w_,]+)') do
		local low_k = string.lower(k)	
		if 'llssid' == low_k and '' == req['llssid'] then
			req['llssid'] = v
		elseif 'llauth' == low_k and '' == req['llauth'] then
			req['llauth'] = v
		elseif 'cmd' == low_k then
			req['cmd'] = v
		end	
	end
end

local on_http_frame = function (id, req, url)
	local chnn = 0
	local idx = 65	-- 图片流2

	-- 从请求路径中, 解析参数
	local path, param = string.match(url, '([^?]*)(.*)')
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
	
	-- 暂时仅支持图片流
	if 65 ~= idx then
		idx = 65
	end
	
	local buf, size, frame_type = l_nsm.get_frame(chnn, idx)
	
	if nil ~= buf then
		local t = {}
		table.insert(t, 'HTTP/1.1 200 OK\r\n')
		table.insert(t, string.format('Server: %s\r\n', h_code.HTTP_SERVER))
		table.insert(t, 'Connection: close\r\n')
		table.insert(t, string.format('Content-Type: %s\r\n', 'image/jpeg'))	-- text/html
		table.insert(t, string.format('Content-Length: %d\r\n', size))
		table.insert(t, '\r\n')
		local head = table.concat(t)
		
		send(id, head, buf)
		
		l_sys.free(buf)
		return h_code.HTTP_200
	end	
	
	return h_code.HTTP_404
end


local on_http_file = function (id, req, url)
	-- GET下载, 下载'/opt/l_lua/www'目录文件
	local ret, head, body = http_file.request(req, url)
	
	if h_code.HTTP_200 == ret then
		send(id, head, body)
		
		if 'userdata' == type(body) then
			l_sys.free(body)	-- 释放二进制数据
		end
		
		return h_code.HTTP_200
	end
	
	return h_code.HTTP_404
end


-- brief 接收从C部分过来的HTTP请求
-- id [number]   连接id
-- head [string] HTTP头
-- body [string] HTTP的Body区域
-- return 0
http_ser.on_recv = function (id, head, body)
	http_ser.b_res = false -- 请求过来, 标记必须回复
	local code = h_code.HTTP_404
	
	local req = hnsm_parser(id, head)
	local res = {}
	
	local url = string.lower(req.url)
	parser_url(req, url)	
	
	-- lua 从1开始计数, 请求json协议目录, 则为处理json消息
	if 1 == string.find(url, '/luajson') then
		parser_body(req, body)	
		json_request(req, res)		
		
		local body_txt = cjson.encode(res)
		local head_txt = hnsm_pack.pack_200(req, string.len(body_txt))
		
		send(id, head_txt, body_txt)
		
		code = h_code.HTTP_200
	--elseif 1 == string.find(url, '/luaframe') then
	--	
	--	-- 请求实时帧, BUG.短连接请求多,数据发送不及时时, 会将内存耗尽 
	--	--code = on_http_frame(id, req, url)
	--	
	elseif 'get' == req['method'] then
		if '/' == url or '' == url then
			url = '/index.html'	-- 重定位到主页
		end
		
		-- 其他'get'请求, 则认为从服务端下载文件
		code = on_http_file(id, req, url)	-- GET下载, 下载'/opt/l_lua/www'目录文件
	end
	
	if h_code.HTTP_200 ~= code then
		send_err(id, code)
	end
	
	assert(true == http_ser.b_res) -- 检查每条请求是否响应
	return 0
end


http_ser.setup = function ()
	
	-- 初始化	
	http_ser.s_http = l_http.create_s_http()
	
	-- 设置http服务端接收函数
	l_http.set_s_recv(http_ser.on_recv)
end

return http_ser
