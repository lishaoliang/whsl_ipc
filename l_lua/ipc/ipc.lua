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
local inet = require("ipc.inet")
local mcache = require("ipc.mcache")

local l_dev_ipc = require("l_dev_ipc")
local cfg = require("ipc.cfg.cfg")

local check_env = require("ipc.env.check_env")
local check_arping = require("ipc.env.check_arping")
local phynet = require("ipc.phynet.phynet")
local cfg_setup = require("ipc.cfg_setup")

local unix = require("base.unix")
local gpio_reset = require("ipc.gpio.gpio_reset")

-- 打印基础平台信息
print('platform=' .. l_sys.platform)
print('chip=' .. l_sys.chip)
print('version=' .. l_sys.version)


--检查运行环境
check_env()


-- 初始化基础环境
l_tpool.init()	-- 线程等模块初始化
mcache.init()	-- 线程之间共享数据初始化

cfg.init()		-- 初始化配置文件
imsg.init()		-- 初始化消息中心
iworker.init()	-- 初始化工作线程


-- 第一次加载网络配置
phynet.setup()
phynet.check_proc(1000)


-- 初始化业务模块
inet.init()			-- 网络模块初始化
l_dev_ipc.init()	-- 海思硬件模块初始化：mpp系统初始化


-- 设置媒体流监听，让网络模块能获取到音视频、图片流
l_dev_ipc.add_listener('my ipc', inet.get_listener())


-- 启动业务
inet.start()		-- 网络模块启动
l_dev_ipc.start()	-- 海思硬件模块启动
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
	l_dev_ipc.stop()
	inet.stop()

	-- 退出业务
	l_dev_ipc.quit()
	inet.quit()
	
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
	l_tpool.quit()

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
check_arping() 	-- arping一次网络, 确保网络中的mac地址对应关系ok


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
	phynet.check_proc(100)

	-- 检查复位

	reset = gpio_reset.check_proc(100)
	if reset then
		break -- 是复位, 则退出程序
	end
	l_sys.sleep(100)
end
