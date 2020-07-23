--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/04/03
--
-- @file    wpa_cli.lua
-- @brief   wpa_cli接口封装
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/04/03 0.1 创建文件
-- @warning 没有警告
--]]

local string = require("string")
local l_sys = require("l_sys")
local sh = l_sys.sh

local util = require("base.util")
local util_ex = require("base.util_ex")


local wpa_cli = {}


local path_wpa_cli = '/opt/wireless_tools/wpa_cli'
local iwlan = '-iwlan0'


-- @brief 执行wpa_cli的命令
-- @param [in]		msg[string]	命令字符串
-- @return [number]  shell错误码
--			[string] shell的结果字符串
local wpa_cli_cmd = function (msg)
	local cmd = string.format('%s %s %s', path_wpa_cli, iwlan, msg)

	local ret, str = sh(cmd)
	--print('cmd:'..msg, ret, str)
	
	return ret, str
end


-- @brief 检查字符串中是否含有明确的错误信息
-- @param [in]  	str[string]	字符串
-- @return [boolean] true.含有错误信息; false.未含有错误信息
local check_is_error = function (str)
	local low = string.lower(str)
	
	if nil ~= string.find(low, 'failed') then	-- 'Failed'
		return true
	end
	
	if nil ~= string.find(low, 'error') then	-- 'error'
		return true
	end

	-- 'No such file or directory'
	if nil ~= string.find(low, 'no such file or directory') then
		return true
	end
	
	return false
end

-- @brief 探测wpa_supplicant是否在线
-- @return [boolean] 	wpa_supplicant是否在线
--			[boolean]	ping是否成功
wpa_cli.ping = function ()
	local ret, str = wpa_cli_cmd('ping')	
	str = string.lower(str)

	local err = check_is_error(str)
	
	if not err and nil ~= string.find(str, 'pong') then	-- 'PONG'
		return not err, true
	end
	
	return not err, false
end

-- @brief 让wpa_supplicant发起扫描
-- @return [boolean] 	wpa_supplicant是否发起扫描
-- @note 发起扫描一段时间后[几秒], 才可以完整获取ap列表
wpa_cli.scan = function ()
	local ret, str = wpa_cli_cmd('scan')	
	str = string.lower(str)

	if nil ~= string.find(str, 'ok') then	-- 'OK'
		return true
	end
	
	return false
end

-- @brief 获取wifi环境下的ap列表
-- @return [table] 	ap列表
wpa_cli.scan_results = function ()
	local ret, str = wpa_cli_cmd('scan_results')
	
--[[
local str =
'bssid / frequency / signal level / flags / ssid\n' ..
'7c:76:68:b6:9d:24       5805    -39     [WPA2-PSK-CCMP][WPS][ESS]       HUAWEI-7NLNPF_5G\n' ..
'94:d9:b3:a6:d0:73       5180    -41     [WPA-PSK-TKIP+CCMP][WPA2-PSK-TKIP+CCMP][ESS]    whsl5.8\n' ..
'7c:76:68:b6:9d:20       2437    -40     [WPA2-PSK-CCMP][WPS][ESS]       HUAWEI-7NLNPF\n' ..
'7c:76:68:b6:9d:21       2437    -38     [WPA2-PSK-CCMP][ESS]    \x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\n' ..
'94:d9:b3:a6:d0:6e       2442    -42     [WPA-PSK-TKIP+CCMP][WPA2-PSK-TKIP+CCMP][ESS]    whsl2.4\n' ..
'02:27:1d:06:31:a0       2462    -80     [WPA2-EAP-CCMP][ESS]    CMCC\n' ..
'78:44:fd:1e:b1:27       2412    -82     [WPA-PSK-CCMP][WPA2-PSK-CCMP][ESS]      TP-LINK_B127\n' ..
'68:db:54:b7:3e:81       2462    -82     [WPA-PSK-TKIP+CCMP][WPA2-PSK-TKIP+CCMP][ESS]    gg-007\n' ..
'38:22:d6:ab:99:50       2462    -76     [ESS]   ChinaNet'
--]]

	local aps = {}

	for bssid, frequency, signal, flags, ssid in string.gmatch(str, '([^%s]+)%s+([%d%-]+)%s+([%d%-]+)%s+([^%s]+)%s+([^%s]+)%c*') do	
		if nil ~= bssid and nil ~= frequency and nil ~= signal and nil ~= flags and nil ~= ssid then
			local o = {
				bssid = util.trim_cs(bssid),
				frequency = util.trim_cs(frequency),
				signal = util.trim_cs(signal),
				flags = util.trim_cs(flags),
				ssid = util.trim_cs(ssid)
			}
			
			table.insert(aps, o)
		end
	end
	
	return aps
end


-- @brief 获取当前状态
-- @return [table] 	状态
wpa_cli.status = function ()
	local ret, str = wpa_cli_cmd('status')

--[[
local str = 
'bssid=7c:76:68:b6:9d:24\n' ..
'ssid=HUAWEI-7NLNPF_5G\n' ..
'id=0\n' ..
'mode=station\n' ..
'pairwise_cipher=CCMP\n' ..
'group_cipher=CCMP\n' ..
'key_mgmt=WPA2-PSK\n' ..
'wpa_state=COMPLETED\n' ..
'ip_address=192.168.7.1\n' ..
'p2p_device_address=50:2b:73:d5:27:1d\n' ..
'address=50:2b:73:d5:27:1d\n'
--]]

	local s = {}
	
	for k, v in string.gmatch(str, '([%w_]+)=([^%c]+)%c*') do
		if nil ~= k and nil ~= v then
			k = util.trim_cs(k)
			v = util.trim_cs(v)
			
			if '' ~= k then
				s[k] = v
			end	
		end	
	end
	
	return s
end


-- @brief 断开当前连接
-- @return [boolean] true,false
wpa_cli.disconnect = function ()
	local ret, str = wpa_cli_cmd('disconnect')	
	str = string.lower(str)

	if nil ~= string.find(str, 'ok') then	-- 'OK'
		return true
	end
	
	return false
end


-- @brief 重新连接; 重新连接之前, 需要断开连接
-- @return [boolean] true,false
wpa_cli.reconnect = function ()
	local ret, str = wpa_cli_cmd('reconnect')
	str = string.lower(str)

	if nil ~= string.find(str, 'ok') then	-- 'OK'
		return true
	end
	
	return false
end


--wpa_cli.status()
--wpa_cli.scan_results()

--[[
print('ping', wpa_cli.ping())
util_ex.printf('status', wpa_cli.status())


print('scan', wpa_cli.scan())

l_sys.sleep(1000)

util_ex.printf('scan_results', wpa_cli.scan_results())
--]]

return wpa_cli
