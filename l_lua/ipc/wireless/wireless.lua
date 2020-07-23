--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    wireless.lua
-- @brief   wifi网络接口封装
-- @version 0.1
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]
local l_sys =  require("l_sys")
local util = require("base.util")
local cjson  = require("cjson")
local util_ex = require("base.util_ex")

local imsg = require("ipc.imsg")


local l_wireless = nil
if 'win' ~= l_sys.platform then
	l_wireless = require("l_wireless")	-- 模拟软件不用加载
end

local wireless = {}

-- 检查时间间隔 10S~60S
local time_interval = 30000 -- 计数单位毫秒[ms]

-- 上一次检查的时间点
local check_tc = 0

local cfg = {
	mode = 'ap', -- 'ap', 'sta'
	
	ssid = '',
	passwd = '',
	
	dhcp = true,
	ip = '',
	netmask = '',
	gateway = ''
}


wireless.set_ap = function ()
	cfg.mode = 'ap'
	
	print('wireless set:', cfg.mode, cfg.ssid, cfg.passwd)
end

wireless.set_sta = function (ssid, passwd, dhcp, ip, netmask, gateway)
	
	cfg.mode = 'sta'

	cfg.ssid = ssid
	cfg.passwd = passwd

	cfg.dhcp = true
	
	print('wireless set:', cfg.mode, cfg.ssid, cfg.passwd)
	print('wireless set:', cfg.dhcp, cfg.ip, cfg.netmask, cfg.gateway)
	
end


wireless.setup = function (cf)
	-- cf 的结构参见 ipc.cfg.default_v 中 wireless定义
	if 'ap' == cf.type then
		wireless.set_ap()
	else
		wireless.set_sta(cf.ssid, cf.passwd)
	end
end

wireless.setup_json = function (json)
	local ret, cf = pcall(cjson.decode, json)

	if ret then
		wireless.setup(cf)
	end
end


local switch2ap = function ()
	print('wireless switch2ap start...')
	
	l_wireless.mode_switch2ap()	
	print('wireless switch2ap over.')
end

local switch2sta = function (ssid,psk)
    local content = "ctrl_interface=/var/run/wpa_supplicant\n".."update_config=1\n".."network={\nssid=\""..ssid.."\"\npsk=\""..psk.."\"\n}"
	local f = assert(io.open("/opt/configfile/wpa_0_8.conf",'w'))
    f:write(content)
	f:close()
	
	print('wireless switch2sta start...')
	l_wireless.mode_switch2sta()
	-- print('wireless switch2sta over.')
	l_wireless.sta_dhcpc_start()
end


local sta_conn_wifi = function ()
	print('sta connect to:', cfg.ssid)
	
	l_wireless.sta_wpa_cli_start()

	print('sta_get_scan_result')
	local scan = l_wireless.sta_get_scan_result()
	
	if util.t_is_empty(scan) then
		return
	end
	local ssid = cfg.ssid
	local passwd = cfg.passwd
	local flags = ''
	local b_conn = false
	
	for k, v in ipairs(scan) do
		--util_ex.printf(k, v['ssid'], v)
		if ssid == v['ssid'] then
			b_conn = true
			if 'string' == type(v['flags']) then
				flags = v['flags']
				--util_ex.printf('find wifi:', v)
				break
			else
				print('wifi flags error!')
			end
		end	
	end

	if b_conn then
		l_wireless.sta_connect2ap(ssid, passwd, flags)
	else
		print('no find wifi ssid', ssid)
	end
end



local sta_list_wifi = function ()
	
	l_wireless.sta_wpa_cli_start()

	-- print('sta_get_scan_result')
	local scan = l_wireless.sta_get_scan_result()
	
	if util.t_is_empty(scan) then
		return
	end
	
	for k, v in ipairs(scan) do

		print(v['ssid'].."     ")
	end


end



wireless.check_proc = function (tc)

	-- 从配置消息中取数据, 一直取到最后一个配置消息
	local json = ''
	while true do
		local ret, msg, lparam = imsg.get(imsg.update_wifi)

		if ret then
			json = lparam
		else
			break
		end
	end

	if '' ~= json then
		print('wireless.setup_json', json)
		wireless.setup_json(json)
		check_tc = time_interval -- 有配置更新, 立即处理检查
	end
	
	
	if nil == l_wireless then
		return -- 模拟软件, 不处理wifi
	end

	check_tc = check_tc + tc
	if check_tc < time_interval then
		return -- 不在时间间隔范围
	end
	
	-- 计数归0, 并执行一次检查
	check_tc = 0	
	
	local mode = l_wireless.mode_probe()
	
	if mode ~= cfg.mode then
		if 'ap' == cfg.mode then
			if mode == 'sta' then
				l_wireless.sta_wpa_cli_cleanup()
			end
			switch2ap()
			l_sys.sleep(2000)
		else
			switch2sta(cfg.ssid,cfg.passwd)
			l_sys.sleep(2000)
		end
	end

	if 'ap' ~= cfg.mode then
		--显示wifi列表  用于测试
		--sta_list_wifi()

		-- sta 模式, 检查是否连接到指定的wifi
		local status, ssid = l_wireless.sta_get_linkstatus()
		
		if 0 == status then
			-- 没有连接,
			-- wpa_supplicant 服务程序会自动连接  /opt/configfile/wpa_0_8.conf 中保存的wifi
			print("----- 0 -------")  
		elseif 1 == status then	
			-- 已经连接 但没得到ssid信息
			print("----- 1 -------")
		else
			print("----- 2 -------")
			print("connected ssid = "..ssid.."\n")
		end
	else
		--print('wireless is ap mode')
	end

end


--用于测试
wireless.test = function (mode)
	local t_mode
	local status, ssid
	if mode == 'ap' then
		print("switch to ap mode --------------\n")
		switch2ap()
	else
		print("switch to sta mode --------------\n")
		switch2sta(cfg.ssid,cfg.passwd)
	end

	l_sys.sleep(6000)
	t_mode = l_wireless.mode_probe()
	print("t_mode = ",t_mode)
	if t_mode == 'ap' then
		print("ap mode ------------")
	end

	if t_mode == 'sta' then
		print("sta mode ***********")

		status, ssid = l_wireless.sta_get_linkstatus()
		print("connected ssid = "..ssid.."\n")

	end
end

--[[ test
--wireless.set_ap()
wireless.set_sta('HUAWEI-7NLNPF_5G', 'qwertyuiop1234567890') -- 可能为错误的ssid,或密码

local count = 1000
while 0 < count do
	wireless.check_proc()	-- 一直检查wifi连接状态,及是否需要变更
	l_sys.sleep(1000)
	
	count = count -1
end
--]]

return wireless
