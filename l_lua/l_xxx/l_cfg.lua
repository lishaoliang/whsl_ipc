--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_cfg.lua
-- @brief   内置库require("l_cfg"), 函数说明
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_cfg = {}



-- @brief 配置文件初始化
-- @param [in] version[string] 版本信息(0,15],形如"v1.0.0"
-- @return [boolean] 返回是否成功
l_cfg.init = function (version)
	return true
	-- return false
end

-- @brief 配置文件退出
l_cfg.quit = function ()
	return
end


-- @brief 配置文件是否正常
-- @return [boolean] 返回是否正常
-- @note 返回false, 则需要修复配置文件
l_cfg.is_ok = function ()
	return true
	-- return false
end


-- @brief 获取旧配置值
-- @param [in] key[string] 配置的key字符串(0,255]
-- @return [string] 返回得到的配置值或者空字符串
l_cfg.get_old = function(key)
	return ''	
end


-- @brief 获取当前配置值
-- @param [in] key[string] 配置的key字符串(0,255]
-- @return [string] 返回得到的配置值或者空字符串
l_cfg.get = function(key)
	return ''
end


-- @brief 设置配置
-- @param [in] key[string] 配置的key字符串(0,255]
-- @param [in] v[string] 配置的v字符串(0,128K]
-- @return [boolean] 设置是否成功
l_cfg.set = function(key, v)
	return ''
end


-- @brief 复位配置: 只复位内存中的数据, 并不保存文件
-- @return [boolean] 复位是否成功
l_cfg.reset = function()
	return true
end


-- @brief 保存配置(立即写文件)
-- @return [boolean] 保存是否成功
l_cfg.save = function()
	return true
end


return l_cfg
