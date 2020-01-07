--[[
-- Copyright (c) 2019 武汉舜立软件, All Rights Reserved
-- Created: 2019/11/15
--
-- @brief	测试登录/登出设备
-- @author	李绍良
-- @see https://github.com/lishaoliang/l_sdk_doc/blob/master/protocol/auth.md
--]]
local l_sys = require("l_sys")
local l_lif = require("l_lif")


local target = require("demo.target")
local to_json =  require("demo.to_json")
local login = require("demo.login")


-- sdk初始化
l_lif.init('')


-- 登录到设备
local err = login(target.protocol, target.ip, target.port, target.path_local, target.username, target.passwd)


-- 打印登录结果
if 0 ~= err then
	print('login error!'.. 'err=' .. err,  target.protocol, target.username .. '@' .. target.ip .. ':'..target.port .. ' -p ' .. target.passwd)
else	
	print('login ok!', target.protocol, target.username .. '@' .. target.ip .. ':'..target.port)
end


local support = {
	cmd = 'support',
	--llssid = '123456',
	--llauth = '123456'
}

local ret, res = l_lif.request(to_json(support))
print('request support, ret='..ret, 'res='..res)


-- 休眠3S
l_sys.sleep(3000)


-- 登出
l_lif.logout()


-- sdk退出
l_lif.quit()
