local l_sys = require("l_sys")
local l_file = require("l_file")
local l_net_x = require("l_net_x")
local l_skdr_x = require("l_skdr_x")
local l_ncm_x = require("l_ncm_x")

local cjson = require("cjson")

local np_id = require("base.np_id")
local np_err = require("base.np_err")



l_net_x.init()
local skdr_up = l_skdr_x.create('skdr_upgrade')
local ncm_up = l_ncm_x.create('nsm_upgrade', skdr_up)
l_net_x.start()


local up = {
	cmd = 'upgrade',
	llssid = '123456',
	llauth = '123456',
	upgrade = {
		username = 'admin',
		passwd = '123456'
	}
}


local tf = l_file.open('./test_1.jpg', 'rb')
assert(tf)


l_ncm_x.connect(ncm_up, 1000, np_id.NSPP, np_id.UPGRADE, '127.0.0.1', 8000)
l_ncm_x.send(ncm_up, 1000, cjson.encode(up))


local b_send_md = false

local send_md = function ()
	if b_send_md then	
		local buf = l_file.read(tf)

		if buf then
			l_ncm_x.send_md(ncm_up, 1000, buf)
		else
			b_send_md = false
		end
	end
end


local count = 100
while 0 < count do
	count = count -1
	l_sys.sleep(100)
	
	local ret, code, body, id, main, sub = l_ncm_x.recv(ncm_up)
	
	if ret then
		if 0 == code then
			print('l_ncm_x.on_recv:', id, body)

			--l_ncm_x.send(ncm_up, id, body)

			b_send_md = true	
			
		elseif np_err.CONNECT == code then
			print('l_ncm_x.on_recv new socket.', id)
		else
			-- 连接断开
			print('close:', id)
			l_ncm_x.close(ncm_up, id)
		end
	end
	
	send_md()
end

l_file.close(tf)

l_net_x.stop()
l_net_x.quit()
