--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_dev_ipc.lua
-- @brief   内置库"l_dev_ipc", IPC硬件设备相关
-- @version 0.1
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_dev_ipc = {}


-- @brief ipc硬件设备初始化
-- @return [number] 返回错误码
l_dev_ipc.init = function ()
	return 0
	-- return 1
end


-- @brief ipc硬件设备反初始化
l_dev_ipc.quit = function ()
	
end


-- @brief ipc硬件start
-- @return [number] 返回错误码
l_dev_ipc.start = function ()
	return 0
	-- return 1
end

-- @brief ipc硬件stop
l_dev_ipc.stop = function ()

end


-- @brief 添加码流监听
-- @param [in] name[string] 名称
-- @param [in] ptr[LUA_TLIGHTUSERDATA] 轻量级指针
-- @note ptr函数的C语言原型
-- \n typedef int(*ldev_stream_cb)(int chnn, ldev_stream_id_e id, l_md_fmt_e fmt, ldev_stream_t* p_stream);
l_dev_ipc.add_listener = function (name, ptr)

end

return l_dev_ipc
