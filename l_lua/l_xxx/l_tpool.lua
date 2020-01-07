--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_tpool.lua
-- @brief   扩展库require("l_tpool"), 提供线程池支持
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_tpool = {}


-- @brief l_tpool 模块初始化
-- @param [in]	ht_size[number]		(可选)hash table 大小(默认4096, 最小100)
--  \n 非线程安全
l_tpool.init = function (ht_size)

end

-- @brief l_tpool 模块退出
--  \n 非线程安全
l_tpool.quit = function ()

end


-- @brief 创建名称为name的线程
-- @param [in] name[string] 线程名称
-- @param [in] tc_sleep[number]	线程休眠时间[毫秒]; 最小1毫秒
-- @param [in] loader_path[string] 加载lua入口文件
-- @param [in] param[string] 传递给新lua环境的参数
-- @param [in] cb_loader[userdata] 函数lua_env_loader_cb, 用于使用自定义加载函数
-- @return [boolean] 是否成功; 失败原因为没有找到name的线程
-- @note 非线程安全
-- \n 必须在使用前, 将所有线程创建好
l_tpool.create = function (name, tc_sleep, loader_path, param, cb_loader)
	return true
	--return false
end


-- @brief 向名称为name的线程post消息
-- @param [in] name[string] 线程名称
-- @return [boolean] 是否成功; 失败原因为没有找到name的线程
-- @note 非线程安全
l_tpool.destroy = function (name)
	return true
	--return false
end


-- @brief 向名称为name的线程post消息
-- @param [in] name[string] 线程名称
-- @param [in] msg[string]	消息
-- @param [in] lparam[string] lparam参数
-- @param [in] wparam[string] wparam参数
-- @param [in] cobj[userdata] c对象指针
-- @return [boolean] 是否成功; 失败原因为没有找到name的线程
l_tpool.post = function (name, msg, lparam, wparam, cobj)
	return true
	-- return false
end


-- @brief 从一组名称中找到, 相对空闲的线程
-- @param [in] t[table] 线程名称数组
-- @return [string] 是否成功; 失败原因为没有找到name的线程
-- @note 
--  \n t = {'aaa', 'bbb', 'ccc', 'ddd'} 的形式
l_tpool.find_idle = function (t)
	return ''
	-- return 'aaa'
end


-- @brief 创建名称为name的线程
-- @param [in] name[string] 线程名称
-- @param [in] tc_sleep[number]	线程休眠时间[毫秒]; 最小1毫秒
-- @param [in] loader_path[string] 加载lua入口文件
-- @param [in] param[string] 传递给新lua环境的参数
-- @param [in] cb_loader[userdata] 函数lua_env_loader_cb, 用于使用自定义加载函数
-- @return [userdata] 完全userdata
-- @note 创建由Lua托管, 接受GC管理的线程
--  \n 此函数无需 l_tpool.init, 不接受l_tpool全局模块管理
--  \n 只能通过返回的userdata来访问线程
l_tpool.open_thread = function (name, tc_sleep, loader_path, param, cb_loader)
	return l_tpool_thread
end


return l_tpool
