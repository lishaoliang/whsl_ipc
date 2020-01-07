--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- Created: 2018/12/21
--
-- @file    iworker.lua
-- @brief   IPC的工作线程
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]
local l_tpool = require("l_tpool")
local util = require("base.util")

local iworker = {}


-- @name   iworker.lw_dev_ipc
-- @export 海思设备函数线程
iworker.lw_dev_ipc = 'lw_dev_ipc'


-- @name   iworker.lw_discover
-- @export 设备发现
iworker.lw_discover = 'lw_discover'


-- @name   iworker.lw_upgrade
-- @export 设备升级
iworker.lw_upgrade = 'lw_upgrade'


-- @name   iworker.lw_nmps_listen
-- @export 端口监听模块
iworker.lw_nmps_listen = 'lw_nmps_listen'



local lightweight = {'lightweight_1', 'lightweight_2'}



-- @brief iworker 模块初始化
--  \n 非多线程完全
--  \n 必须全局使用, 注意由主Lua线程调用
iworker.init = function ()

end


-- @brief iworker 模块退出
--  \n 非多线程完全
--  \n 必须全局使用, 注意由主Lua线程调用
iworker.quit = function ()	

end


-- @brief iworker 模块 第二阶段初始化: 有依赖的线程在此完成初始化
--  \n 非多线程完全
--  \n 必须全局使用, 注意由主Lua线程调用
iworker.start = function ()
	
	-- 创建专门处理海思底层接口工作线程
	local ret = l_tpool.create(iworker.lw_dev_ipc, 10, 'ipc.worker.lw_dev_ipc', 'lw_dev_ipc', nil)
	assert(ret)

	-- 创建轻量级线程
	for k, v in pairs(lightweight) do
		if 'string' == type(v) then
			print('lua iworker create thread name:', v)
			local ret = l_tpool.create(v, 10, 'ipc.worker.lightweight', v, nil)
			assert(ret)
		end
	end
	
	-- 创建设备发现
	local ret = l_tpool.create(iworker.lw_discover, 10, 'ipc.worker.lw_discover', 'lw_discover', nil)
	assert(ret)
	
	-- 创建升级
	ret = l_tpool.create(iworker.lw_upgrade, 10, 'ipc.worker.lw_upgrade', 'lw_upgrade', nil)
	assert(ret)
	
	-- 创建监听模块
	ret = l_tpool.create(iworker.lw_nmps_listen, 10, 'ipc.worker.lw_nmps_listen', 'lw_nmps_listen', nil)
	assert(ret)
end

-- @brief iworker 模块 stop
--  \n 非多线程完全
--  \n 必须全局使用, 注意由主Lua线程调用
iworker.stop = function ()
	-- 销毁监听模块
	l_tpool.destroy(iworker.lw_nmps_listen)	

	-- 销毁设备升级
	l_tpool.destroy(iworker.lw_upgrade)	
	
	-- 销毁设备发现
	l_tpool.destroy(iworker.lw_discover)

	-- 销毁轻量级线程
	for k, v in pairs(lightweight) do
		if 'string' == type(v) then
			l_tpool.destroy(v)
		end
	end

	-- 销毁处理海思底层接口工作线程
	l_tpool.destroy(iworker.lw_dev_ipc)
end


-- @brief 向名称为name的线程post消息
-- @param [in] name[string] 消息队列名称
-- @param [in] msg[string]	消息
-- @param [in] lparam[string] lparam参数
-- @param [in] wparam[string] wparam参数
-- @return [boolean] 是否成功; 失败原因为没有找到name的线程
-- @note 多线程安全
iworker.post = function (name, msg, lparam, wparam)
	return l_tpool.post(name, msg, lparam, wparam, nil)
end


-- @brief 向lightweight线程post消息
-- @param [in] msg[string]	消息
-- @param [in] lparam[string] lparam参数
-- @param [in] wparam[string] wparam参数
-- @return [boolean] 是否成功; 失败原因为没有找到name的线程
-- @note 多线程安全
iworker.post_lightweight = function (msg, lparam, wparam)
	local idle = l_tpool.find_idle(lightweight)
	
	local ret = iworker.post(idle, msg, lparam, wparam)
	assert(ret)
	
	return ret
end

return iworker
