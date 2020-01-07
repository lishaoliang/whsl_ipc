local string = require("string")
local cjson = require("cjson")

local l_sys = require("l_sys")

local l_discover = require("l_discover")
local l_broadcast_cli = require("l_broadcast_cli")


l_discover.init()
l_discover.start()


l_broadcast_cli.open(900, 0, '255.255.255.255', 23919)

local count = 20
while 0 < count do
	count = count - 1

	l_broadcast_cli.discover(900)
	
	while true do
		local ret, code, msg, protocol, id, ip, port = l_broadcast_cli.recv()

		if ret then
			print('broadcast cli recv:', code, msg, protocol, id, ip, port)
		else
			break
		end
	end

	l_sys.sleep(1000)
end

l_discover.stop()
l_discover.quit()
