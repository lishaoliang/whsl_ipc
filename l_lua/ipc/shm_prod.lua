--[[
-- Copyright(c) 2010, 武汉舜立软件 All Rights Reserved
-- Created: 2020/1/7
--
-- @file    shm_prod.lua
-- @brief	多进程共享内存(生产者)
-- @version 0.1
-- @author  李绍良
--   本模块依赖 l_tpool.init()
--   在 l_tpool.quit() 之后, 无法使用
--]]
local l_tpool = require("l_tpool")
local l_shm_prod = require("l_shm_prod")
local l_dev_ipc = require("l_dev_ipc")


local shm_prod = {}


shm_prod.init = function ()
	local path_video = '/nfsmem/video.shm'
	local size_video = 6 * 1024 * 1024
	local ret1 = l_shm_prod.open(1, path_video, size_video)
	print('l_shm_prod.open', 1, path_video, size_video / 1024 .. 'K', ret1)
end

shm_prod.quit = function ()
	l_shm_prod.close(1)
	print('l_shm_prod.close', 1)
end

shm_prod.setup = function ()
	l_dev_ipc.add_listener('my shm 1', l_shm_prod.get_receiver(1))
end


return shm_prod
