--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_cfg 配置操作部分协议
-- @author  李绍良
--]]
local string = require("string")
local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")

local p_cfg = {}


-- @brief 导出配置
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_cfg.on_cfg_export = function (req, res, cmd)

	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 导入配置
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_cfg.on_cfg_inport = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 简易回复配置
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_cfg.on_cfg_default = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end

-- @brief 简易大部分配置
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_cfg.on_cfg_default_all = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end


return p_cfg
