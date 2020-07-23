
local l_sys = require("l_sys")


local ts = {'void*', 'bool8', 'int8', 'bool16', 'uint16', 
'int32', 'uint32', 'bool32', 'int64', 'uint64',
'bool_t', 'int_t', 'uint_t', 'long_t', 'ulong_t'}

for k, v in ipairs(ts) do
	print('type:' .. v, l_sys.type_size(v))
end

