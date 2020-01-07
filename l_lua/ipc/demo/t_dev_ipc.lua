--[[
-- @file	t_dev_ipc.lua
-- @brief	单独测试 libl_dev_ipc.so 接口
--]]
local l_sys = require("l_sys")
local l_dev_ipc = require("l_dev_ipc")



-- 打印基础平台信息
print('platform=' .. l_sys.platform)
print('chip=' .. l_sys.chip)
print('version=' .. l_sys.version)


-- 加载驱动
local path_driver = 'ipc.driver.' .. l_sys.chip .. '_driver'
local hi_driver = require(path_driver)
hi_driver.load()



l_dev_ipc.init()	-- 海思硬件模块初始化：mpp系统初始化
l_dev_ipc.start()	-- 海思硬件模块启动


-- 任何情况下的退出函数
local on_exit = function()
	-- 关闭业务
	l_dev_ipc.stop()
	l_dev_ipc.quit()
	
	hi_driver.unload()
	
	return 0
end

l_on_exit(on_exit)



-- 等待一定时间, 再生效各个模块
l_sys.sleep(1000)



-- 执行一次lua内存回收
collectgarbage('collect')

local tc_collect = 0
local count = 1000
while 0 < count do
	--count = count - 1

	-- 定期执行lua内存回收
	tc_collect = tc_collect + 100
	if 10000 < tc_collect then
		tc_collect = 0
		collectgarbage('collect')
	end

	l_sys.sleep(100)
end
