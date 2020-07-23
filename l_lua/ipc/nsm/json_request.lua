--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- Created: 2018/12/21
--
-- @file   json_request.lua
-- @brief  json协议请求处理流程
-- @author 李绍良
--]]
local h_code = require("ipc.http.h_code")
local np_err = require("base.np_err")
local p_com = require("ipc.proto.p_com")
local p_ctrl_sys = require("ipc.proto.p_ctrl_sys")
local p_auth = require("ipc.proto.p_auth")
local p_user = require("ipc.proto.p_user")
local p_base = require("ipc.proto.p_base")
local p_net = require("ipc.proto.p_net")
local p_pub = require("ipc.proto.p_pub")
local p_stream = require("ipc.proto.p_stream")
local p_image = require("ipc.proto.p_image")
local p_osd = require("ipc.proto.p_osd")
local p_cfg = require("ipc.proto.p_cfg")


local str_support = ''


-- brief 所有消息响应
local func_map = {
	-- pub
	hello = p_pub.on_hello,
	--encrypt = p_pub.on_encrypt,
	
	
	
	-- auth
	login = p_auth.on_login,
	logout = p_auth.on_logout,



	-- user
	--user_add = p_user.on_user_add,
	--user_remove = p_user.on_user_remove,
	--user_modify = p_user.on_user_modify,
	--user_all = p_user.on_user_all,
	--user_modify_pwd = p_user.on_user_modify_pwd,
	--user_info = p_user.on_user_info,
	--user_online = p_user.on_user_online,



	-- base
	system = p_com.on_get_cfg,
	
	name = p_com.on_get_cfg,
	default_name = p_com.on_get_default_cfg,
	--set_name = p_base.on_set_name,
	
	--time = p_base.on_time,
	--set_time = p_base.on_set_time,
	
	ntp = p_com.on_get_cfg,
	default_ntp = p_com.on_get_default_cfg,
	set_ntp = p_base.on_set_ntp,
	
	ntp_sync = p_base.on_ntp_sync,
	
	
	
	-- net
	ipv4 = p_com.on_get_cfg,
	default_ipv4 = p_com.on_get_default_cfg,
	set_ipv4 = p_net.on_set_ipv4,
	
	wireless = p_com.on_get_cfg,
	default_wireless = p_com.on_get_default_cfg,
	set_wireless = p_net.on_set_wireless,
	
	wireless_ipv4 = p_com.on_get_cfg,
	default_wireless_ipv4 = p_com.on_get_default_cfg,
	set_wireless_ipv4 = p_net.on_set_wireless_ipv4,

	--net_port = p_com.on_get_cfg,
	--default_net_port = p_com.on_get_default_cfg,
	--set_net_port = p_net.on_set_net_port,
	
	
	
	-- stream
	open_stream = p_stream.on_open_stream,
	close_stream = p_stream.on_close_stream,
	
	stream = p_com.on_get_cfg_chnn_idx,
	default_stream = p_com.on_get_default_cfg_chnn_idx,
	set_stream = p_stream.on_set_stream,
	
	
	stream_pic = p_com.on_get_cfg_chnn_idx,
	default_stream_pic = p_com.on_get_default_cfg_chnn_idx,
	set_stream_pic = p_stream.on_set_stream_pic,
	
	
	-- image
	image = p_com.on_get_cfg_chnn,
	default_image = p_com.on_get_default_cfg_chnn,
	set_image = p_image.on_set_image,
	
	--img_wd = p_com.on_get_cfg_chnn,
	--default_img_wd = p_com.on_get_default_cfg_chnn,
	--set_img_wd = p_image.on_set_img_wd,
	
	--img_dnr = p_com.on_get_cfg_chnn,
	--default_img_dnr = p_com.on_get_default_cfg_chnn,
	--set_img_dnr = p_image.on_set_img_dnr,
	
	img_rotate = p_com.on_get_cfg_chnn,
	default_img_rotate = p_com.on_get_default_cfg_chnn,
	set_img_rotate = p_image.on_set_img_rotate,
	
	img_awb = p_com.on_get_cfg_chnn,
	default_img_awb = p_com.on_get_default_cfg_chnn,
	set_img_awb = p_image.on_set_img_awb,

	info_img_awb = p_image.on_info_img_awb,

	img_mirror_flip = p_com.on_get_cfg_chnn,
	default_img_mirror_flip = p_com.on_get_default_cfg_chnn,
	set_img_mirror_flip = p_image.on_set_img_mirror_flip,

	img_exposure = p_com.on_get_cfg_chnn,
	default_img_exposure = p_com.on_get_default_cfg_chnn,
	set_img_exposure = p_image.on_set_img_exposure,
	
	
	-- OSD
	osd_timestamp = p_com.on_get_cfg_chnn,
	default_osd_timestamp = p_com.on_get_default_cfg_chnn,
	set_osd_timestamp = p_osd.on_set_osd_timestamp,
	
	
	
	
	-- cfg操作
	--cfg_export = p_cfg.on_cfg_export,
	--cfg_inport = p_cfg.on_cfg_inport,
	--cfg_default = p_cfg.on_cfg_default,
	--cfg_default_all = p_cfg.on_cfg_default_all,


	
	
	-- ctrl
	--ctrl_reboot = p_ctrl_sys.on_ctrl_reboot,
	
	
	
	-- support, 支持的命令集合
	support = function (req, res, cmd)				
		res[cmd] = {
			code = np_err.OK,
			cmds = str_support
		}
	end
}

local get_func_support = function (func)
	-- 使用 table 来拼接字符串, '..'拼接效率较为低下
	local t = {}
	for k, v in pairs(func) do
		if nil ~= next(t) then
			table.insert(t, ',')
		end
		
		table.insert(t, tostring(k))
	end
	
	return table.concat(t)
end

str_support = get_func_support(func_map)


-- brief 不支持协议响应
-- res [table]	回复对象
-- cmd [string] 符合字符集[azAZ09_]规则的 单个单词
local on_unsupport = function (req, res, cmd)
	res[cmd] = {
		code = np_err.UNSUPPORT
	}
end


-- @brief 响应json协议请求
-- @param [in]	req[table]	请求
-- @param [out]	res[table]	响应请求的回复数据
-- @return [number] 错误码
local json_request = function (req, res)
	-- note: req必须为完整的对象, 各种协议过来的数据必须事先解析完整
	assert('table' == type(req))

	-- res回复
	res.cmd = req.cmd
	
	-- 协议字符集[azAZ09_]
	for cmd in string.gmatch(req.cmd, '[%w_]+') do
		local cmd_low = string.lower(cmd) -- 不区分key字段大小写
		
		local cmd_real, ext = string.match(cmd_low, '([%w_]+)(_[%d]+)$') -- 去除后缀 '_[0-9]+'
		if nil == cmd_real then
			cmd_real = cmd_low -- 不符合后缀方式时,命令为小写方式
		end
		
		-- 排除关键字 'cmd'
		if 'cmd' ~= cmd_real then
			local cb = func_map[cmd_real]
			if nil ~= cb then
				cb(req, res, cmd)
			else
				on_unsupport(req, res, cmd)
			end
		end
	end
	
	return 0 --返回0, 表示继续连接; 非0, 表示断开连接
end

return json_request
