--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/04
--
-- @file    t_set_ap.lua
-- @brief   设置ap模式
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/04 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local l_sys = require("l_sys")

local wlan = require("ipc.phynet.wlan")
local wpa_cli = require("ipc.phynet.wpa_cli")


-- 设置环境为 ap 模式
wlan.env_ap()
