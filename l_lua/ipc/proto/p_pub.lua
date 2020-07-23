--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_pub 协议解析
-- @author  李绍良
--]]
local string = require("string")
local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")

local p_pub = {}

-- brief hello心跳
-- @param [in]		req[table]	请求
-- res [table]	回复对象
-- cmd [string] 符合字符集[azAZ09_]规则的 单个单词
p_pub.on_hello = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK,
		msg = 'welcome!'
	}
end

-- brief 请求加密秘钥
-- res [table]	回复对象
-- cmd [string] 符合字符集[azAZ09_]规则的 单个单词
p_pub.on_encrypt = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK,
		type = 'none',
		key = '123456'
	}
end

return p_pub
