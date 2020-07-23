--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- brief  IPC启动入口
-- @author  李绍良
-- note
--]]
local l_sys = require("l_sys")
local l_tpool = require("l_tpool")
local imsg = require("ipc.imsg")
local iworker = require("ipc.iworker")
local mcache = require("ipc.mcache")

local l_ipc = require("l_ipc")
local l_dev = require("l_dev")

local cfg = require("ipc.cfg.cfg")

local check_env = require("ipc.env.check_env")
local check_arping = require("ipc.env.check_arping")
local phynet = require("ipc.phynet.phynet")
local cfg_setup = require("ipc.cfg_setup")

local unix = require("base.unix")
local gpio_reset = require("ipc.gpio.gpio_reset")




-- 打印基础平台信息
print('project=' .. l_sys.project)
print('version=' .. l_sys.version)
print('simulator=' .. tostring(l_sys.simulator))

print('l_dev.version=' .. l_dev.version())
print('l_dev.project=' .. l_dev.project())
print('l_dev.platform=' .. l_dev.platform())
print('l_dev.chip=' .. l_dev.chip())


--检查运行环境
check_env()


-- 初始化基础环境
mcache.init()	-- 线程之间共享数据初始化

cfg.init()		-- 初始化配置文件
imsg.init()		-- 初始化消息中心
iworker.init()	-- 初始化工作线程


-- 初始化业务模块
l_ipc.init()		-- 初始化IPC框架


-- 启动业务
l_ipc.start()		-- IPC框架启动
iworker.start()		-- 各个工作线程启动


-- 复位标记
local reset = false
gpio_reset.init()


-- 任何情况下的退出函数
local on_exit = function()
	print('system on_exit,reset=', reset)
	
	gpio_reset.quit() -- 退出gpio复位
	
	-- 关闭业务
	iworker.stop()
	l_ipc.stop()

	-- 退出业务
	l_ipc.quit()
	
	-- 基础环境
	iworker.quit()
	imsg.quit()

	if reset then
		print('system reset cfg...')
		cfg.reset()
	end
	
	-- 配置退出	
	cfg.quit()

	-- 线程等模块退出
	--l_tpool.quit()

	if reset then
		print('system reset reboot...')
		unix.shell('reboot')	-- 重启
	end
	
	print('system on_exit,over...')
	return 0
end

l_on_exit(on_exit)


-- 等待一定时间, 再生效各个模块
l_sys.sleep(1000)
cfg_setup()		-- 生效配置
--check_arping() 	-- arping一次网络, 确保网络中的mac地址对应关系ok


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
	
	-- 网络配置检查
	--phynet.check_proc(100)

	-- 检查复位

	reset = gpio_reset.check_proc(100)
	if reset then
		break -- 是复位, 则退出程序
	end
	l_sys.sleep(100)
end
