--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/04
--
-- @file    test.lua
-- @brief   测试
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/04 0.1 创建文件
-- @warning 没有警告
--]]
local l_sys = require("l_sys")
local util = require("base.util")
local util_ex = require("base.util_ex")

local wlan = require("ipc.phynet.wlan")
local wpa_cli = require("ipc.phynet.wpa_cli")

local unix = require("base.unix")

util_ex.printf(unix.ps())
util_ex.printf(unix.get_ifconfig())

--unix.kill('hostapd')
--unix.kill('dnsmasq')
--unix.kill('wpa_supplicant')
--unix.kill('udhcpc', 'wlan0')
--unix.kill('udhcpc', 'eth0')

--util_ex.printf(unix.ps())
--util_ex.printf(unix.ps('udhcpc', 'wlan0'))

--wlan.env_sta()
--util_ex.printf(wpa_cli.scan())
--l_sys.sleep(2000)
--util_ex.printf(wpa_cli.scan_results())

--util_ex.printf(wpa_cli.status())