--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief p_stream 码流协议
-- @author  李绍良
--]]
local string = require("string")
local cjson = require("cjson")
local l_nsm = require("l_nsm")

local np_err = require("base.np_err")
local cfg = require("ipc.cfg.cfg")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")


local p_stream = {}


-- @brief 测试样板
-- @param [in]  	req[table]	请求
-- @param [out]		res[table]	回复对象
-- @param [in]		cmd[string]	符合字符集[azAZ09_]规则的 单个单词
-- @return 无返回值
p_stream.on_test = function (req, res, cmd)

	res[cmd] = {
		code = np_err.OK
	}
end


-- @brief 开启码流
-- @param [in]  	req[table]	请求
-- @param [out]		res[table]	回复对象
-- @param [in]		cmd[string]	符合字符集[azAZ09_]规则的 单个单词
-- @return 无返回值
p_stream.on_open_stream = function (req, res, cmd)
	
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
	
	local md_id = 0
	--if 'number' == type(param['md_id']) then
	--	md_id = param['md_id']
	--end

	local code = l_nsm.open_stream(req.id, chnn, idx, md_id)
	
	if 0 == code then	
		local obj_chnn = {
			chnn = chnn,
			idx = idx
		}
		
		local str_chnn = cjson.encode(obj_chnn)
		iworker.post(iworker.lw_dev_ipc, 'request_i', '{}', str_chnn)
	end

	res[cmd] = {
		code = code
	}
end


-- @brief 关闭码流
-- @param [in]  	req[table]	请求
-- @param [out]		res[table]	回复对象
-- @param [in]		cmd[string]	符合字符集[azAZ09_]规则的 单个单词
-- @return 无返回值
p_stream.on_close_stream = function (req, res, cmd)
	
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
	
	local md_id = 0
	--if 'number' == type(param['md_id']) then
	--	md_id = param['md_id']
	--end

	local code = l_nsm.close_stream(req.id, chnn, idx, md_id)

	res[cmd] = {
		code = code
	}
	
end

local get_wh = function (wh)
	if 'string' ~= type(wh) then
		return
	end
	
	local str_w, str_h = string.match(wh, '([%d]+)[^%d]+([%d]+)') -- 匹配形如 '1920*1080'
	
	local w = tonumber(str_w)
	local h = tonumber(str_h)

	if 0 < w and 0 < h then
		return w, h
	end
end

-- @brief 设置流参数
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_stream.on_set_stream = function (req, res, cmd)
	
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
	
	local key_c_i = cfg.key_chnn_idx('stream', chnn, idx)	
	local ret, json, code = cfg.set(key_c_i, param)
	
	if ret then

		local obj_chnn = {
			chnn = chnn,
			idx = idx
		}
		
		local str_chnn = cjson.encode(obj_chnn)
		iworker.post(iworker.lw_dev_ipc, 'stream', json, str_chnn)	
		
		res[cmd] = {
			code = np_err.OK
		}
	else
		res[cmd] = {
			code = code
		}
	end
end


-- @brief 设置图片流参数
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_stream.on_set_stream_pic = function (req, res, cmd)
	
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
	
	local key_c_i = cfg.key_chnn_idx('stream_pic', chnn, idx)	
	local ret, json, code = cfg.set(key_c_i, param)
	
	if ret then
		local obj_chnn = {
			chnn = chnn,
			idx = idx
		}
		
		local str_chnn = cjson.encode(obj_chnn)
		iworker.post(iworker.lw_dev_ipc, 'stream_pic', json, str_chnn)	
		
		res[cmd] = {
			code = np_err.OK
		}
	else
		res[cmd] = {
			code = code
		}
	end
end


return p_stream
