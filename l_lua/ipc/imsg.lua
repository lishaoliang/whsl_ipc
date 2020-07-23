--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- Created: 2018/12/21
--
-- @file    imsg.lua
-- @brief   IPC全局消息通道定义; 支持跨Lua线程访问
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]
local l_tpool = require("l_tpool")
local l_tmsg = require("l_tmsg")

local imsg = {}

-- @name   imsg.update_phynet
-- @export 更新物理网口信息的消息队列
imsg.update_phynet = 'update_phynet'


-- @name   imsg.update_nsm
-- @export 更新nsm信息的消息队列
imsg.update_nsm = 'update_nsm'


-- @brief imsg 模块初始化
--  \n 非多线程完全
--  \n 必须全局使用, 注意由主Lua线程调用
imsg.init = function ()

	for k, v in pairs(imsg) do
		if 'string' == type(v) then
			print('lua imsg register name:', v)
			local ret = l_tmsg.register(v)
			assert(ret)
		end
	end
end


-- @brief imsg 模块退出
--  \n 非多线程完全
--  \n 必须全局使用, 注意由主Lua线程调用
imsg.quit = function ()

end


-- @brief 向名称为name的消息队列post消息
-- @param [in] name[string] 消息队列名称
-- @param [in] msg[string]	消息
-- @param [in] lparam[string] lparam参数
-- @param [in] wparam[string] wparam参数
-- @return [boolean] 是否成功; 失败原因为没有找到name的队列
-- @note 多线程安全
imsg.post = function (name, msg, lparam, wparam)
	return l_tmsg.post(name, msg, lparam, wparam, nil)
end


-- @brief 从名称为name的消息队列中获取消息
-- @param [in] name[string] 消息队列名称
-- @return	ret[boolean] 	true表示有数据
--  \n		msg[string]		消息
--  \n		lparam[string]	lparam参数
--  \n		wparam[string]	wparam参数
--  \n 		cobj[userdata]	c对象指针
-- @note 多线程安全
imsg.get = function (name)
	local ret, msg, lparam, wparam, cobj= l_tmsg.get(name)	
	return ret, msg, lparam, wparam
end


-- test
--[[
imsg.init()
for i = 1, 10 do
	imsg.post(imsg.update_wifi, 'msg wifi', 'wifi lparam', 'wifi wparam')
end
for i = 1, 5 do
	print(imsg.get(imsg.update_wifi))
end
imsg.quit()
--]]

return imsg
