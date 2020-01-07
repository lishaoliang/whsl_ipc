--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- Created: 2018/12/21
--
-- @file    cfg_setup.lua
-- @brief   初始配置生效
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local cjson = require("cjson")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")
local cfg = require("ipc.cfg.cfg")


local setup_img_xxx = function (img_key, chnn)
	local key_c = cfg.key_chnn(img_key, chnn)
	local json = cjson.encode(cfg.get(key_c))
	
	local obj_chnn = {
		chnn = chnn
	}
	
	local str_chnn = cjson.encode(obj_chnn)
	iworker.post(iworker.lw_dev_ipc, img_key, json, str_chnn)
end

local setup_osd_xxx = function (osd_key, chnn)
	local key_c = cfg.key_chnn(osd_key, chnn)
	local json = cjson.encode(cfg.get(key_c))
	
	local obj_chnn = {
		chnn = chnn
	}
	
	local str_chnn = cjson.encode(obj_chnn)
	iworker.post(iworker.lw_dev_ipc, osd_key, json, str_chnn)
end

local setup_stream = function (chnn, idx)
	local key_c_i = cfg.key_chnn_idx('stream', chnn, idx)
	local json = cjson.encode(cfg.get(key_c_i))

	local obj_chnn = {
		chnn = chnn,
		idx = idx
	}
		
	local str_chnn = cjson.encode(obj_chnn)
	iworker.post(iworker.lw_dev_ipc, 'stream', json, str_chnn)	
end

local setup_stream_pic = function (chnn, idx)
	local key_c_i = cfg.key_chnn_idx('stream_pic', chnn, idx)	
	local json = cjson.encode(cfg.get(key_c_i))
	
	local obj_chnn = {
		chnn = chnn,
		idx = idx
	}
		
	local str_chnn = cjson.encode(obj_chnn)
	iworker.post(iworker.lw_dev_ipc, 'stream_pic', json, str_chnn)
end

local setup_ntp = function ()
	local ntp = cfg.get('ntp')	
	
	local json = cjson.encode(ntp)
	iworker.post(iworker.lw_dev_ipc, 'ntp', json, '{}')	
end


local setup_discover = function (system)	
	
	local name = cfg.get('name')
	local net_port = cfg.get('net_port')

	local discover = 
	{
		cmd = 'discover',
		sn = system['sn'] or 'xxx',
			
		discover = {
			hw_ver = system['hw_ver'] or 'h0.0.0',
			sw_ver = system['sw_ver'] or 'v0.0.0',
			model = system['model'] or 'ipc',
			dev_type = system['dev_type'] or 'ipc',
			chnn_num = system['chnn_num'] or 1,
			txt_enc = system['txt_enc'] or '',
			md_enc = system['md_enc'] or '',
			mac = system['mac'] or '00:00:00:00:00:00',
			mac_wireless = system['mac_wireless'] or '00:00:00:00:00:00',	
			
			name = name['name'] or 'xxx',
			port = net_port['port'] or 80
		}
	}
	
	local txt = cjson.encode(discover)
	iworker.post(iworker.lw_discover, 'broadcast_ser.set_respond', txt, '')
end

local cfg_setup = function ()

	setup_img_xxx('img_mirror_flip', 0)	-- 生效左右镜像,上下翻转
	setup_img_xxx('img_rotate', 0)		-- 生效图像旋转
	setup_img_xxx('image', 0)			-- 生效色彩
	setup_img_xxx('img_awb', 0)			-- 生效白平衡
	setup_img_xxx('img_exposure', 0)	-- 生效曝光


	setup_osd_xxx('osd_timestamp', 0)	-- 生效OSD时间戳 


	-- 生效流配置
	setup_stream(0, 0)
	setup_stream(0, 1)
	
	-- 生效图片流
	setup_stream_pic(0, 64)
	setup_stream_pic(0, 65)

	-- 生效NTP	
	setup_ntp()	
	
	-- system信息
	local system = cfg.get('system')
	
	-- 生效广播消息
	setup_discover(system)
	
	-- 打印信息
	print('model:', system['model'] or 'ipc')
	print('dev_type:', system['dev_type'] or 'ipc')
	print('hw_ver:', system['hw_ver'] or 'h0.0.0')
	print('sw_ver:', system['sw_ver'] or 'v0.0.0')
	print('build_time:', system['build_time'] or '0000-00-00 00:00:00 +00:00')
	
end

return cfg_setup
