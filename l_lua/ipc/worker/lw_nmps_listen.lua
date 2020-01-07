-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/29
--
-- @file    lw_nmps_listen.lua
-- @brief	light weight net multiplex protocol listen
--  \n 轻量级线程, 处理80端口监听 多路复用
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/29 0.1 创建文件
-- @warning 没有警告
--]]

local string = require("string")
local cjson = require("cjson")
local l_sys = require("l_sys")

local l_ipc = require("l_ipc")

local l_net_a = require("l_net_a")
local l_nmps_a = require("l_nmps_a")
local l_nsm_a = require("l_nsm_a")


local util = require("base.util")
local np_id = require("base.np_id")
local inet = require("ipc.inet")

local lt_name = ''


local servers ={
	nsm_upgrade = nil
}


local port = 80
local port_local = 8000
local path_local = '/nfsmem/socket.ui'

if 'hisi_linux' ~= l_sys.platform then
	-- 非目标平台
	port = 3456
	port_local = 3457
end


local proc_socket = function (socket, main, sub, url_pre)
	local b_used = false

	if np_id.HTTP == main and nil ~= url_pre then
		-- http 长连接
		if 1 == string.find(url_pre, '/luanspp/') then		-- http_nspp 协议
			main = np_id.NSPP_HTTP
		elseif 1 == string.find(url_pre, '/luaflv/') then	-- http_flv 协议
			main = np_id.HTTP_FLV
		end
	end
	
	
	if np_id.NSPP == main and np_id.UPGRADE == sub then
		b_used = l_nsm_a.push(servers.nsm_upgrade, socket, util.next_socket_id(), main, sub)
	elseif np_id.NSPP == main and np_id.MEDIA == sub then
		b_used = l_ipc.push(socket, util.next_socket_id(), main, sub)
	elseif np_id.NSPP_HTTP == main and np_id.MEDIA == sub then
		b_used = l_ipc.push(socket, util.next_socket_id(), main, sub)
	elseif np_id.NSPP_LOCAL == main and np_id.MEDIA == sub then
		b_used = l_ipc.push(socket, util.next_socket_id(), main, sub)
	elseif np_id.HTTP == main and np_id.MEDIA == sub then
		b_used = l_ipc.push(socket, util.next_socket_id(), main, sub)
	elseif np_id.HTTP_FLV == main and np_id.MEDIA == sub then
		b_used = l_ipc.push(socket, util.next_socket_id(), main, sub)
	elseif np_id.RTSP == main and np_id.MEDIA == sub then
		b_used = l_ipc.push(socket, util.next_socket_id(), main, sub)
	end
	
	
	if not b_used then
		l_sys.free(socket)
	end
end


local on_timer_listen = function (id, count, interval, tc, last_tc)
	
	-- 处理监听
	while true do
		local socket, main, sub, url_pre = l_nmps_a.get_socket()
		if nil ~= socket then
			--print('nmps get socket:', main, sub, url_pre)
			proc_socket(socket, main, sub, url_pre)
		else
			break
		end	
	end
	
	return 0
end


init = function (param)
	--print('init .....', param)
	lt_name = param

	-- 获取所有的服务处理对象
	servers.nsm_upgrade = inet.get_nsm(inet.nsm_upgrade)
	assert(servers.nsm_upgrade)
	
	l_nmps_a.open('80', port)
	l_nmps_a.open_unix('8000', port_local, path_local)
	
	-- 添加定时器
	l_sys.add_timer(100, 10, on_timer_listen)		-- 定时消息
	
	return 0
end


quit = function ()
	--print('quit .....')

	l_nmps_a.close('8000')
	l_nmps_a.close('80')
	
	l_sys.remove_timer(100)
	
	return 0
end


on_cmd = function (msg, lparam, wparam, cobj)
	--print('on_cmd.name:'..lt_name, msg, lparam, wparam)
	
	local cmd_low = string.lower(msg) -- 不区分key字段大小写
	
	return 0
end
