--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief  net proto error 网络协议错误码范围[0x1000(4096) ~ 0x7FFF(32767)]
-- @author 李绍良
--]]

local np_err = {}

np_err.OK = 0
np_err.CONNECT = 3584	-- 新连接加入


np_err.B = 4096		-- 错误码开始
np_err.E = 32767	-- 错误码结束

np_err.UNSUPPORT = np_err.B + 1	-- 不支持的协议命令
np_err.NOTFOUND  = np_err.B + 2 -- 未找到
np_err.PARAM	 = np_err.B + 3	-- 参数错误
np_err.SAVE		 = np_err.B + 4	-- 保存数据错误


return np_err
