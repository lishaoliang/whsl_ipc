--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief  配置相关入口
-- @author 李绍良
--]]
local string = require("string")
local cjson = require("cjson")
local l_cfg = require("l_cfg")

local util = require("base.util")
local np_err = require("base.np_err")

local default = require("ipc.cfg.default")

local cfg = {}


-- brief 配置文件版本
-- note  每次修改配置项目, 必须修改配置版本[长度 <= 15]
cfg.version = 'v1.0.8'


-- brief 获取当前key的可变配置值
-- key [string]		  配置名称
-- return [nil,table] 被拷贝的数据, 可以任意使用
local get_cur_cfg_v = function (key)
	-- 获取默认值
	local def_v = default.get_v(key)
	
	if nil ~= def_v then
		
		-- 从配置文件读取数据, 如果取到数据, 则更新数据
		local str = l_cfg.get(key)
		if 0 < string.len(str) then
			local ret, f_v = pcall(cjson.decode, str)		
			if ret then
				util.t_cp_by(def_v, f_v)
			end
		end
	end
	
	-- 最终返回 = 默认值 叠加 修改值
	return def_v
end

-- brief 获取配置
-- key [string]		  配置名称
-- return [nil,table] 被拷贝的数据, 可以任意使用
cfg.get = function (key)
	
	local def_v = get_cur_cfg_v(key)	
	local def_r = default.get_r(key)	
	
	local u = util.t_union(def_v, def_r)	-- 当前值 与 只读值并集
	return u
end

-- brief 获取默认配置
-- key [string]		  配置名称
-- return [nil,table] 被拷贝的数据, 可以任意使用
cfg.default = function (key)
	local def_v = default.get_v(key)
	local def_r = default.get_r(key)
	
	local u = util.t_union(def_v, def_r)	-- 默认值 与 只读值并集	
	return u
end


-- brief 校验配置参数信息
-- param [table]	配置名称
-- r [table]	配置值
-- return [boolean]	true.通过校验; false.参数错误
local check_param = function (param, r)
	-- 规则. r.range 域中标明各个参数范围
	-- 未在 r.range 中约定的范围, 则使用协议约定值
	local n_min = 0		-- number.min
	local n_max = 100	-- number.max
	
	local s_l_min = 0	-- string len .min
	local s_l_max = 128	-- string len .max

	if not util.t_is_not_empty(param) then
		return false	-- 必须是 table, 且有数据
	end
	
	local range = util.t_item(r, 'range')
	
	for k, v in pairs(param) do
		if 'string' == type(k) then
			local t = type(v)		
			if 'number' == t then
				local n_keys = util.t_item(range, k)
				if util.t_is_array(n_keys) then
					-- 约定数值取值
					local b_in_keys = false
					for m, n in ipairs(n_keys) do
						if n == v then
							b_in_keys = true
							break
						end
					end
					
					if not b_in_keys then
						return false	-- 不在给定的范围
					end
				else
					-- 约定数值取值范围
					local min = util.t_item(range, k, 'min') or n_min
					local max = util.t_item(range, k, 'max') or n_max
				
					if v < min or max < v then
						return false
					end
				end
			elseif 'string' == t then
				local s_keys = util.t_item(range, k)				
				if util.t_is_array(s_keys) then
					-- 约定字符串取值范围
					local b_in_keys = false
					for m, n in ipairs(s_keys) do
						if n == v then
							b_in_keys = true
							break
						end
					end
					
					if not b_in_keys then
						return false	-- 不在给定的范围
					end
				else
					-- 否则, 约定为限定长度范围
					local len = string.len(v)
					if len < s_l_min or s_l_max < len then
						return false
					end
				end
			else
				-- 其他不检查
			end
		end
	end
	
	return true
end


local set_cfg = function (key, value, save)
	-- 获取当前值
	local v = get_cur_cfg_v(key)
	if nil == v then
		return false, '{}', np_err.NOTFOUND
	end
	
	-- 更新当前值
	util.t_cp_by(v, value)

	-- 获取只读值
	local r = default.get_r(key)

	-- 统一参数检查
	if not check_param(v, r) then
		return false, '{}', np_err.PARAM
	end
	
	-- 设置
	local code = np_err.SAVE
	local json = cjson.encode(v)
	local ret = l_cfg.set(key, json)
		
	--print('cfg.set:', ret, json)
	if ret and save then
		l_cfg.save() --保存文件
		code = np_err.OK
	end
	
	return ret, json, code
end

-- brief 设置数据
-- key [string]		配置名称
-- value [table]	配置值
-- return ret[boolean]	是否设置成功
--		v[string]		被设置的json字符串
--		code[number]	错误码
cfg.set = function (key, value)
	local ret, json, code = set_cfg(key, value, true)
	
	return ret, json, code
end

-- @brief 获取关于 通道, 流序号关联的真实配置key
cfg.key_chnn_idx = function (key, chnn, idx)
	local txt = string.format('%s_chnn%d_idx%d', key, chnn, idx)
	return txt
end


-- @brief 获取关于 通道真实配置key
cfg.key_chnn = function (key, chnn)
	local txt = string.format('%s_chnn%d', key, chnn)
	return txt
end


-- @brief 获取关于 用户有关的真实配置key
cfg.key_user_index = function (index)
	local txt = string.format('user_name%d', index)
	return txt
end

-- @brief 获取当前所有的key值
cfg.keys = function ()
	return util.t_copy(default.keys)
end


-- brief 配置初始化
cfg.init = function ()
	
	-- 初始化C配置模块
	l_cfg.init(cfg.version)

	-- 检查配置文件是否存在异常, 存在异常则修复至当前版本
	if not l_cfg.is_ok() then
		print('lua cfg is not ok, repair!')
		
		for k, v in pairs(default.default_v) do
			if 'string' == type(k) then
				local str = l_cfg.get_old(k)
				if 0 < string.len(str) then
					local dec, o = pcall(cjson.decode, str)
					if dec then
						set_cfg(k, o, false)
					end
				end
			end	
		end
		
		-- 保存文件
		l_cfg.save()
	end

	--local test = {
	--	name = 'hello world!'
	--}
	
	--cfg.set('system', test)
	--l_cfg.save()
end


-- brief 配置退出
cfg.quit = function ()
	l_cfg.quit()
end

-- brief 复位配置
cfg.reset = function()
	l_cfg.reset()	-- 复位内存
	l_cfg.save()	-- 保存文件
end


-- 初始化当前默认值
default.init()


return cfg
