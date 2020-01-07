--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/12
--
-- @file    broadcast_ser.lua
-- @brief   广播服务端
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/12 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local cjson = require("cjson")
local l_sys = require("l_sys")
local l_net_a = require("l_net_a")
local l_discover = require("l_discover")
local l_broadcast_ser = require("l_broadcast_ser")
local unix = require("base.unix")


local broadcast_ser = {}


local broadcast_port = 57975
local broadcast_id = 900
local broadcast_idx = 1

local next_broadcast_idx = function ()
	broadcast_idx = broadcast_idx + 1
	if 99999 < broadcast_idx then
		broadcast_idx = 1
	end	
	
	return broadcast_idx
end

local bcast_dynamic = {}
local bcast_static = {}

local bcast_reset = function ()
	bcast_dynamic = {}
	bcast_static = {
		limited = {
			open =  false,
			bcast = '255.255.255.255',
			idx = 0
		}
	}
end

bcast_reset()

local open_bcast = function (bcast)
	
	local idx = next_broadcast_idx()
	local open = l_broadcast_ser.open(broadcast_id, idx, bcast, broadcast_port)
	
	return open, bcast, idx
end


local close_bcast_table = function (t)
	for k, v in pairs(t) do
		if nil ~= v then
			local open = v['open']
			local idx = v['idx']
			
			if open then
				l_broadcast_ser.close(broadcast_id, idx)
			end
		end
	end
end


local update_bcast = function (nets)

	-- 检查 bcast_static.limited	
	if not bcast_static.limited.open then
		local open, bcast, idx = open_bcast(bcast_static.limited.bcast)
		bcast_static.limited.open = open
		bcast_static.limited.idx = idx
	end

	local dynamic = {}
	for k, v in pairs(nets) do
		local name = v['name']
		local ip = v['bcast']
		
		if nil ~= name and '' ~= name and nil ~= ip and '' ~= ip then
			local old = bcast_dynamic[name]

			if nil ~= old and old['open'] and ip == old['bcast'] then
				-- 保留原广播
				local o = {
					open = old['open'],
					bcast = old['bcast'],
					idx = old['idx']
				}
				
				dynamic[name] = o
				bcast_dynamic[name] = nil
			else
				-- 新广播地址
				local open, bcast, idx = open_bcast(ip)		
				local o = {
					open = open,
					bcast = bcast,
					idx = idx
				}
				
				dynamic[name] = o
			end
		end
	end
	
	
	-- 更新信息
	local old_dynamic = bcast_dynamic
	bcast_dynamic  = dynamic
	
	
	-- 关闭不再需要的广播
	close_bcast_table(old_dynamic)
end


broadcast_ser.init = function ()
	local nets = unix.get_ifconfig()
	
	update_bcast(nets)
end


broadcast_ser.quit = function ()	
	close_bcast_table(bcast_dynamic)
	close_bcast_table(bcast_static)
	
	bcast_reset()
end

--[[
local discover = 
{
	cmd = 'discover',
	sn = 'YDFE4EFDFESHEDFR',
		
	discover = {
		name = 'x',
		port = 80,
		hw_ver = 'h1.0.0',
		sw_ver = 'v1.0.2',
		model = 'wifi-ipc',
		dev_type = 'ipc',
		chnn_max = 1,
		txt_enc = '',
		md_enc = ''
	}
}
--]]
broadcast_ser.set_respond = function (discover)
	if 'string' == type(discover) then
		l_broadcast_ser.set_respond(broadcast_id, discover)
	elseif 'table' == type(discover) then
		local txt = cjson.encode(discover)	
		l_broadcast_ser.set_respond(broadcast_id, txt)
	else
		assert(false)
	end
end


broadcast_ser.update = function ()
	local nets = unix.get_ifconfig()
	update_bcast(nets)
end


broadcast_ser.recv = function ()
	return l_broadcast_ser.recv()
end


broadcast_ser.send = function (body)

	if 'string' == type(body) then
		l_broadcast_ser.send(broadcast_id, body)
	elseif 'table' == type(body) then
		local txt = cjson.encode(body)	
		l_broadcast_ser.send(broadcast_id, txt)
	else
		assert(false)
	end
end


--[[
l_discover.init()
l_discover.start()

broadcast_ser.init()

local discover = 
{
	cmd = 'discover',
	sn = 'YDFE4EFDFESHEDFR',
		
	discover = {
		name = 'x',
		port = 80,
		hw_ver = 'h1.0.0',
		sw_ver = 'v1.0.2',
		model = 'wifi-ipc',
		dev_type = 'ipc',
		chnn_max = 1,
		txt_enc = '',
		md_enc = ''
	}
}

broadcast_ser.set_respond(discover)


local count = 20
while 0 < count do
	count = count - 1
	
	broadcast_ser.update()
	
	l_sys.sleep(1000)
end

broadcast_ser.quit()
l_discover.stop()
l_discover.quit()

--]]

return broadcast_ser
