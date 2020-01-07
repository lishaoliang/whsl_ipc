--[[
-- Copyright (c) 2019 武汉舜立软件, All Rights Reserved
-- Created: 2019/11/15
--
-- @brief	登录到设备
-- @author	李绍良
-- @see https://github.com/lishaoliang/l_sdk_doc
--]]
local l_lif = require("l_lif")
local to_json =  require("demo.to_json")


-- @brief 登录到设备
-- @param [in]  	ip[string]			设备ip
-- @param [in]		port[number]		端口
-- @param [in]		username[string]	用户名
-- @param [in]		passwd[string]		密码
-- @return err_id[number]	 0.成功; 非0.错误码
--	\n		login_id[number] 登录成功之后的登录id	
-- @see https://github.com/lishaoliang/l_sdk_doc/blob/master/protocol/auth.md
--  \n 'err_id'错误码: https://github.com/lishaoliang/l_sdk_doc/blob/master/protocol/net_err.md
local login = function (protocol, ip, port, path, username, passwd)
	local req = {
		cmd  = 'login',
		
		protocol = 20,--protocol, -- 'nspp', 'nspp_local'	
		ip = ip,
		port = port,
		path = path,
		
		login = {
			username = username,
			passwd = passwd
		}
	}
	
	local json = to_json(req)
	--print('login json:', json)
	
	local err_id = l_lif.login(json)
	
	return err_id
end

return login
