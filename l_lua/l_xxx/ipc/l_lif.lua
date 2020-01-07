--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/11/15
--
-- @file    libl_lif.so
-- @brief   本地协议接口; 本文件模拟描述libl_lif.so导出lua接口类
-- @version 0.1
-- @author  李绍良
--]]

local l_lif = {}



-- @brief 初始化sdk
-- @param [in] cfg[string]	json字符串 
-- @return [number] 0.成功; 非0.错误码
l_lif.init = function (cfg)
	return 0
end


-- @brief 退出sdk
l_lif.quit = function ()
	
end


-- @brief 登录设备
-- @param [in] param[string]	json字符串 
-- @return [number] err			错误码
l_lif.login = function (param)
	return err
end


-- @brief 登出设备
-- @return [number] err 错误码
l_lif.logout = function ()
	return err
end


-- @brief 请求数据
-- @param [in] str_req[string]	请求json字符串
-- @return err[number] 错误码
-- @return str_res[string] err=0时,从服务端回复的数据
l_lif.request = function (str_req)
	return err, str_res
end


return l_lif
