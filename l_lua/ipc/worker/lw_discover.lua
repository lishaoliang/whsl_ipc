--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- @brief	设备发现服务轻线程
-- @author	李绍良
--]]

local string = require("string")
local cjson = require("cjson")

local l_sys = require("l_sys")
local broadcast_ser = require("ipc.discover.broadcast_ser")

local lt_name = ''


local on_recv = function(id, count, interval, tc, last_tc)

-- ret[boolean]	true.获取到数据; false.没有数据
--	\n	code[number]		0.获取广播消息; 非0.获取到错误码
--	\n	body[string]		广播消息
--	\n	protocol[number]	协议
--	\n	id[number]			id号
--	\n	ip[string]			发送广播的IP
--	\n	port[number]		端口

	while true do
		local ret, code, body, protocol, id, ip, port = broadcast_ser.recv()
			
		if ret then
			--print('broadcast recv:' .. code, ip .. ':' .. port, body)
		else
			break
		end
	end
	
	-- GVCP recv
	-- TODO
	

	return 0
end

local on_update = function(id, count, interval, tc, last_tc)
	
	broadcast_ser.update()
	
	return 0
end


init = function (param)
	--print('init .....', param)
	lt_name = param

	-- 广播服务端初始化
	broadcast_ser.init()

	-- GVCP广播服务端初始化
	--gvcp_broadcast_ser.init()

	--[[
	-- 设置默认搜索回应
	local discover = 
	{
		cmd = 'discover',
		sn = 'xxxx',
			
		discover = {
			name = 'x',
			port = 80,
			hw_ver = 'h0.0.0',
			sw_ver = 'v0.0.0',
			model = 'wifi-ipc',
			dev_type = 'ipc',
			chnn_max = 1,
			txt_enc = '',
			md_enc = ''
		}
	}
	broadcast_ser.set_respond(discover)
	--]]		
		
	-- 添加定时器
	l_sys.add_timer(100, 10, on_recv)		-- 收取广播消息
	l_sys.add_timer(101, 30000, on_update)	-- 默认检测更新时间间隔 30S
	
	return 0
end

quit = function ()
	--print('quit .....')
	
	l_sys.remove_timer(101)
	l_sys.remove_timer(100)

	broadcast_ser.quit()
	
	return 0
end

on_cmd = function (msg, lparam, wparam, cobj)
	--print('on_cmd.name:'..lt_name, msg, lparam, wparam)
	
	local cmd_low = string.lower(msg) -- 不区分key字段大小写
	
	if 'broadcast_ser.set_respond' == cmd_low then
		broadcast_ser.set_respond(lparam)
	elseif 'broadcast_ser.update' == cmd_low then
		broadcast_ser.update()
	else
		print('unsupport!name:'..lt_name, msg, lparam, wparam)
	end
	
	return 0
end
