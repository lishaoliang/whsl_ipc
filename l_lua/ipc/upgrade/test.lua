local l_sys = require("l_sys")
local l_net_a = require("l_net_a")
local l_nmps_a = require("l_nmps_a")
local l_skdr_a = require("l_skdr_a")
local l_nsm_a = require("l_nsm_a")

local util = require("base.util")
local np_id = require("base.np_id")
local upgrade = require("ipc.upgrade.upgrade")


l_net_a.init()
local skdr_up = l_skdr_a.create('skdr_upgrade')
local nsm_up = l_nsm_a.create('nsm_upgrade', skdr_up)
upgrade.init(nsm_up)
l_net_a.start()


l_nmps_a.open('8000', 8000)


local count = 100000
while 0 < count do
	count = count -1
	l_sys.sleep(10)
	
	local socket, main, sub = l_nmps_a.get_socket()
	if nil ~= socket then
		print('nsps get socket:', main, sub, socket)
		
		if np_id.NSPP == main and np_id.UPGRADE == sub then
			upgrade.push(socket, util.next_socket_id(), main, sub)
		else
			l_sys.free(socket)
		end
	end
	
	upgrade.on_recv()
end


l_nmps_a.close('8000')
l_net_a.stop()
upgrade.quit()
l_net_a.quit()
