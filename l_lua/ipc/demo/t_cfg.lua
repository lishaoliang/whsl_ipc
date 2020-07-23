local l_ipc = require("l_ipc")
local cfg = require("ipc.cfg.cfg")
local util_ex = require("base.util_ex")

local l_sys = require("l_sys")


local ipv4 = {
	dhcp = false,
		
	ip = '192.168.3.219',
	netmask = '255.255.255.0',
	gateway = '192.168.3.1',
		
	auto_dns = false,
	dns1 = '192.168.3.1',
	dns2 = '192.168.3.1'
}
	
local wireless = {
	type = 'ap',		-- 'ap' 'sta'
	net = '5g',		-- '2.4g' '5g'
	ssid = 'f701w-cut',
	passwd = '123456',
	enc = 'wpa2-psk'
}

--cfg.setup()

--print('-----------------1111111111111111111111')
--util_ex.printf('cfg get:', cfg.get('ipv4'))
--util_ex.printf('cfg get:', cfg.get('wireless'))

--cfg.set('ipv4', ipv4)
--cfg.set('wireless', wireless)

--print('-----------------22222222222222222222222')

--util_ex.printf('cfg get:', cfg.get('ipv4'))
--util_ex.printf('cfg get:', cfg.get('wireless'))


-- 普通配置
--local key_normal = {'system', 'name', 'ipv4', 'wireless', 'wireless_ipv4', 'net_port', 'upnp'}


--local key_chnn_idx = {'stream'}

--local key_chnn = {'image', 'img_wd', 'img_dnr'}


--for k, v in ipairs(key_normal) do
--	util_ex.printf('cfg get,key='..v, cfg.get(v))
--end

--for i = 0, 0 do
--	for k, v in ipairs(key_chnn_idx) do
--		local key = cfg.key_chnn_idx(v, i, 0)
--		util_ex.printf('cfg get,key='..key, cfg.get(key))
	
--		key = cfg.key_chnn_idx(v, i, 1)
--		util_ex.printf('cfg get,key='..key, cfg.get(key))
--	end
--end

--for i = 0, 0 do
--	for k, v in ipairs(key_chnn) do
--		local key = cfg.key_chnn(v, i)
--		util_ex.printf('cfg get,key='..key, cfg.get(key))
--	end
--end

--for i = 0, 10 do
--	local key = cfg.key_user_index(i)
--	util_ex.printf('cfg get,key='..key, cfg.get(key))
--end


--local keys = cfg.keys()

--for k, v in pairs(keys) do
--	util_ex.printf('cfg get,key='..v, cfg.get(v))
--end

--local ret, res = l_sys.sh('curl get www.baidu.com')
--local ret, res = l_sys.sh('ipconfig')







local ret, res = l_sys.sh('curl -X POST -H "Content-Type: application/json" --data "{\"cmd\":\"hello,support,encrypt,login,system,ipv4,set_ipv4,logout\",\"llssid\":\"123456\",\"llauth\":\"123456\"}" 192.168.3.218:80/luajson')

print('--->', ret)
print(res)
