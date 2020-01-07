--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief  net proto id 网络协议id值
-- @author 李绍良
--]]


local np_id = {}


-- 主协议
np_id.NULL = 0				-- 无效
np_id.UNKNOWN = 1			-- 未知协议

np_id.HTTP = 2				-- HTTP协议
np_id.RTSP = 3				-- RTSP协议
np_id.WS = 4				-- websocket协议
np_id.HTTP_FLV = 5			-- HTTP-FLV协议


np_id.NSPP = 20				-- nspp私有协议
np_id.NSPP_MULTICAST = 21	-- nspp私有协议组播
np_id.NSPP_BROADCAST = 22	-- nspp私有协议广播
np_id.NSPP_HTTP = 23		-- nspp私有协议,通过HTTP长连接传输媒体控制


np_id.NSPP_LOCAL = 820		-- 本地;nspp[unix,TCP]: v1私有协议


-- 子协议
np_id.MEDIA = 0				-- 媒体流,文本通信子协议
np_id.UPGRADE = 1			-- (客户端向设备服务端请求)升级子协议
np_id.FTP = 2				-- 文件传输子协议



return np_id
