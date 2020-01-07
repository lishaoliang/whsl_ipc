--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/08
--
-- @file    unix.lua
-- @brief   unix常用命令
--	\n 依赖库 l_sys
-- @author	李绍良
-- @version 0.1
-- @history 修改历史
--  \n 2019/04/08 0.1 创建文件
-- @note
-- @warning 没有警告
--]]
local string = require("string")
local util = require("base.util")
local l_sys = require("l_sys")
local sh = l_sys.sh


local unix = {}


if 'hisi_linux' ~= l_sys.platform then
	-- 非目标平台, 不执行对应语句
	sh = function (cmd)
		print(cmd)
		return 0, ''
	end
end


unix.shell = function (cmd)
	local ret, str = sh(cmd)
	
	return ret, str
end


unix.killall = function (name)
	local cmd = string.format('killall %s', name)
	sh(cmd)
end

unix.kill = function (name, ...)
	-- ps -e |grep lua |awk '{print $1}' |xargs kill -9
	local grep = string.format('|grep %s', name)
	for k, v in ipairs({...}) do
		grep = string.format('%s |grep %s', grep, v)
	end
	
	local cmd = string.format('ps -e %s |awk \'{print $1}\' |xargs kill', grep)
	--print('cmd:..', cmd)
	
	sh(cmd)
end


unix.ps = function (...)
	-- ps -e |grep lua |awk '{print $1" "$4}'
	local grep = ''
	for k, v in ipairs({...}) do
		grep = string.format('%s |grep %s', grep, v)
	end
	
	local cmd = string.format('ps -e %s |awk \'{print $1\" \"$4}\'', grep)
	local ret, str = sh(cmd)
	--print(str)

--[[
local str =
'PID COMMAND\n' ..
'1 init\n' ..
'2 [kthreadd]\n' ..
'3 [ksoftirqd/0]\n' ..
'4 [kworker/0:0]\n' ..
'5 [kworker/0:0H]\n' ..
'7 [rcu_sched]\n' ..
'8 [rcu_bh]\n' ..
'9 [migration/0]\n' ..
'10 [migration/1]\n' ..
'11 ksoftirqd \n fes\n'
--]]
	
	local o = {}
	for m, n in string.gmatch(str, '(%d+)%s+([^%c]+)%c*') do	
		if nil ~= m and nil ~= n then
			m = util.trim_cs(m)
			n = util.trim_cs(n)
			if 'sh' ~= n then
				o[m] = n	-- PID项不会重复, 所以使用pid项作为key
			end	
		end
	end
	
	return o
end

unix.get_ifconfig = function ()	
	local ret, str = sh('ifconfig')
	
--[[
local str = 
'eth0      Link encap:Ethernet  HWaddr C6:B7:67:BF:08:FF\r\n' ..
'          inet addr:192.168.3.218  Bcast:192.168.3.255  Mask:255.255.255.0\r\n' ..
'          inet6 addr: fe80::c4b7:67ff:febf:8ff/64 Scope:Link\r\n' ..
'          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\r\n' ..
'          RX packets:45285 errors:0 dropped:5381 overruns:0 frame:0\r\n' ..
'          TX packets:3886 errors:0 dropped:0 overruns:0 carrier:0\r\n' ..
'          collisions:0 txqueuelen:1000\r\n' ..
'          RX bytes:52034099 (49.6 MiB)  TX bytes:525278 (512.9 KiB)\r\n' ..
'          Interrupt:57\r\n' ..
'\r\n' ..
'lo        Link encap:Local Loopback\r\n' ..
'          inet addr:127.0.0.1  Mask:255.0.0.0\r\n' ..
'          inet6 addr: ::1/128 Scope:Host\r\n' ..
'          UP LOOPBACK RUNNING  MTU:65536  Metric:1\r\n' ..
'          RX packets:2 errors:0 dropped:0 overruns:0 frame:0\r\n' ..
'          TX packets:2 errors:0 dropped:0 overruns:0 carrier:0\r\n' ..
'          collisions:0 txqueuelen:0\r\n' ..
'          RX bytes:176 (176.0 B)  TX bytes:176 (176.0 B)\r\n' ..
'\r\n' ..
'wlan0     Link encap:Ethernet  HWaddr 50:2B:73:D5:27:1D\r\n' ..
'          inet addr:192.168.3.6  Bcast:192.168.3.255  Mask:255.255.255.0\r\n' ..
'          inet6 addr: fe80::522b:73ff:fed5:271d/64 Scope:Link\r\n' ..
'          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\r\n' ..
'          RX packets:12 errors:0 dropped:3571 overruns:0 frame:0\r\n' ..
'          TX packets:4 errors:0 dropped:3 overruns:0 carrier:0\r\n' ..
'          collisions:0 txqueuelen:1000\r\n' ..
'          RX bytes:651743 (636.4 KiB)  TX bytes:11222 (10.9 KiB)\r\n' ..
'\r\n'
--]]
	local ips = {}

	for lines in string.gmatch(str, '(.-)\n%c*\n') do
		
		local name = string.match(lines, '([^%s%c]+)%s+Link encap')
		local mac = string.match(lines, 'HWaddr%s*([%x:-]+)')
		local ipv4 = string.match(lines, 'inet addr%s*:%s*([%d.]+)')
		local mask = string.match(lines, 'Mask%s*:%s*([%d.]+)')
		local bcast = string.match(lines, 'Bcast%s*:%s*([%d.]+)')
		
		if nil ~= name and nil ~= mac then
			local o = {
				name = name,
				mac = mac,
				ipv4 = ipv4 or '',
				mask = mask or '',
				bcast = bcast or ''
			}
			
			table.insert(ips, o)
		end	
		--print(lines)
	end

	return ips
end

return unix
