--[[
-- Copyright(c) 2019, 武汉舜立软件, All Rights Reserved
-- Created: 2019/11/25
--
-- @file  rtsp_sdp1.lua
-- @brief RTSP server sdp协议解析
-- @author 李绍良
--]]
local string = require("string")
local table = require("table")
local l_sys = require("l_sys")


local rtsp_sdp1 = {}


local server = 'LuaRtsp (v2019.11.25)'


rtsp_sdp1.OPTIONS = 'OPTIONS'
rtsp_sdp1.DESCRIBE = 'DESCRIBE'
rtsp_sdp1.SETUP = 'SETUP'
rtsp_sdp1.TEARDOWN = 'TEARDOWN'
rtsp_sdp1.PLAY = 'PLAY'
rtsp_sdp1.PAUSE = 'PAUSE'
rtsp_sdp1.GET_PARAMETER = 'GET_PARAMETER'


-- 去除字符串首尾空行
local trim = function (s)
	return (string.gsub(s, '^%s*(.-)%s*$', '%1'))
end

local sdp_cseq = function (sdp, v)
	sdp['cseq'] = tonumber(v)
end

local sdp_transport = function (sdp, v)
	sdp['transport'] = v
end

local sdp_session = function (sdp, v)
	sdp['session'] = v
end

local sdp_range = function (sdp, v)
	sdp['range'] = v
end

local sdp_map = {
	cseq = sdp_cseq,
	transport = sdp_transport,
	session = sdp_session,
	range = sdp_range
}

-- 解析冒号格则: "*: *"
local parser_colon = function (sdp, line)
	local k, v = string.match(line, '([^:]+):(.*)') -- 匹配参数
	if nil ~= k and nil ~= v then
		k = trim(k)
		v = trim(v)
		
		local low_k = string.lower(k)
		
		local cb = sdp_map[low_k]
		if nil ~= cb then
			cb(sdp, v)
		end
		
		return true
	end
	
	return false
end

-- 解析空格规则: "* * *" 
local parser_space = function (sdp, line)
	local method, url, protocol = string.match(line, '([^ ]+) +([^ ]+) +([^ ]+)') -- 匹配请求头
	if nil ~= method and nil ~= url and nil ~= protocol then
		method = string.upper(trim(method))
		protocol = string.lower(trim(protocol))
		url = trim(url)
		
		if string.find(protocol, 'rtsp') then
			sdp['method'] = method
			sdp['protocol'] = protocol
			--sdp['url'] = url			
			sdp['url'] = (string.gsub(url, '^%s*(.-)[/\\]*$', '%1'))	-- 防止末尾带'/' '\'
		end
		
		--print(method, url, protocol)
		return true
	end

	return false
end

rtsp_sdp1.parser = function (txt)
	local sdp = {}
	
	-- 切割
	local head, body = string.match(txt, '(.*)\r\n\r\n(.*)')
	
	-- 提取请求头信息
	if nil ~= head then
		local frist = true
		for line in string.gmatch(head, '[^\r\n]+[\r\n]*') do
			if frist then
				parser_space(sdp, line)
			else
				parser_colon(sdp, line)
			end
			frist = false
		end
	end

	return sdp
end


rtsp_sdp1.new_sdp = function ()
	
	local sdp = {
		--- 状态参数
		chnn = 0,			-- 通道
		idx = 1,			-- 流序号
		video = false,		-- 是否启用视频
		audio = false,		-- 是否启用音频
		playing = false,	-- 是否正在播放
		
		------------------解析数据
		method = '',
		protocol = '',
		url = 'rtsp://127.0.0.1:80/chnn0/idx1',
		
		-- SETUP url = content_base + ['/'] + 'video'
		content_base = 'rtsp://127.0.0.1:80/chnn0/idx1',
		
		cseq = 0,
		transport = '',
		session = l_sys.rand_char(12),
		range = ''
	}

	return sdp
end

local parser_url_params = function (sdp)
	local url = sdp['url']

	-- rtsp://127.0.0.1:80/chnn0/idx1
	local proto, host, path = string.match(url, '([%w]+)://([^/]*)(.*)')
	
	-- 从请求路径中, 解析参数
	if nil ~= path then
		for line in string.gmatch(path, '([%w]+)') do
			if nil ~= line then
				local k, v = string.match(line, '([%a]+)([%d]+)')
				if nil ~= k and nil ~= v then
					k = string.lower(trim(k))
					v = trim(v)
					
					if 'chnn' == k then
						sdp['chnn'] = tonumber(v)
					elseif 'idx' == k then
						sdp['idx'] = tonumber(v)
					end
				end
			end
		end
	end
	
	-- 限制流序号范围
	if 1 < sdp['idx'] then
		sdp['idx'] = 1
	end
end

rtsp_sdp1.copy_parser_sdp = function (dst, src)
	local method = src['method']
	
	if rtsp_sdp1.OPTIONS == method then
		dst['url'] = src['url']
		dst['content_base'] = src['url']
		
		parser_url_params(dst)
	elseif rtsp_sdp1.DESCRIBE == method then
		dst['url'] = src['url']
		dst['content_base'] = src['url']
		
		parser_url_params(dst)
	elseif rtsp_sdp1.SETUP == method then
		
		
	elseif rtsp_sdp1.PLAY == method then
		
	elseif rtsp_sdp1.TEARDOWN == method then
		
	elseif rtsp_sdp1.GET_PARAMETER == method then
		
	elseif rtsp_sdp1.PAUSE == method then
		
	end
end

rtsp_sdp1.pack_options = function (sdp, cseq)
	local h = {}
	table.insert(h, 'RTSP/1.0 200 OK\r\n')
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, 'Content-Length: 0\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, 'Public: OPTIONS,DESCRIBE,SETUP,TEARDOWN,PLAY,PAUSE,GET_PARAMETER\r\n')
	table.insert(h, '\r\n')
	
	return table.concat(h)
end

rtsp_sdp1.pack_describe = function (sdp, cseq, sps, pps)
	local video_url = table.concat{sdp['content_base'], '/video'}	-- 'rtsp://127.0.0.1:80/chnn=0&id=0/video'

	local b = {}
	table.insert(b, 'v=0\r\n')
	table.insert(b, 'a=range:npt=0-\r\n')
	
	-- video
	table.insert(b, 'm=video 0 RTP/AVP 96\r\n')
	table.insert(b, 'a=rtpmap:96 H264/90000\r\n')
	
	-- 'a=fmtp:96 packetization-mode=1;sprop-parameter-sets=Z0IAKpY1QPAET8s3AQEBAg==,aM48gA==\r\n'
	if 0 < string.len(sps) and 0 < string.len(pps) then
		table.insert(b, string.format('a=fmtp:96 packetization-mode=1;sprop-parameter-sets=%s,%s\r\n', sps, pps))
	else
		table.insert(b, 'a=fmtp:96 packetization-mode=1\r\n')
	end	

	table.insert(b, string.format('a=control:%s\r\n', video_url))
	
	local body = table.concat(b)

	local h = {}
	table.insert(h, 'RTSP/1.0 200 OK\r\n')
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, 'Content-Type: application/sdp\r\n')
	table.insert(h, string.format('Content-Base: %s\r\n', sdp['content_base']))
	table.insert(h, string.format('Content-Length: %d\r\n', string.len(body)))
	table.insert(h, 'Cache-Control: no-cache\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, '\r\n')
	
	local head = table.concat(h)
	
	return table.concat({head, body})
end

rtsp_sdp1.pack_setup = function (sdp, cseq)

	local h = {}
	table.insert(h, 'RTSP/1.0 200 OK\r\n')
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, 'Transport: RTP/AVP/TCP;interleaved=0-1;unicast\r\n')
	table.insert(h, string.format('Session: %s;timeout=60\r\n', sdp['session']))
	table.insert(h, 'Content-Length: 0\r\n')
	table.insert(h, 'Cache-Control: no-cache\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, '\r\n')
	
	return table.concat(h)
end

rtsp_sdp1.pack_play = function (sdp, cseq)
	
	local h = {}
	table.insert(h, 'RTSP/1.0 200 OK\r\n')
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, 'Range: npt=0.000-\r\n')
	table.insert(h, string.format('Session: %s;timeout=60\r\n', sdp['session']))
	table.insert(h, 'Content-Length: 0\r\n')
	table.insert(h, 'Cache-Control: no-cache\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, '\r\n')
	
	return table.concat(h)
end

rtsp_sdp1.pack_teardown = function (sdp, cseq)
	local h = {}
	table.insert(h, 'RTSP/1.0 200 OK\r\n')
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, string.format('Session: %s\r\n', sdp['session']))
	table.insert(h, 'Content-Length: 0\r\n')
	table.insert(h, 'Cache-Control: no-cache\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, '\r\n')
	
	return table.concat(h)
end

rtsp_sdp1.pack_pause = function (sdp, cseq)
	local h = {}
	table.insert(h, 'RTSP/1.0 200 OK\r\n')
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, string.format('Session: %s\r\n', sdp['session']))
	table.insert(h, 'Content-Length: 0\r\n')
	table.insert(h, 'Cache-Control: no-cache\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, '\r\n')
	
	return table.concat(h)
end

rtsp_sdp1.pack_get_parameter = function (sdp, cseq)
	local h = {}
	table.insert(h, 'RTSP/1.0 200 OK\r\n')
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, string.format('Session: %s\r\n', sdp['session']))
	table.insert(h, 'Content-Length: 0\r\n')
	table.insert(h, 'Cache-Control: no-cache\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, '\r\n')
	
	return table.concat(h)
end

rtsp_sdp1.pack_error = function (sdp, cseq, code)
	-- 461 客户端协议错误
	
	local h = {}
	table.insert(h, string.format('RTSP/1.0 %d Client error\r\n', code))
	table.insert(h, string.format('Server: %s\r\n', server))
	table.insert(h, 'Content-Length: 0\r\n')
	table.insert(h, 'Cache-Control: no-cache\r\n')
	table.insert(h, string.format('Cseq: %d\r\n', cseq))
	table.insert(h, '\r\n')
	
	return table.concat(h)
end

return rtsp_sdp1
