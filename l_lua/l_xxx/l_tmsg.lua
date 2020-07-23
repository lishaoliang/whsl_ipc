--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_tmsg.lua
-- @brief   扩展库require("l_tmsg"), Lua各个线程之间的文本消息通信
--  \n require("l_tpool")
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_tmsg = {}


-- @brief l_tmsg 模块初始化
--  \n 非多线程完全
--l_tmsg.init = function ()
--
--end

-- @brief l_tmsg 模块退出
--  \n 非多线程完全
--l_tmsg.quit = function ()
--
--end

-- @brief l_tmsg注册消息队列
-- @param [in] name[string] 消息队列名称
-- @return [boolean] 是否成功
-- @note 必须在l_tpool.init函数之后, post/get/clear等函数之前完成所有消息队列的注册
--  \n 非多线程完全
l_tmsg.register = function (name)
	return true
	-- return false
end


-- @brief 向名称为name的消息队列post消息
-- @param [in] name[string] 消息队列名称
-- @param [in] msg[string]	消息
-- @param [in] lparam[string] lparam参数
-- @param [in] wparam[string] wparam参数
-- @param [in] cobj[userdata] c对象指针
-- @return [boolean] 是否成功; 失败原因为没有找到name的队列
-- @note 多线程完全
l_tmsg.post = function (name, msg, lparam, wparam, cobj)
	return true
	-- return false
end

-- @brief 从名称为name的消息队列中获取消息
-- @param [in] name[string] 消息队列名称
-- @return	ret[boolean] 	true表示有数据
--  \n		msg[string]		消息
--  \n		lparam[string]	lparam参数
--  \n		wparam[string]	wparam参数
--  \n 		cobj[userdata]	c对象指针
-- @note 多线程完全
l_tmsg.get = function (name)
	return true, msg, lparam, wparam, cobj
	-- return false, '', '', '', NULL
end

-- @brief 清空名称为name的队列中的所有消息
-- @param [in] name[string] 消息队列名称
-- @return [boolean] 是否成功; 失败原因为没有找到name的队列
-- @note 多线程完全
-- \n 注意如果压入的数据含有C对象, C对象将不会被释放
l_tmsg.clear = function (name)
	return true
	-- return false
end


return l_tmsg
