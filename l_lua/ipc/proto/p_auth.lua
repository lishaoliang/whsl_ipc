--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_auth 权限部分协议
-- @author  李绍良
--]]
local string = require("string")
local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")

local user = require("ipc.auth.user")

local p_auth = {}

-- brief 登入
-- res [table]	回复对象
-- cmd [string] 符合字符集[azAZ09_]规则的 单个单词
p_auth.on_login = function (req, res, cmd)

	local ret, llssid, llauth= user.login(nil)

	res[cmd] = {
		code = ret,
		llssid = llssid,
		llauth = llauth
	}
end

-- brief 登出
-- res [table]	回复对象
-- cmd [string] 符合字符集[azAZ09_]规则的 单个单词
p_auth.on_logout = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end

return p_auth
