--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/12/10
--
-- @file    mcache.lua
-- @brief	服务端所有线程之间共享的数据
-- @version 0.1
-- @author  李绍良
--   本模块依赖 l_tpool.init()
--   在 l_tpool.quit() 之后, 无法使用
--]]

local string = require("string")
local io = require("io")
local os = require("os")
local l_sys = require("l_sys")
local l_tpool = require("l_tpool")
local l_mcache = require("l_mcache")


local mcache = {}


-- 共享数据部分的只读默认值
local mkeys_r = {
	-- 
	
	
	-- surport 是否支持项
	surport_wireless = true,	-- 是否支持无线网卡
	surport_ipc_pool = true,	-- 是否支持ipc的码流内存池: 影响所有连接是否支持码流
	surport_listen = true,		-- 是否支持监听标准(80)端口
	surport_listen_local = true,-- 是否支持监听本地端口
	surport_ui = false,			-- 是否支持UI模块
	surport_shm = false			-- 是否支持进程间共享内存模块(share mem)
}


-- @brief 在进程内共享模块, 设置数据
-- @param [in]	k[string]					key关键字
-- @param [in]	v[string,boolean,number]	值
-- @return 无
mcache.set = function (k, v)
	local default_v = mkeys_r[k]
	
	if nil == default_v then
		print('mcache.set not found!', k, v)
		return
	end
	
	if type(v) ~= type(default_v) then
		print('mcache.set type error!', k, v)
		return
	end
	
	l_mcache.set(k, v)
end


-- @brief 从进程内共享模块, 获取数据
-- @param [in]	k[string]	key关键字
-- @return [nil,string,boolean,number]	值
mcache.get = function (k)
	local default_v = mkeys_r[k]
	
	if nil == default_v then
		return nil
	end

	local v, t1 = l_mcache.get(k)
	
	if type(v) == type(default_v) then
		return v
	else
		return default_v
	end	
end


-- @brief 初始化
mcache.init = function ()
	-- 从支持项目录 '/nfsmem/surport'
	-- 读取文件 '/nfsmem/surport/surport_*' 的一个数值, 如果不为0 则支持
	if 'hisi_linux' == l_sys.platform then
		for k, v in pairs(mkeys_r) do
			if 1 == string.find(k, 'surport_') then
				local path = '/nfsmem/surport/' .. k
				local file = io.open(path)
				if nil ~= file then
					local num = file:read('*n')	-- 从文件中读取一个数字				
					if 0 ~= num then
						mcache.set(k, true)
					else
						mcache.set(k, false)
					end
					file:close()
				end
			end
		end
	end
	
	-- 打印支持项目
	for k, v in pairs(mkeys_r) do
		if 1 == string.find(k, 'surport_') then
			print(k, mcache.get(k))
		end
	end
end


return mcache
