--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_com 通用响应处理
-- @author  李绍良
--]]
local string = require("string")
local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")

local p_com = {}


-- @brief 通用获取配置项目, 仅获取配置数据
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_com.on_get_cfg = function (req, res, cmd)

	local v = cfg.get(cmd)
	if nil ~= v then
		res[cmd] = v
		res[cmd].code = np_err.OK
	else
		res[cmd] = {
			code = np_err.NOTFOUND
		}
	end
end


-- @brief 通用获取配置项目, 仅获取配置数据
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_com.on_get_default_cfg = function (req, res, cmd)

	-- 例如 ‘default_name’, 实际需要取 'name'
	local real_cmd = string.match(cmd, 'default_([%w_]+)')

	local v = cfg.default(real_cmd)
	if nil ~= v then
		res[cmd] = v
		res[cmd].code = np_err.OK
	else
		res[cmd] = {
			code = np_err.NOTFOUND
		}
	end
end

-- @brief 通用获取配置项目, 仅获取配置数据; 按通道/流序号方式
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_com.on_get_cfg_chnn_idx = function (req, res, cmd)

	local key = cmd
	local param = req.body[cmd]
	
	if 'table' ~= type(param) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return 
	end
	
	local chnn = param['chnn']
	local idx = param['idx']

	if 'number' ~= type(chnn) or
		'number' ~= type(idx) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return
	end
	
	local key_c_i = cfg.key_chnn_idx(key, chnn, idx)

	local v = cfg.get(key_c_i)
	if nil ~= v then
		res[cmd] = v
		res[cmd].code = np_err.OK
		res[cmd].chnn = chnn
		res[cmd].idx = idx
	else
		res[cmd] = {
			code = np_err.NOTFOUND
		}
	end
end


-- @brief 通用获取配置项目, 仅获取默认配置数据; 按通道/流序号方式
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_com.on_get_default_cfg_chnn_idx = function (req, res, cmd)
	
	-- 例如 default_stream, 实际需要取 'stream'
	local real_cmd = string.match(cmd, 'default_([%w_]+)')
	
	--
	local key = real_cmd
	local param = req.body[cmd]
	
	if 'table' ~= type(param) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return 
	end
	
	local chnn = param['chnn']
	local idx = param['idx']

	if 'number' ~= type(chnn) or
		'number' ~= type(idx) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return
	end
	
	local key_c_i = cfg.key_chnn_idx(key, chnn, idx)

	local v = cfg.default(key_c_i)
	if nil ~= v then
		res[cmd] = v
		res[cmd].code = np_err.OK
		res[cmd].chnn = chnn
		res[cmd].idx = idx
	else
		res[cmd] = {
			code = np_err.NOTFOUND
		}
	end
end


-- @brief 通用获取配置项目, 仅获取配置数据; 按通道方式
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_com.on_get_cfg_chnn = function (req, res, cmd)
	
	local key = cmd
	local param = req.body[cmd]
	
	if 'table' ~= type(param) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return 
	end
	
	local chnn = param['chnn']

	if 'number' ~= type(chnn) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return
	end
	
	local key_c = cfg.key_chnn(key, chnn)

	local v = cfg.get(key_c)
	if nil ~= v then
		res[cmd] = v
		res[cmd].code = np_err.OK
		res[cmd].chnn = chnn
	else
		res[cmd] = {
			code = np_err.NOTFOUND
		}
	end
end


-- @brief 通用获取配置项目, 仅获取默认配置数据; 按通道方式
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_com.on_get_default_cfg_chnn = function (req, res, cmd)

	-- 例如 default_image, 实际需要取 'image'
	local real_cmd = string.match(cmd, 'default_([%w_]+)')

	--
	local key = real_cmd
	local param = req.body[cmd]
	
	if 'table' ~= type(param) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return 
	end
	
	local chnn = param['chnn']

	if 'number' ~= type(chnn) then
		res[cmd] = {
			code = np_err.PARAM
		}
		return
	end
	
	local key_c = cfg.key_chnn(key, chnn)

	local v = cfg.default(key_c)
	if nil ~= v then
		res[cmd] = v
		res[cmd].code = np_err.OK
		res[cmd].chnn = chnn
	else
		res[cmd] = {
			code = np_err.NOTFOUND
		}
	end
end


return p_com
