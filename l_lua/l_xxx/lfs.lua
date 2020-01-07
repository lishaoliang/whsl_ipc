--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/28
--
-- @file    lfs.lua
-- @brief   内置库 require("lfs"), 文件系统目录操作
-- @version 2.0
-- @author  Kepler
--  \n 源码地址: http://keplerproject.github.io/luafilesystem
--  \n 官方手册: http://math2.org/luasearch/lfs.html#reference
-- @history 修改历史
--  \n 2019/4/28 0.1 创建文件
-- @warning 没有警告
--]]

local lfs = {}


-- \n number
-- \n string
-- \n boolean
-- \n function
-- \n table
-- \n userdata(lightuserdata)

-- @brief 函数描述
-- @param [in]  	xxx[string]	输入参数
-- @param [out]		xxx[table]	输出参数
-- @param [in,out]	xxx[table]	输入输出参数
-- @param [in]		x_xx[function] 如果有回调函数, 必须标明在see中标明原型
-- @return [nil, table] [boolean] 几个返回值集合
-- @note 注意事项,参见xxx
-- @see [string][table] = x_xx(string, string, table)


lfs.attributes = function (filepath)

end


-- @brief 变更当前目录
-- @param [in]	path[string]	目录
-- @return [nil, boolean]	是否成功
--  \n err_str[string]		返回nil时的错误提示
-- @note 函数返回值可能为1个 或 2个, 注意使用
lfs.chdir = function (path)
	return true
	-- return false
	-- return nil 'Unable to change working directory'
end


-- @brief 获取当前目录
-- @return [string]		当前目录
--  \n err_str[string]	错误码提示串
--  \n errno[number]	错误码
-- @note 函数返回值可能为1个 或 2个, 注意使用
lfs.currentdir = function ()
	return ''
	-- return nil, 'strerror(errno)', errno
end


-- @brief 遍历目录
lfs.dir = function (path)
	
end



lfs.link = function ()

end


lfs.lock = function ()

end


lfs.lock_dir = function ()

end


-- @brief 创建目录
-- @param [in]	path[string]	目录
-- @return [nil true]
-- @note 只创建一层目录; 并未递归创建目录
lfs.mkdir = function (path)
	return 0
end


-- @brief 删除目录
-- @param [in]	path[string]	目录
-- @return [nil true]
lfs.rmdir = function (path)
	return true
end


lfs.setmode = function ()

end

lfs.symlinkattributes = function ()

end


lfs.touch = function (filepath)

end

lfs.unlock = function ()

end

return lfs
