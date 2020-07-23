local string = require("string")
local cjson = require("cjson")

local l_sys = require("l_sys")

local l_discover = require("l_discover")
local l_broadcast_ser = require("l_broadcast_ser")


l_discover.init()
l_discover.start()

local discover = 
{
	cmd = 'discover',
	sn = 'YDFE4EFDFESHEDFR',
		
	discover = {
		name = 'x',
		port = 80,
		hw_ver = 'h1.0.0',
		sw_ver = 'v1.0.2',
		model = 'wifi-ipc',
		dev_type = 'ipc',
		chnn_max = 1,
		txt_enc = '',
		md_enc = ''
	}
}
local txt = cjson.encode(discover)
	
l_broadcast_ser.set_respond(900, txt)


l_broadcast_ser.open(900, 0, '255.255.255.255', 23919)
l_broadcast_ser.open(900, 1, '192.168.255.255', 23919)
l_broadcast_ser.open(900, 2, '192.168.1.255', 23919)
l_broadcast_ser.open(900, 3, '192.168.3.255', 23919)
l_broadcast_ser.open(900, 4, '192.168.7.255', 23919)
l_broadcast_ser.open(900, 5, '192.168.9.255', 23919)


l_sys.sleep(30000)


l_discover.stop()
l_discover.quit()
