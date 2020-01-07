
local l_sys = require("l_sys")
local l_tpool = require("l_tpool")


local thread1 = l_tpool.open_thread('thread1', 10, 'ipc.demo.t_tpool_loader', 'open_thread')


l_tpool.init()

-- 任何情况下的退出函数
local on_exit = function()
	l_tpool.quit()
	
	thread1 = nil
	return 0
end

l_on_exit(on_exit)


l_tpool.create('aaa', 10, 'ipc.demo.t_tpool_loader', 'aaa')
l_tpool.create('bbb', 10, 'ipc.demo.t_tpool_loader', 'bbb')
l_tpool.create('ccc', 10, 'ipc.demo.t_tpool_loader', 'ccc')


local count = 60
while 0 < count do
	count = count - 1
	
	local str = tostring(count)

	
	thread1:post('amsg' .. str, 'lparam' .. str, 'wparam' .. str)
	print(thread1, thread1:name(), thread1:status(), thread1:job_size())

	l_tpool.post('aaa', 'amsg' .. str, 'lparam' .. str, 'wparam' .. str)
	l_tpool.post('aaa', 'bmsg' .. str, 'lparam' .. str, 'wparam' .. str)
	l_tpool.post('aaa', 'cmsg' .. str, 'lparam' .. str, 'wparam' .. str)
	
	local idle = l_tpool.find_idle({'111', '2222', '34sdfsdf', 'aaa', 'bbb', 'ccc', 'ddd'})
	local idle = l_tpool.find_idle({'sdf', 'aaa', 'dfe'})

	if '' ~= idle then
		l_tpool.post(idle, 'idle msg' .. str, 'lparam' .. str, 'wparam' .. str)
	end
	
	l_sys.sleep(100)	
end
