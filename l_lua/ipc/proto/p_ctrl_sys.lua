--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_ctrl_sys 系统控制协议
-- @author  李绍良
--]]
local string = require("string")
local l_ctrl_sys = require("l_ctrl_sys")

local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")


local p_ctrl_sys = {}


-- @brief 测试样板
-- @param [in]  	req[table]	请求
-- @param [out]		res[table]	回复对象
-- @param [in]		cmd[string]	符合字符集[azAZ09_]规则的 单个单词
-- @return 无返回值
p_ctrl_sys.on_test = function (req, res, cmd)

	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 重启
-- @param [in]  	req[table]	请求
-- @param [out]		res[table]	回复对象
-- @param [in]		cmd[string]	符合字符集[azAZ09_]规则的 单个单词
-- @return 无返回值
p_ctrl_sys.on_ctrl_reboot = function (req, res, cmd)
	
	--l_ctrl_sys.reboot()

	res[cmd] = {
		code = np_err.OK
	}
end

return p_ctrl_sys
