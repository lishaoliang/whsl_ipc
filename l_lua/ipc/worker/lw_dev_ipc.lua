--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
--
-- @file    lightweight.lua
-- @brief   轻量级工作线程入口: 专用于处理调用海思设备接口
--		可以接受最多300ms耗时
-- @version 0.1
-- @author	李绍良
--]]

local string = require("string")
local cjson = require("cjson")

local l_dev = require("l_dev")

local util_ex =  require("base.util_ex")

local lt_name = ''

init = function (param)
	--print('init .....', param)
	lt_name = param
	return 0
end

quit = function ()
	--print('quit .....')
	return 0
end

local lwdi_on_request_i = function (lobj, wobj)
	l_dev.request_i(wobj['chnn'], wobj['idx'])
end

local lwdi_on_image = function (lobj, wobj)	
	l_dev.set_image(wobj['chnn'], lobj['bright'], lobj['contrast'], lobj['saturation'], lobj['hue'])
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

local lwdi_on_stream = function (lobj, wobj)	
	local w, h = get_wh(lobj['wh'])
	l_dev.set_stream(wobj['chnn'], wobj['idx'], lobj['fmt'], w, h, lobj['frame_rate'], lobj['bitrate'], lobj['rc_mode'], lobj['quality'], lobj['i_interval'])
end

local lwdi_on_stream_pic = function (lobj, wobj)
	local w, h = get_wh(lobj['wh'])
	l_dev.set_stream_pic(wobj['chnn'], wobj['idx'], lobj['fmt'], w, h, lobj['interval_ms'], lobj['quality'])
end

local lwdi_on_img_rotate = function (lobj, wobj)	
	l_dev.set_rotate(wobj['chnn'], lobj['rotate'])
end

local lwdi_on_img_awb = function (lobj, wobj)
	local awb = lobj['awb']
	
	local b_auto = true
	
	if 'manual' == awb then
		b_auto = false		
	end
	
	l_dev.set_awb(wobj['chnn'], b_auto, lobj['b'], lobj['gb'], lobj['gr'], lobj['r'])
end


local lwdi_on_img_mirror_flip = function (lobj, wobj)
	l_dev.set_mirror_flip(wobj['chnn'], lobj['mirror'], lobj['flip'])
end


local lwdi_on_img_exposure = function (lobj, wobj)
	l_dev.set_exposure(wobj['chnn'], lobj['compensation'])
end


local lwdi_on_osd_timestamp = function (lobj, wobj)
	l_dev.set_osd_timestamp(wobj['chnn'], lobj['enable'], lobj['format'], lobj['pos'], lobj['font_size'])
end

local lwdi_on_ntp = function (lobj, wobj)
	--l_dev_base.set_ntp(lobj['enable'], lobj['server'], lobj['port'], lobj['interval'])
end

local lwdi_on_ntp_sync = function (lobj, wobj)
	--l_dev_base.ntp_sync(lobj['server'], lobj['port'])
end


local func_map = {
	request_i = lwdi_on_request_i,
	image = lwdi_on_image,
	stream = lwdi_on_stream,
	stream_pic = lwdi_on_stream_pic,
	img_rotate = lwdi_on_img_rotate,
	img_awb = lwdi_on_img_awb,
	img_mirror_flip = lwdi_on_img_mirror_flip,
	img_exposure = lwdi_on_img_exposure,
	
	osd_timestamp = lwdi_on_osd_timestamp,
	
	--ntp = lwdi_on_ntp,
	--ntp_sync = lwdi_on_ntp_sync,
}

on_cmd = function (msg, lparam, wparam, cobj)
	--print('on_cmd.name:'..lt_name, msg, lparam, wparam)

	local cmd_low = string.lower(msg) -- 不区分key字段大小写	
	local cb = func_map[cmd_low]
	if nil ~= cb then
		local ret, lobj = pcall(cjson.decode, lparam)
		local ret, wobj = pcall(cjson.decode, wparam)
		
		cb(lobj, wobj)
	else
		print('unsupport!name:'..lt_name, msg, lparam, wparam)
	end
	
	return 0
end
