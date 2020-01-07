--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_tpool_thread.lua
-- @brief   由l_tpool.open_thread()函数创建完全userdata
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_tpool_thread = {}


-- @brief 关闭线程
l_tpool_thread:close = function ()

end


-- @brief 向线程post消息
-- @param [in] msg[string]	消息
-- @param [in] lparam[string] lparam参数
-- @param [in] wparam[string] wparam参数
-- @param [in] cobj[userdata] c对象指针
-- @return [boolean] 是否成功; 失败原因为线程已经close
l_tpool_thread:post = function (msg, lparam, wparam, cobj)
	return true
	-- return false
end


-- @brief 获取线程名称
-- @return [string] 返回字符串
l_tpool_thread:name = function ()
	return 'aaa'
end

-- @brief 获取线程运行状态
-- @return [string] 'run' 或 'close'
l_tpool_thread:status = function ()
	return 'run'
	-- return 'close'
end

-- @brief 获取线程的任务数目
-- @return ret[boolean] true:表示线程在运行; false:表示线程close了
-- \n 		num[number]	如果为true,则表示当前执行的任务数目
l_tpool_thread:job_size = function ()
	return false, 0
	--return true, 1
end


return l_tpool_thread
