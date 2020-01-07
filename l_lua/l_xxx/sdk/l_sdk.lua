--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_sdk.lua
-- @brief   作为动态库扩展"l_sdk", 函数说明
-- @version 0.1
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_sdk = {}



-- @brief 初始化sdk
-- @param [in] cfg[string]	json字符串 
-- @return [number] 0.成功; 非0.错误码
l_sdk.init = function (cfg)
	return 0
end


-- @brief 退出sdk
l_sdk.quit = function ()
	
end


-- @brief 登录设备
-- @param [in] param[string]	json字符串 
-- @return [number] err			错误码
-- @return [number] id			err=0时, 有效的登录id
l_sdk.login = function (param)
	return err, id
end


-- @brief 登出设备
-- @param [in] id[number]	登录id
-- @return [number] err 错误码
l_sdk.logout = function (id)
	return err
end


-- @brief 请求数据
-- @param [in] id[number]	登录id
-- @param [in] str_req[string]	请求json字符串
-- @return err[number] 错误码
-- @return str_res[string] err=0时,从服务端回复的数据
l_sdk.request = function (id, str_req)
	return err, str_res
end


-- @brief 打开网络发现服务
-- @return err[number] 错误码
l_sdk.discover_open = function (param)
	return 0
end


-- @brief 关闭网络发现服务
-- @return err[number] 错误码
l_sdk.discover_close = function ()
	return 0
end

-- @brief 打开/关闭搜索
-- @param [in] b_open[boolean]	true: 打开搜索; false: 关闭搜索
-- @return err[number] 错误码
l_sdk.discover_run = function (b_open)
	return 0
end


-- @brief 获取局域网络设备
-- @return devs[string] 设备的json数组
-- @note 前提条件为: discover_open(), discover_run(true)
l_sdk.discover_get_devs = function ()
	return '{}'
end


-- @brief 组播请求
-- @param [in] str_req[string]	请求的json字符串
-- @return err[number] 错误码
--  \ncm	str_res[string] err=0时,从服务端回复的数据
-- @note 前提条件为: discover_open()
l_sdk.discover_request = function (str_req)
	return err, str_res
end


return l_sdk
