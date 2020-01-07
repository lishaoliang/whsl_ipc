--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/04/12
--
-- @file    l_discover.lua
-- @brief   内置库"l_discover", 网络发现
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/12 创建文件
-- @warning 没有警告
--]]

local l_discover = {}


-- @brief 初始化网络发现模块
-- @return [number] 0.成功; 非0.错误码
l_discover.init = function ()
	return 0
end


-- @brief 退出网络发现模块
l_discover.quit = function ()

end


-- @brief 启动网络发现业务线程
-- @return [number] 0.成功; 非0.错误码
l_discover.start = function ()
	return 0
end


-- @brief 关闭网络发现业务线程
l_discover.stop = function ()

end


return l_discover
