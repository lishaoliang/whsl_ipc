--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/4/28
--
-- @file    run_env.lua
-- @brief   运行时环境
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/4/28 0.1 创建文件
-- @warning 没有警告
--]]
local l_sys = require("l_sys")
local unix = require("base.unix")


-- 
print('run env start...')


-- 创建内存映像目录
unix.shell('rm -rf /nfsmem')
unix.shell('mkdir /nfsmem')
unix.shell('mount -t tmpfs -o size=60M,mode=0777 tmpfs /nfsmem')


-- 创建升级目录
unix.shell('mkdir /nfsmem/upgrade')


-- 拷贝脚本环境
unix.shell('mkdir /nfsmem/l_lua')
unix.shell('cp -rf /opt/l_lua/base /nfsmem/l_lua/')
unix.shell('cp -rf /opt/l_lua/upgrade /nfsmem/l_lua/')


-- 将升级软件所需要的文件 拷贝到/nfsmem, 否则会导致升级到一半, 升级软件挂掉
unix.shell('cp -f /opt/mydaemon /nfsmem/')


-- 创建支持项目录
unix.shell('mkdir /nfsmem/surport')



---------------------------------------------------------------------------
-- 各个项目的支持项


if 'hi_3520dv200_AHB7004T_LM_V3' == l_sys.chip then
	unix.shell('echo "0" > /nfsmem/surport/surport_wireless')
end


print('run env over...')
