--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/04/26
--
-- @file    l_pack.lua
-- @brief   扩展库require("l_pack"), 解包
-- @version 0.1
-- @history 修改历史
--  \n 2019/04/26 0.1 创建文件
-- @warning 没有警告
--]]

local l_pack = {}


-- @brief 校验包是否OK
-- @param [in]	path_name[string]	包路径名
-- @param [in]	offset[number]		[可选,默认0]文件起始偏移
-- @return [boolean] true.通过校验; false.未通过校验
l_pack.check = function (path_name, offset)
	return true
	-- return false
end


-- @brief 打开一个包对象(写数据, 使用'rb'方式打开文件)
-- @param [in]	path_name[string]	包路径名
-- @param [in]	offset[number]		[可选,默认0]文件起始偏移
-- @return [nil, l_pack] 读取包对象lpkf_r
l_pack.open = function (path_name, offset)
	return lpkf_r
	-- return nil
end


-- @brief 关闭包对象lpkf_r
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return 无
l_pack.close = function (lpkf_r)
	return
end


-- @brief 获取包对象lpkf_r的秘钥信息
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return [string]	秘钥信息. ''为没有
l_pack.enc = function (lpkf_r)
	return ''
end


-- @brief 获取包对象中文件数目
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return [number] 文件数目
l_pack.size = function (lpkf_r)
	return 0
end


-- @brief 获取包对象中文件具体信息
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return [table] 文件具体信息
--  \n 返回值示例:
--  \n {
--  \n   {'path':'/opt/aaa.lua','filelen':1024},
--  \n   {'path':'/opt/bbb.lua','filelen':547},
--  \n }
l_pack.files = function (lpkf_r)
	return {}
end


-- @brief 在包中搜索路径
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @param [in]	path[string]	路径名,例如'/opt/aaa.lua'
-- @return [boolean] true.搜索到数据; false.未搜索到数据
-- @note 迭代子操作
l_pack.iter_search = function (lpkf_r, path)
	return true
	--return false
end


-- @brief 定位到开始
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return [boolean] true.有数据; false.无数据了
-- @note 迭代子操作
l_pack.iter_begin = function (lpkf_r)
	return true
	--return false
end


-- @brief 下一个
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return [boolean] true.有数据; false.无数据了
-- @note 迭代子操作
l_pack.iter_next = function (lpkf_r)
	return true
	--return false
end


-- @brief 获取当前(迭代子)路径
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return [string] 路径
-- @note 迭代子操作
l_pack.iter_path = function (lpkf_r)
	return '/opt/aaa.lua'
end


-- @brief 获取当前(迭代子)文件大小
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @return [number] 文件大小
-- @note 迭代子操作
l_pack.iter_filelen = function (lpkf_r)
	return 1024
end


-- @brief 读取当前(迭代子)数据
-- @param [in]	lpkf_r[l_pack]	包对象lpkf_r
-- @param [in]	offset[number]	偏移位置
-- @param [in]	buf_max[number]	[可选,默认32K]最大缓存; range:[4K, 4M]
-- @return [nil, l_buf]	l_buf缓存对象
--  \n  size[number]	读取数据大小
-- @note 迭代子操作
l_pack.iter_read = function (lpkf_r, offset, buf_max)
	return l_buf, 1024
	-- return nil, 0
end


return l_pack
