--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_image image基础部分协议
-- @author  李绍良
--]]
local string = require("string")
local cjson = require("cjson")
local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")


local p_osd = {}


-- @brief 设置OSD部分通用处理方法
-- @param [in]		osd_key[string]	osd部分配置key值
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
local set_osd_xxx = function (osd_key, req, res, cmd)
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
	
	local key_c = cfg.key_chnn(osd_key, chnn)	
	local ret, json, code = cfg.set(key_c, param)
	
	if ret then
		local obj_chnn = {
			chnn = chnn
		}
		
		local str_chnn = cjson.encode(obj_chnn)
		iworker.post(iworker.lw_dev_ipc, osd_key, json, str_chnn)
		
		res[cmd] = {
			code = np_err.OK
		}
	else
		res[cmd] = {
			code = code
		}
	end
end

-- @brief 设置OSD时间戳
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_osd.on_set_osd_timestamp = function (req, res, cmd)
	set_osd_xxx('osd_timestamp', req, res, cmd)
end


return p_osd
