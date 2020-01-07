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

local l_dev_ipc = require("l_dev_ipc")
local l_dev_vi = require("l_dev_vi")


local p_image = {}


-- @brief 当设置 手动'manual'白平衡时, 不带[b, gb, gr, r]参数表示使用实时白平衡信息
local adjust_img_awb = function (chnn, param)
	local E = {}
	local awb = (param or E).awb
	
	if 'manual' == awb then
		local b = (param or E).b
		local gb = (param or E).gb
		local gr = (param or E).gr
		local r = (param or E).r
		
		if not b or not gb or not gr or not r then
			-- 缺失任何一项, 都认为使用实时白平衡信息			
			local ret, now_b, now_gb, now_gr, now_r = l_dev_vi.get_awb(chnn)
			if 0 == ret then
				param['b'] = now_b
				param['gb'] = now_gb
				param['gr'] = now_gr
				param['r'] = now_r
			end
		end
	end
end


-- @brief 设置图像部分通用处理方法
-- @param [in]		img_key[string]	图像部分配置key值
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
local set_img_xxx = function (img_key, req, res, cmd)
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
	
	-- 参数调整
	if 'img_awb' == img_key then
		adjust_img_awb(chnn, param)
	end
	
	local key_c = cfg.key_chnn(img_key, chnn)	
	local ret, json, code = cfg.set(key_c, param)
	
	if ret then
		local obj_chnn = {
			chnn = chnn
		}
		
		local str_chnn = cjson.encode(obj_chnn)
		iworker.post(iworker.lw_dev_ipc, img_key, json, str_chnn)
		
		res[cmd] = {
			code = np_err.OK
		}
	else
		res[cmd] = {
			code = code
		}
	end
end


-- @brief 设置图像参数
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_set_image = function (req, res, cmd)
	set_img_xxx('image', req, res, cmd)
end


-- @brief 设置图像宽动态
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_set_img_wd = function (req, res, cmd)
	set_img_xxx('img_wd', req, res, cmd)
end


-- @brief 设置图像降噪
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_set_img_dnr = function (req, res, cmd)
	set_img_xxx('img_dnr', req, res, cmd)
end


-- @brief 设置图像旋转
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_set_img_rotate = function (req, res, cmd)
	set_img_xxx('img_rotate', req, res, cmd)
end


-- @brief 设置图像白平衡
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_set_img_awb = function (req, res, cmd)
	set_img_xxx('img_awb', req, res, cmd)
end


-- @brief 获取图像实时白平衡信息
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_info_img_awb = function (req, res, cmd)
	
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

	local ret, b, gb, gr, r = l_dev_vi.get_awb(chnn)
	
	if 0 == ret then		
		res[cmd] = {
			code = np_err.OK,
			chnn = chnn,
			b = b,
			gb = gb,
			gr = gr,
			r = r
		}
	else
		res[cmd] = {
			code = np_err.NOTFOUND
		}
	end
end

-- @brief 设置图像左右镜像,翻转
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_set_img_mirror_flip = function (req, res, cmd)
	set_img_xxx('img_mirror_flip', req, res, cmd)
end


-- @brief 设置图像曝光
-- @param [in]		req[table]	请求
-- @param [in,out]	res[table]	回复对象
-- @param [in]		cmd[string]	命令
-- @return 无
p_image.on_set_img_exposure = function (req, res, cmd)
	set_img_xxx('img_exposure', req, res, cmd)
end


return p_image
