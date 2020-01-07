--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/15
--
-- @file    hnsm_parser.lua
-- @brief   解析http请求头部
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/15 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")

-- 去除字符串首尾空行
local trim = function (s)
	return (string.gsub(s, '^%s*(.-)%s*$', '%1'))
end

local parser_k_v = function (req, k, v)
	local low_k = string.lower(k)
	if 'host' == low_k then
		req.host = v
	elseif 'cookie' == low_k  then
		req.cookie = v
	end	
end

-- brief 在 req 中解析 我们关心的 llssid 和 llauth
-- 仅检查到第一次碰到的, 重复碰到 k, v 丢弃
local parser_cookie = function (req)	
	for k, v in string.gmatch(req.cookie, '(%w+)=(%w+)') do
		local low_k = string.lower(k)	
		if 'llssid' == low_k and '' == req['llssid'] then
			req['llssid'] = v
		elseif 'llauth' == low_k and '' == req['llauth'] then
			req['llauth'] = v
		end	
	end
end

hnsm_parser = function (id, head)
	local req = {
		method = '',	-- 不区分大小写
		url = '',		-- 不区分大小写
		host = '',
		cookie = '',
		
		id = id,
		cmd = '',		-- 请求的动作集合, 从请求头,body.cmd域提取
		llssid = '',	-- 客户端 llssid
		llauth = '',	-- 客户端授权码 llauth
		
		local_unix = false, -- 是否为本地请求
		body = {}		-- 最后如果有附加 json 数据, 则从中解析
	}

	if nil == head then
		return req
	end

	--print('----------------------------')
	--print(head)
	--print('----------------------------')

	-- 提取请求头信息
	local first = true
	for line in string.gmatch(head, '[^\r\n]+[\r\n]*') do
		--print(line)
		if first then
			local method, url, ver = string.match(line, '([^ ]+) +([^ ]+) +([^ ]+)') -- 匹配请求头
			--print(method, url, ver)
			if nil ~= method and nil ~= url and nil ~= ver then
				req.method = string.lower(method)
				req.url = string.lower(url)
			end
			
			first = false
		else
			local k, v = string.match(line, '([^:]+):(.*)') -- 匹配参数
			if nil ~= k and nil ~= v then
				k = trim(k)
				v = trim(v)
				--print(k, v)
				parser_k_v(req, k, v)
			end
		end
	end
	
	-- 将我们关心的 cookie 解析到 req.ck.llssid, req.ck.llauth
	parser_cookie(req)
	
	return req
end

-- test

--local t_req_str = "GET / HTTP/1.1\r\n\
--Host: 127.0.0.1:3456\r\n\
--User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:63.0) Gecko/20100101 Firefox/63.0\r\n\
--Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n\
--Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2\r\n\
--Accept-Encoding: gzip, deflate\r\n\
--Connection: keep-alive\r\n\
--Cookie: llssid=123456; llauth=789456\r\n
--Upgrade-Insecure-Requests: 1\r\n\
--\r\n"

--hnsm_parser(t_req_str)

return hnsm_parser
