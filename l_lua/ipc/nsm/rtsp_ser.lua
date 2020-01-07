--[[
-- Copyright(c) 2019, 武汉舜立软件, All Rights Reserved
-- Created: 2019/11/25
--
-- @file  rtsp_ser.lua
-- @brief RTSP server协议流程
-- @author 李绍良
-- @note 
--  rtsp主码流: rtsp://admin:123456@192.168.1.247:80/chnn0/idx0
--  rtsp子码流: rtsp://admin:123456@192.168.1.247:80/chnn0/idx1
--  rtsp默认子码流: rtsp://admin:123456@192.168.1.247:80
--]]

local l_nsm = require("l_nsm")
local iworker = require("ipc.iworker")
local rtsp_sdp1 = require("ipc.nsm.rtsp_sdp1")
local rtsp_status = require("ipc.nsm.rtsp_status")


local rtsp_ser = {}

local conns = {}	-- 存储连接的sdp信息

-- 去除字符串首尾空行
local trim = function (s)
	return (string.gsub(s, '^%s*(.-)%s*$', '%1'))
end

local get_conn_sdp = function (id)
	local k = tostring(id)
	local sdp = conns[k]
	if nil == sdp then
		sdp = rtsp_sdp1.new_sdp()
		conns[k] = sdp
	end
	
	return sdp
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

local open_stream = function (id, sdp)
	local chnn = sdp['chnn']
	local idx = sdp['idx']

	if sdp['video'] then
		-- 开启流
		l_nsm.open_stream(id, chnn, idx, 0)
		
		-- 通知请求关键帧
		local obj_chnn = {
			chnn = chnn,
			idx = idx
		}
		
		local str_chnn = cjson.encode(obj_chnn)
		iworker.post(iworker.lw_dev_ipc, 'request_i', '{}', str_chnn)
		
		sdp['playing'] = true
	end

	if sdp['audio'] then
		idx = idx + 0x0020	-- 音频流序号偏移
		
		-- 开启音频流
		l_nsm.open_stream(id, chnn, idx, 0)
		
		sdp['playing'] = true
	end

	return sdp['playing']
end

local close_stream = function (id, sdp)
	local chnn = sdp['chnn']
	local idx = sdp['idx']

	l_nsm.close_stream(id, chnn, idx, 0)			-- 关闭视频流
	l_nsm.close_stream(id, chnn, idx + 0x0020, 0)	-- 关闭音频流

	sdp['playing'] = false
end

local on_setup = function (sdp, sdp1, cseq)
	local transport = sdp1['transport']
	if nil ~= transport then
		transport = string.lower(transport)
		
		-- 'RTP/AVP/TCP', 'RTP/AVP'
		if not string.find(transport, 'tcp') then			
			-- 不支持UDP传输协议
			return 0, rtsp_sdp1.pack_error(sdp, cseq, rtsp_status.TRANSPORT)
		end
	end
	
	local url = sdp1['url']
	if nil ~= url then
		url = string.lower(url)
		
		if string.find(url, 'video') then
			sdp['video'] = true
			return 0, rtsp_sdp1.pack_setup(sdp, cseq)
		elseif string.find(url, 'audio') then
			sdp['audio'] = true
			return 0, rtsp_sdp1.pack_setup(sdp, cseq)
		end
	end
	
	return 0, rtsp_sdp1.pack_error(sdp, cseq, rtsp_status.NOT_FOUND)
end


-- @brief rtsp/sdp协议请求流程
-- @param [in]	id[number]	连接id
-- @param [in]	txt[string]	rtsp请求的sdp文本
-- @return [number]		错误码
--			[string]	回复给客户端的sdp文本
rtsp_ser.sdp_request = function (id, txt)
	local ret = 0
	local res = ''
	
	local sdp = get_conn_sdp(id)
	
	local sdp1 = rtsp_sdp1.parser(txt)
	local method = sdp1['method']
	local cseq = sdp1['cseq']
	
	-- 拷贝参数/并解析参数
	rtsp_sdp1.copy_parser_sdp(sdp, sdp1)


	if rtsp_sdp1.OPTIONS == method then
		res = rtsp_sdp1.pack_options(sdp, cseq)
		
	elseif rtsp_sdp1.DESCRIBE == method then
		local sps, pps = l_nsm.get_sps_pps(sdp['chnn'], sdp['idx'])		
		res = rtsp_sdp1.pack_describe(sdp, cseq, sps, pps)
		
	elseif rtsp_sdp1.SETUP == method then
		ret, res = on_setup(sdp, sdp1, cseq)
		
	elseif rtsp_sdp1.PLAY == method then
		open_stream(id, sdp)
		
		res = rtsp_sdp1.pack_play(sdp, cseq)
		
	elseif rtsp_sdp1.TEARDOWN == method then
		-- 关闭流, 由客户端主动断开
		close_stream(id, sdp)
		
		res = rtsp_sdp1.pack_teardown(sdp, cseq)
		
	elseif rtsp_sdp1.GET_PARAMETER == method then
		res = rtsp_sdp1.pack_get_parameter(sdp, cseq)
		
	elseif rtsp_sdp1.PAUSE == method then
		close_stream(id, sdp)
		
		res = rtsp_sdp1.pack_pause(sdp, cseq)
		
	else
		res = rtsp_sdp1.pack_error(sdp, cseq, rtsp_status.METHOD)
		
	end
	
	--print('++++++++++++++++++++')
	--print(txt)
	--print('--------------------')
	--print(res)
	--print('++++++++++++++++++++')
	
	return ret, res
end


-- @brief rtsp连接断开处理
-- @param [in]	id[number]	连接id
-- @return 无
rtsp_ser.on_disconnect = function (id)
	remove_conn(id)
end

return rtsp_ser
