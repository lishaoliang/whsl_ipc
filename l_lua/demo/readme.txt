--[[
-- 测试文档简要说明
-- 用于:
--   1.测试相机本地协议接口,
--   2.测试单个*.so模块
--

一. 目录结构
	.
	
	./base				-- 公用基础脚本
	./ipc				-- 相机程序主脚本
	./upgrade			-- 升级程序主脚本

	./demo				-- 测试脚本目录
		readme.txt		-- 说明文件
		target.lua		-- 测试目标设备信息: IP地址,登录信息,wifi信息
		
		author.lua		-- lua脚本规范
		login.lua		-- 封装通用登录
		to_json.lua		-- 封装将lua的table转换为json文本
	
	
	./demo/lif			-- 测试本地协议
		t_base.lua		-- 测试获取设备基础信息: 例如设备名称
		t_login.lua		-- 测试登录到设备
		

二. 确认测试目标信息, 打开文件 ./demo/target.lua
	1. (模拟器)目标IP地址: target.ip
	2. (模拟器)目标端口: target.port
	3. 需要连接WIFI的路由器名称: target.wifi_ssid
	4. 需要连接WIFI的路由器密码: target.wifi_passwd


三. 将命令行切换到当前目录, 并确保串口命令可以加载*.so文件
	cd /opt
	export LD_LIBRARY_PATH='/usr/local/lib:/usr/lib:/qt_lib:/nfsmem:/opt:'
	

五. 测试登录到设备, 执行命令: llua.exe ./demo/nspp/t_login.lua
	将会看到如下打印:
	login ok!id=1000        admin@192.168.3.218:80

--]]
