--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/16
--
-- @file    check_env.lua
-- @brief   运行环境检查
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/16 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local io = require("io")
local unix = require("base.unix")

local l_sys = require("l_sys")
local sh = l_sys.sh


local shell = function (tool, msg)
	local cmd = string.format('%s %s', tool, msg)
	
	local ret, str = sh(cmd)
	print('check_env cmd:'..cmd, ret, str)	
	
	return ret, str	
end

local reset_eth0_hw = function (mac)	
	--ifconfig eth0 down
	--ifconfig eth0 hw ether $mac
	--ifconfig eth0 192.168.1.247 up
	--ifconfig lo up
	
	shell('ifconfig eth0 down', '')
	shell('ifconfig eth0 hw ether', mac)
	shell('ifconfig eth0 192.168.1.247 up', '')
	shell('ifconfig lo up', '')
end


-- @brief 随机mac
local rand_mac = function ()
	local hexs = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
	local mac = ''
	for i = 1, 6, 1 do
		if 1 == i then
			local v1 = hexs[l_sys.rand(16)]
			local v2 = 0 -- 第二位须为4的整数倍, 简单处理直接为0
			
			mac = string.format('%s%s', v1, v2)
		else
			local v1 = hexs[l_sys.rand(16)]
			local v2 = hexs[l_sys.rand(16)]			
			mac = string.format('%s:%s%s', mac, v1, v2)
		end
	end
	
	return mac
end


-- @brief 重新获取mac
local get_my_mac = function ()
	local mac = ''
	
	-- 提取系统生成的MAC
	local ifc = unix.get_ifconfig()
	local ifc_eht0 = ifc['eth0']
	if ifc_eht0 and ifc_eht0['mac'] then
		mac = ifc_eht0['mac']
	end
	
	-- 否则, 随机生成一个
	if 'string' ~= type(mac) or string.len(mac) ~= 17 then
		mac = rand_mac()
		print('ipc.env.check_env', 'rand mac='..mac)
	end

	-- 将mac地址修改为 '00:1*:*' 格式
	mac = string.gsub(mac, '-', ':')
	mac = string.format('%s%s', '00:1', string.sub(mac, 5))
	mac = string.upper(mac)

	return mac
end


-- @brief 检查eth0的mac地址是否合法, 不合法则, 重写mac地址
local check_eth0_mac = function ()
	local reboot = false
	local reset = true
	local path_eth0_mac = '/etc/MAC_ETH0'
	--local path_eth0_mac = './MAC_ETH0'
	
	local fr = io.open(path_eth0_mac, 'r')
	if fr then
		local mac = fr:read()
		fr:close()
		
		if 'string' == type(mac) and string.match(mac, '[%x]+[:-][%x]+[:-][%x]+[:-][%x]+[:-][%x]+[:-][%x]+') then
			reset = false
		end
		
		print('check_eth0_mac', mac)
	end

	local out_mac = ''
	if reset then
		local mac = get_my_mac()
		assert(mac and '' ~= mac)
		
		local fw = io.open(path_eth0_mac, 'w')
		if fw then
			fw:write(mac)
			fw:close()
			
			print('ipc.env.check_env', 'rewrite eth0 mac=' .. mac)
			out_mac = mac
			reboot = true
		end
	end	
	
	return reboot, out_mac
end

local check_env = function ()
	local reboot = false

	-- 初始化随机值
	--l_sys.srand()

	-- 检查物理网口mac地址
	local ret_eth0, mac = check_eth0_mac()
	if ret_eth0 then
		reset_eth0_hw(mac)
		reboot = true
	end
	
	-- 是否需要重启
	if reboot then
		print('ipc.env.check_env', 'need reboot...')
		-- shell('reboot', '') -- 软重启导致, USB反复升级
	end
end


return check_env
