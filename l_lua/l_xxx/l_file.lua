--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/4/23
--
-- @file    l_file.lua
-- @brief   内置库 require("l_file"), 提供二进制文件读写
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/4/23 0.1 创建文件
-- @warning 没有警告
--]]

local l_file = {}


-- @brief 打开文件
-- @param [in]	file_path[string]	文件路径
-- @param [in]	wrb[string]			打开方式: 'wb', 'rb', 'rb+'
-- @return [nil, l_file] nil.打开失败; 非nil.打开成功
l_file.open = function (file_path, wrb)
	return nil
	-- return l_file
end

-- @brief 关闭文件
-- @param [in]	file[l_file]	文件对象
-- @return 无
l_file.close = function (file)
	return
end

-- @brief 定位文件
-- @param [in]	file[l_file]	文件对象
-- @param [in]	offset[number]	输出参数
-- @param [in]	origin[string]	定位方式: 'seek_set', 'seek_cur', 'seek_end'
-- @return [boolean] true.成功; false.失败
-- @note
--  \n 'seek_set' : 从文件开头
--  \n 'seek_cur' : 从当前位置
--  \n 'seek_end' : 从文件末尾反向
l_file.seek = function (file, offset, origin)
	return true
end


-- @brief 获取当前文件位置
-- @param [in]	file[l_file]	文件对象
-- @return [number] 返回文件位置
l_file.tell = function(file)
	return 0
end


-- @brief 读取二进制数据
-- @param [in]	file[l_file]	文件对象
-- @param [in]	size[number]	(可选)读取大小: 默认32K
-- @return [nil, l_buf] nil.没有读取数据或文件结束; l_buf读到的数据缓存
--  \n size[number]		读到的数据大小
l_file.read = function (file, size)
	return nil, 0
	-- return l_buf, 30 * 1024
end

-- @brief 向文件写入缓存数据
-- @param [in]	file[l_file]	文件对象
-- @param [in]	buf[l_buf]		缓存对象
-- @return [boolean] true.成功; false.失败
--  \n 		size[number]		写入的数据大小
l_file.write = function (file, buf)
	return false, 0
	-- return true, 30 * 1024
end

-- @brief 同步file文件系统缓存
-- @param [in]	file[l_file]	文件对象
-- @return 无
l_file.flush = function (file)
	return 
end

return l_file
