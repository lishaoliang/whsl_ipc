--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/04
--
-- @file    t_set_sta.lua
-- @brief   设置sta模式
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/04 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local l_sys = require("l_sys")

local write_wpa_cfg = require("ipc.phynet.write_wpa_cfg")
local wlan = require("ipc.phynet.wlan")
local wpa_cli = require("ipc.phynet.wpa_cli")


-- 需要连接的路由器信息
local ssid = 'HUAWEI-7NLNPF_5G'
local passwd = 'qwertyuiop1234567890'


-- 更新配置文件
write_wpa_cfg(ssid, passwd)


-- 设置环境为sta 模式, 并连接到wifi
wlan.env_sta()


-- 以下 dhcp 和 静态ip 选择一项

-- 开启dhcpc
--wlan.set_sta_dhcp()


-- 设置静态ip
wlan.set_sta_ipv4('192.168.9.218', '255.255.255.0', '192.168.9.1')
