--[[
-- Copyright (c) 2019 武汉舜立软件, All Rights Reserved
-- Created: 2019/11/15
--
-- @brief	目标测试设备信息
-- @author	李绍良
-- @see https://github.com/lishaoliang/l_sdk_doc
--]]

local target = {}
local l_sys = require("l_sys")



-- @name   target.ip
-- @export 目标IP地址
--target.ip = '192.168.1.247'
target.ip = '192.168.3.150'


-- @name   target.port
-- @export 目标端口
target.port = 80


-- @name   target.protocol
-- @export 使用的协议
target.protocol = 'nspp'
if l_sys.simulator then
	target.protocol = 'nspp_local'	-- 如果是在相机上测试, 则使用本地协议
end


-- @name   target.path_local
-- @export 本地unix协议连接路径
target.path_local = '/nfsmem/socket.ui'


-- @name   target.username
-- @export 用户名
target.username = 'admin'


-- @name   target.passwd
-- @export 密码
target.passwd = '123456'


-- @name   target.wifi_ssid
-- @export 相机处于STA模式下,待连接的目标wifi的ssid名称
target.wifi_ssid = 'HUAWEI-7NLNPF_5G'


-- @name   target.wifi_passwd
-- @export 相机处于STA模式下,待连接的目标wifi的密码
target.wifi_passwd = 'qwertyuiop1234567890'



return target
