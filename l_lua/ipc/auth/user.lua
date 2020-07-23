--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- Created: 2018/12/21
--
-- @file    user.lua
-- @brief   用户权限
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]
local l_sys = require("l_sys")

local np_err = require("base.np_err")

local user = {}


-- @variable 默认连接超时,12小时
local timeout = 1000 * 3600 * 12


-- @variable 所有会话
local session = {}


-- @brief 用户登录
-- @param [in] lg[table] 登录信息
-- @return [boolean][string][string]是否成功
-- @note 长连接断开, 自动注销;通过心跳保持登录状态 
--  \n 登录信息形如
--  \n username = 'xxxx'
--  \n passwd = 'xxxx'
user.login = function (lg)
	--if 'table' ~= lg then
	--	return false, '', ''
	--end	
	
	--local username = lg['username']
	--local passwd = lg['passwd']
	
	local llssid = l_sys.rand_char(12)
	local llauth = l_sys.rand_char(16)

	while true do
		if nil == session[llssid] then
			break
		end	
		
		llssid = l_sys.rand_char(12)
	end
	
	--session[llssid] = {
	--	llauth = llauth,
	--	tc = timeout
	--}
	
	return np_err.OK, llssid, llauth
end

user.logout = function (llssid, llauth)
	--local v = session[llssid]
	
	--if nil ~= v and llauth == v.llauth then
	--	session[llssid] = nil
	--end
end


-- @brief 定时器
-- @param [in] id[number] 定时器id
-- @param [in] count[number] 第几次回调(从1开始计数,超过int型之后回到1)
-- @param [in] interval[number] 定时调用的时间间隔
-- @param [in] tc[number] 当前时间
-- @param [in] last_tc[number] 上一次回调的时间
-- @return 0.表示继续定会器; 非0.删除定时器
local on_timer = function (id, count, interval, tc, last_tc)

	return 0
end

-- @brief 用户模块初始设置
-- @return 无
user.setup = function ()
	
	
	
	-- 添加定时器
	local ret = l_sys.add_timer(999, 1000, on_timer)
	--local ret = l_sys.add_timer(999, 60000, on_timer)
	assert(ret)
end

return user
