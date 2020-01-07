
local l_sys = require("l_sys")


local on_exit = function()

	print('lua over...', 'on_exit')
	
	return 0
end

l_on_exit(on_exit)

local count = 1000
while 0 < count do
	--count = count -1
	
	l_sys.sleep(1000)
end

print('lua over...')
