--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/08
--
-- @file    t_set_eth0.lua
-- @brief   设置sta模式
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/08 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local l_sys = require("l_sys")

local eth0 = require("ipc.phynet.eth0")


-- 以下 dhcp 和 静态ip 选择一项

-- 静态ip
eth0.set_ipv4('192.168.3.218', '255.255.255.0', '192.168.3.1')

-- dhcp
--eth0.set_dhcp()

