--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/04/26
--
-- @file    l_pack_w.lua
-- @brief   扩展库require("l_pack_w"), 打包
-- @version 0.1
-- @history 修改历史
--  \n 2019/04/26 0.1 创建文件
-- @warning 没有警告
--]]

local l_pack_w = {}


-- @brief 打开一个包对象(写数据, 使用'wb'方式打开文件)
-- @param [in]	path_name[string]	包路径名
-- @param [in]	offset[number]		[可选,默认0]文件起始偏移
-- @return [nil, l_pack_w] 写入包对象lpkf_w
l_pack_w.open = function (path_name, offset)
	return lpkf_w
	-- return nil
end


-- @brief 关闭写入包对象lpkf_w
-- @param [in]	lpkf_w[l_pack_w]	写入包对象lpkf_w
-- @return 无
-- @note 关闭文件时, 将索引信息,文件头等写入到目标包中
l_pack_w.close = function (lpkf_w)
	return
end


-- @brief 设置秘钥信息
-- @param [in]	lpkf_w[l_pack_w]	写入包对象lpkf_w
-- @param [in]	key[string]			秘钥信息[1,1024]
-- @return [boolean] true.成功; false.失败
-- @note 必须在 open之后, add之前设置
l_pack_w.enc = function (lpkf_w, key)
	return true
end



-- @brief 添加文件到写入包对象lpkf_w
-- @param [in]	lpkf_w[l_pack_w]	写入包对象lpkf_w
-- @param [in]	key_path[string]	关键字: 例如'/opt/aaa.lua'
-- @param [in]	path_name[string]	待添加的文件路径名
-- @return [number] 0.失败; 大于0.添加文件的大小
l_pack_w.add = function (lpkf_w, key_path, path_name)
	return 0
end


return l_pack_w
