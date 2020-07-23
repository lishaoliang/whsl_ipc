--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_user 协议解析
-- @author  李绍良
--]]
local string = require("string")
local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")

local p_user = {}


-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)
p_user.on_user_add = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)
p_user.on_user_remove = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end

-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)
p_user.on_user_modify = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end

-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)
p_user.on_user_all = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end

-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)
p_user.on_user_modify_pwd = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end

-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)
p_user.on_user_info = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)
p_user.on_user_online = function (req, res, cmd)
	
	res[cmd] = {
		code = np_err.OK
	}
end

return p_user
