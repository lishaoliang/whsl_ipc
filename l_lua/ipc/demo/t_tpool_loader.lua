

local name = ''


init = function (param)
	print('init .....', param)
	name = param
	return 0
end


quit = function ()
	print('quit .....')
	return 0
end


on_cmd = function (msg, lparam, wparam, cobj)
	print('on_cmd.name:'..name, msg, lparam, wparam, cobj)
	return 0
end
