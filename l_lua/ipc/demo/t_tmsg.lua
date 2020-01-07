
local l_tmsg = require("l_tmsg")



l_tmsg.init()

l_tmsg.register('aaa')
l_tmsg.register('bbb')
l_tmsg.register('ccc')


for i = 1, 100 do
	local str = tostring(i)
	l_tmsg.post('aaa', 'amsg' .. str, 'lparam' .. str, 'wparam' .. str)
	l_tmsg.post('bbb', 'bmsg' .. str, 'lparam' .. str, 'wparam' .. str)
	l_tmsg.post('ccc', 'cmsg' .. str, 'lparam' .. str, 'wparam' .. str)
end

local t_get = function (name)
	while true do
		local ret, msg, lparam, wparam = l_tmsg.get(name)
		print(ret, msg, lparam, wparam)	
			
		if not ret then
			break
		end
	end
end

t_get('aaa')
t_get('bbb')

l_tmsg.clear('ccc')
t_get('ccc')



l_tmsg.quit()
