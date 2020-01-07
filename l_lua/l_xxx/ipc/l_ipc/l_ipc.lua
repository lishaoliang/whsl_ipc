--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_ipc.lua
-- @brief   内置库"l_ipc", IPC主框架业务
-- @version 0.1
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_ipc = {}


-- @brief 初始化
-- @return [number] 返回错误码
l_ipc.init = function ()
	return 0
	-- return 1
end


-- @brief 反初始化
l_ipc.quit = function ()
	
end


-- @brief start
-- @return [number] 返回错误码
l_ipc.start = function ()
	return 0
	-- return 
end

-- @brief stop
l_ipc.stop = function ()

end


-- @brief 获取放置媒体流接口
-- @return LUA_TLIGHTUSERDATA 轻量级指针
-- @note ptr函数的C语言原型
-- \n typedef int(*ldev_stream_cb)(int chnn, ldev_stream_id_e id, l_md_fmt_e fmt, ldev_stream_t* p_stream);
l_ipc.get_push_stream = function ()
	return ptr -- LUA_TLIGHTUSERDATA
end


-- @brief 向模块放入socket
-- @param [in]	l_socket[l_socket]	l_socket对象
-- @param [in]	id[number]			socket的id编号
-- @param [in]	proto_main[number]	主协议
-- @param [in]	proto_sub[number]	子协议
-- @return [boolean] true.成功; false.失败, 失败时调用者需要自行处理l_socket
l_ipc.push = function (l_socket, id, proto_main, proto_sub)
	return true
	-- return false
end


return l_ipc
