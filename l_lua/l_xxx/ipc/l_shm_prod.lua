--[[
-- Copyright(c) 2020, 武汉舜立软件 All Rights Reserved
-- Created: 2020/1/7
--
-- @file    l_shm_prod.lua
-- @brief   内置库require("l_shm_prod"), 多进程共享内存(生产者)
--  \n require("l_tpool")
--  \n 必须在l_tpool.init之后, l_tpool.quit之前
--  \n 运行过程中, 不可动态修改
-- @version 0.1
-- @history 修改历史
--  \n 2020/1/5 0.1 创建文件
-- @warning 没有警告
--]]

local l_shm_prod = {}


-- @brief (进程间)最大共享内存个数, 编号:[1,N]
-- @return [number] 最大共享内存个数
l_shm_prod.max = function ()
	return 8
end


-- @brief (进程间)打开共享内存
-- @param [in] index[number]	内存编号:[1,N]
-- @param [in] path[string]	路径/名称: ''
-- @param [in] size[number]	内存大小: 4K整数倍
-- @return [boolean] 是否成功
l_shm_prod.open = function (index, path, size)
	return true
	-- return false
end


-- @brief (进程间)关闭共享内存
-- @param [in] index[number]	内存编号:[1,N]
-- @return [boolean] 是否成功
l_shm_prod.close = function (index)
	return true
	-- return false
end


-- @brief 获取数据接收者: 数据处理回调函数
-- @param [in] index[number]	内存编号:[1,N]
-- @return [nil, userdata] 数据处理回调函数
l_shm_prod.get_receiver = function (index)
	return nil
	-- return void*
end


return l_shm_prod
