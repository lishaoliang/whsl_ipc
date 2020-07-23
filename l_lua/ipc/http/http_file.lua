--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- brief  http file HTTP文件下载
-- @author 李绍良
--]]
local string = require("string")
local table = require("table")
local l_sys = require("l_sys")
local l_file = require("l_file")
local h_code = require("ipc.http.h_code")
local util = require("base.util")
local http_mime = require("ipc.http.http_mime")


local http_file = {}


-- http文件下载根目录
local root_path = '/opt/l_lua/www'
if l_sys.simulator then
	root_path = './www'
end


local pack_200 = function (body_len, mime, gz)
	local t = {}
	
	table.insert(t, 'HTTP/1.1 200 OK\r\n')
	table.insert(t, string.format('Server: %s\r\n', h_code.HTTP_SERVER))
	table.insert(t, 'Connection: close\r\n')							-- 短连接关闭
	table.insert(t, string.format('Content-Type: %s\r\n', mime))		-- 数据类型
	table.insert(t, string.format('Content-Length: %d\r\n', body_len))	-- 数据长度

	if gz then
		table.insert(t, 'Content-Encoding: gzip\r\n')
	end

	if l_sys.simulator then
		table.insert(t, 'Cache-Control: max-age=0\r\n')					-- 缓存时间(秒)
	else
		table.insert(t, 'Cache-Control: max-age=3600\r\n')				-- 缓存时间(秒)
	end
	
	table.insert(t, 'Access-Control-Allow-Origin: *\r\n')				-- 许可跨域请求
	table.insert(t, '\r\n')
	
	return table.concat(t)
end

local get_mime = function (filename)
	local ext = string.match(filename, '[^.]*$')
	
	if nil ~= ext then
		ext = util.trim(ext)
		ext = string.lower(ext)
		
		local mime = http_mime[ext]
		if nil ~= mime then
			return mime
		end
	end
	
	return 'application/octet-stream' -- 二进制流,未知类型
end

local get_filter_path = function (url)
	local path = string.match(url, '^[^?]*')	-- '/index.html?cmd=hello&llssid=123456&llauth=123456'	
	if nil == path then
		return '', ''
	end
	
	-- 防止使用相对路径, 非法下载文件
	path = string.gsub(path, '~', '')			-- 将'~' 替换为 ''
	path = string.gsub(path, '\\', '/')			-- 将'\' 替换为 '/'
	path = string.gsub(path, '[.]+/', '/')		-- 将'./','../' 替换为 '/'
	path = string.gsub(path, '[/]+/', '/')		-- 将'//','///' 替换为 '/'
	
	-- 提取文件名
	local filename = string.match(path, '[^/]*$')	-- '/index.html'
	if nil == filename or 0 == string.len(filename) then
		return '', ''
	end
	
	return root_path .. path, get_mime(filename)
end

-- 读取文件
local read_file = function (path)
	local buf = nil
	local size = 0
	
	local file = l_file.open(path, 'rb')	-- 读取二进制
	if nil ~= file then
		l_file.seek(file, 0, 'seek_end')
		local filelen = l_file.tell(file)
		
		if 0 < filelen then
			l_file.seek(file, 0, 'seek_set')
			buf, size = l_file.read(file, filelen)
			assert(size == filelen)
		end
		
		l_file.close(file)
	end
	
	return buf, size
end

-- @brief HTTP短连接文件下载请求
-- @param [in]	req[table]	请求的相关数据
-- @param [in]	url[string]	请求的路径
-- @return [number]		错误码
--			[string]	http头
--			[string/userdata(lightuserdata)]	http数据体; 文本, 二进制
http_file.request = function (req, url)	
	local req_url = url
	
	-- 第一次尝试读取文件
	-- 第二次尝试读取'/not_found.html'文件
	local count = 2
	while 0 < count do
		local path, mime = get_filter_path(req_url)
		--print('http get:', path, mime)
		
		if 0 == string.len(path) then
			return h_code.HTTP_404, '', ''
		end
		
		-- 先尝试读*.gz文件, 再尝试读原文件
		local gz = true
		local path_gz = path .. '.gz'
		local buf, size = read_file(path_gz)
		if nil == buf then
			gz = false
			buf, size = read_file(path)
		end	
		
		if nil ~= buf then
			local head = pack_200(size, mime, gz)
			--l_sys.free(buf)	-- 需要等到buf使用完毕后释放
			
			return h_code.HTTP_200, head, buf
		end
		
		req_url = '/not_found.html'
		count = count - 1
	end
	
	return h_code.HTTP_404, '', ''
end

return http_file
