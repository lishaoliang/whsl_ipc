--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- brief  LUA模块加载入口, 注意本文件的精简, 将各个模块初始化动作放在各自模块
-- @author  李绍良
-- note 1.本文件头引用必须为内置模块!
--		2.第一.加载本文件, C部分并未完全准备好,不得胡乱引用头文件
--      3.第二.调用setup函数, 仅可以调用配置函数 及 设置各个模块参数
--      4.第三.调用init函数, C部分完全准好了, 可以调用所有接口
--      5.第四.软件主生命期
--      6.第五.软件退出时,调用quit函数,清理lua部分资源
--]]
require("ipc.G")


-- @brief 初始加载配置
-- @return [number] 0.成功; 非0.失败
-- @note 因系统并未完全启动, 只可以做配置相关动作
setup = function ()
	
	G.cfg = require("ipc.cfg.cfg") -- 配置模块
	--G.cfg.setup()
	
	return 0
end


-- @global 初始加载配置
-- @return [number] 0.成功; 非0.失败
-- @note 因系统并未完全启动, 只可以做配置相关动作
init = function ()

	G.user = require("ipc.auth.user")
	G.user.setup()	
	
	-- 配置 http server
	G.http_ser = require("ipc.nsm.http_ser")
	G.http_ser.setup()

	G.nsm_ser = require("ipc.nsm.nsm_ser")
	G.nsm_ser.setup()

	-- debug
	--local util_ex = require("base.util_ex")
	--util_ex.printf("http_ser", http_ser)
	--util_ex.printf("l_http", l_http)
	--util_ex.printf("s_http", s_http)
	
	return 0
end

-- @global 初始加载配置
-- @return [number] 0.成功; 非0.失败
-- @note 因系统并未完全启动, 只可以做配置相关动作
quit = function ()
	
	-- 退出, 释放引用即可
	G.nsm_ser = nil
	G.http_ser = nil
	G.user = nil
	G.cfg = nil

	return 0
end
