
local wireless = require "l_wireless"

local function excute_cmd(cmd)
    local t = io.popen(cmd)
    local ret = t:read("*all")
    return ret
end


print("\n===========获取指定网络接口的IPv4地址===========")
local ip = wireless.get_ipv4addr("wlan0")
print(ip)

print("\n===========设置指定网络接口的IPv4地址===========")
wireless.set_ipaddr("wlan0","192.168.7.1")

print("\n===========获取指定网络接口的IPv4地址===========")
local ip = wireless.get_ipv4addr("wlan0")
print(ip)




print("===========wifi模式探测===========")
local ret = wireless.mode_probe()

if ret == 0 then print("ap mode") end
if ret == 1 then print("sta mode") end
if ret == 2 then print("other mode") end


print("===========获取所有网络接口及其IPv4地址===========")
local ipandaddr = wireless.get_current_ifandip()
for k,v in pairs(ipandaddr) do
    print(k,v)
end


print("\n===========获取指定网络接口的IPv4地址===========")
local ip = wireless.get_ipv4addr("wlan0")
print(ip)


print("===========切换至ap模式===========")
wireless.mode_switch2ap()


print("===========获取ap模式下连接的station数量===========")
ret = wireless.ap_connected_count()
io.write("已连接 ",ret," 个设备\n")

--excute_cmd("sleep 2")

print("===========切换至station模式===========")
wireless.mode_switch2sta()

excute_cmd("sleep 2")

print("===========获取station模式下连接状态===========")
local ssid
ret,ssid = wireless.sta_get_linkstatus()

if ret == 0 then print("未连接\n") end
if ret == 1 then print("已连接  ssid:",ssid) end


print("===========station模式配置使能===========")

ret = wireless.sta_wpa_cli_start()
if ret == -1 then print("错误\n") end
if ret == 0 then print("初始化过了，无需再初始化\n") end
if ret == 1 then print("初始化成功\n") end



local sresult = wireless.sta_get_scan_result()

print(type(sresult))


for i = 1 , #sresult do
    io.write("ssid: ",sresult[i]["ssid"],"   bssid: ",sresult[i]["bssid"],"   flags: ",sresult[i]["flags"],"   signal: ",sresult[i]["signal"],"   freq: ",sresult[i]["freq"],"\n")
end



print("===========连接wifi ===========")
wireless.sta_connect2ap("TAGYE_5","tagye1207","[WPA-PSK-TKIP+CCMP]")
excute_cmd("sleep 1")

print("===========获取station模式下连接状态===========")
local ssid
ret,ssid = wireless.sta_get_linkstatus()

if ret == 0 then print("未连接\n") end
if ret == 1 then print("已连接  ssid:",ssid) end


print("\n\n===========释放资源===========")
wireless.sta_wpa_cli_cleanup()










