--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_base base基础部分协议
-- @author  李绍良
--]]
local string = require("string")
local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")
local cjson = require("cjson.safe")

local p_base = {}


-- @brief 设置设备名称
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_base.on_set_name = function (req, res, cmd)
	
	local param = req.body[cmd]
	
	if 'table' ~= type(param) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return 
	end	
	
	local ret, json, code = cfg.set('name', param)
	
	if ret then
		--imsg.post(imsg.update_wifi, 'name', json, '')
		
		res[cmd] = {
			code = np_err.OK
		}
	else
		res[cmd] = {
			code = code
		}
	end
end


-- @brief 获取设备时间
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_base.on_time = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 设置设备时间
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_base.on_set_time = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 设置NTP
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_base.on_set_ntp = function (req, res, cmd)
	local param = req.body[cmd]
	
	if 'table' ~= type(param) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return 
	end	
	
	local ret, json, code = cfg.set('ntp', param)
	
	if ret then
		iworker.post(iworker.lw_dev_ipc, 'ntp', json, '{}')	
		
		res[cmd] = {
			code = np_err.OK
		}
	else
		res[cmd] = {
			code = code
		}
	end
end


-- @brief 立即进行ntp同步
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_base.on_ntp_sync = function (req, res, cmd)
	local param = req.body[cmd]
	
	if 'table' ~= type(param) and
		'string' ~= type(param['server'])
		'number' ~= type(param['port']) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return 
	end
	
	local o = {
		server = param['server'],
		port = param['port']
	}
	
	local json = cjson.encode(o)
	iworker.post(iworker.lw_dev_ipc, 'ntp_sync', json, '{}')
		
	res[cmd] = {
		code = np_err.OK
	}
end


return p_base
