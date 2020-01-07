--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/4/28
--
-- @file    upgrade.lua
-- @brief   升级流程
--  \n 升级流程不得依赖文件系统
--  \n 升级文件: /nfsmem/upgrade/ipc_upgrade_file.lpk	*.lpk文件
--  \n 升级标记: /nfsmem/upgrade/ipc_upgrade.txt		字符串,含有'1'即为可升级
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2019/4/28 0.1 创建文件
-- @warning 没有警告
--]]
local string = require("string")
local os = require("os")
local io = require("io")
local lfs = require("lfs")
local l_sys =  require("l_sys")
local l_file = require("l_file")
local l_pack = require("l_pack")

local util = require("base.util")
local unix = require("base.unix")


local ipc_upgrade_file = '/nfsmem/upgrade/ipc_upgrade_file.lpk'	-- 升级文件
local ipc_upgrade = '/nfsmem/upgrade/ipc_upgrade.txt'			-- 升级标记
local ipc_root = ''


if 'hisi_linux' ~= l_sys.platform then
	-- 非目标平台, 重定位目录
	ipc_upgrade_file = './upgrade/ipc_upgrade_file.lpk'
	ipc_upgrade = './upgrade/ipc_upgrade.txt'
	ipc_root = './upgrade/root'
end


local do_check = function ()	
	return l_pack.check(ipc_upgrade_file)
end


local filter_file = function (path)
	-- 校验目录合法性, 以免更新到不必要的文件,目录
	-- 只更新文件: '/mm.sh'
	-- 只更新目录: '/opt', '/komod'
	-- 不更新目录: '/opt/config' '/opt/configfile'
	if nil == path then
		return false, ''
	end
	
	local w_path = path
	local mm_file = '/mm.sh'
	local dir_opt = '/opt'
	local dir_komod = '/komod'
	local dir_opt_cfg = '/opt/config'
	local dir_opt_cfgfile = '/opt/configfile'
	
	if 'hisi_linux' ~= l_sys.platform then
		w_path = string.format('%s%s', ipc_root, path)
		mm_file = string.format('%s%s', ipc_root, mm_file)
		dir_opt = string.format('%s%s', ipc_root, dir_opt)
		dir_komod = string.format('%s%s', ipc_root, dir_komod)
		dir_opt_cfg = string.format('%s%s', ipc_root, dir_opt_cfg)
		dir_opt_cfgfile = string.format('%s%s', ipc_root, dir_opt_cfgfile)
	else
		-- 安全问题
	end
	
	-- 不可以更新的目录
	if 1 == string.find(w_path, dir_opt_cfg) or
		1 == string.find(w_path, dir_opt_cfgfile) then
		return false, ''
	end

	-- 许可更新的目录及文件
	if mm_file == w_path then
		return true, w_path
	end
	
	if 1 == string.find(w_path, dir_opt) then
		return true, w_path
	end
	
	if 1 == string.find(w_path, dir_komod) then
		return true, w_path
	end
	
	return false, ''
end

local my_mkdir = nil
my_mkdir = function (path, cur)
	local left = string.sub(path, string.len(cur) + 1)
	local f = string.find(left, '/')
	if nil ~= f then
		local pwd = string.sub(path, 1, f + string.len(cur))
		
		local b_mk = true
		if nil == lfs.attributes(pwd) then
			b_mk = lfs.mkdir(pwd)
		end
		
		if b_mk then
			return my_mkdir(path, pwd)
		else
			return false
		end
	end
	
	return true
end

local mkdir = function (path)
	return my_mkdir(path, '')
end


local update_file = function (pkr, path)
	
	-- 确保目录存在
	mkdir(path)
	
	local file = l_file.open(path, 'wb')
	if nil == file then
		print('update_file open error!path:' .. path)
		return false
	end

	local b_write = true
	local size = 0

	local offset = 0
	while true do
		local buf, r = l_pack.iter_read(pkr, offset)	
		if nil ~= buf then				
			offset = offset + r
			local ret, w = l_file.write(file, buf)
			
			if ret and w == r then
				size = size + w
			else
				b_write = false
			end
		else
			break
		end
	end
	
	l_file.close(file)
	
	if b_write then
		print('update_file ok.path:' .. path, size)
	else
		print('update_file error.path:' .. path, size)
	end
end

local check_enc = function (enc)
	local dec, obj = pcall(cjson.decode, enc)	

	if not dec then
		return false
	end

	local check = false
	for k, v in pairs(obj) do
		if v == l_sys.chip then
			check = true
			break
		end
	end
	
	return check
end

local do_upgrade = function ()
	local pkr = l_pack.open(ipc_upgrade_file)
	
	if nil == pkr then
		print('do_upgrade,open upgrade file error!', ipc_upgrade_file)
		return false
	end

	local enc = l_pack.enc(pkr)
	print('do_upgrade,enc:', enc)
	
	if not check_enc(enc) then
		print('do_upgrade,check enc error!')
		l_pack.close(pkr)
		return false
	end
	

	local begin = l_pack.iter_begin(pkr)
	while begin do
		local path = l_pack.iter_path(pkr)
	
		-- 过滤文件, 只更新某些目录文件
		local filter, filter_path = filter_file(path)
		if filter then
			update_file(pkr, filter_path)	-- 更新文件
		else
			print('do_upgrade drop path:' .. path)
		end
		
		if not l_pack.iter_next(pkr) then
			break
		end
	end	
	
	l_pack.close(pkr)

	return true
end

local do_killall = function ()
	-- 杀掉非升级程序
	unix.kill('llua', 'ipc.lua')		-- 杀掉主程序
	
	-- 杀掉其他进程
	unix.killall('udhcpc')
	unix.killall('wpa_supplicant')
	unix.killall('dnsmasq')
	unix.killall('hostapd')
	
	unix.killall('telnetd')
end


-- 处理异常退出
local on_exit = function()
	-- 关闭业务
	
	print('upgrade exit!.....')
	return 0
end

l_on_exit(on_exit)


-- 主检查升级流程
local proc_main = function ()
	
	-- 读取 ipc_upgrade 文件中的标记
	local file = io.open(ipc_upgrade)
	if nil ~= file then
		local num = file:read('*n')
		file:close()
		
		local b_reboot = false
		
		if num and 1 <= num and do_check() then
			print('proc_main upgrade...')
			do_killall()
			
			if do_check() then			-- 再次检查文件包, 以防止在 killall 时, 数据包被改写
				do_upgrade()
			
				unix.shell('sync')		-- 同步文件系统
				l_sys.sleep(100)
				print('proc_main upgrade over.need reboot!...')
			end

			b_reboot = true
		else
			print('proc_main check error!remove upgrade!')
		end
		
		-- 这次处理之后, 删除升级文件
		os.remove(ipc_upgrade)
		os.remove(ipc_upgrade_file)
		
		unix.shell('sync')		-- 同步文件系统
		l_sys.sleep(100)
		
		if b_reboot then
			print('reboot now!...')
			unix.shell('reboot')	-- 重启
		end
		
		return not b_reboot
	end
	
	return true
end


-- 后台守护: 如果ipc主进程意外挂掉, 则重启设备
local check_ipc = function ()
	
	local o = unix.ps('llua', 'ipc.lua')
	if util.t_is_empty(o) then
		print('check_ipc not found!...')
		print('reboot now!...')
		unix.shell('reboot')	-- 重启
		return false
	end
	
	return true
end


print('upgrade start ok...')


-- 主循环
local tc_collect = 0
local count = 0
while true do
	if proc_main() then
		count = count + 1000
		if 180000 < count then		-- 3 * 60 * 1000, 3分钟
			count = 0

			-- 内存清理
			collectgarbage('collect')	
			
			-- 定期检查主进程是否OK
			if not check_ipc() then
				break
			end
		end
		
		-- 定期执行lua内存回收
		tc_collect = tc_collect + 1000
		if 10000 < tc_collect then
			tc_collect = 0
			collectgarbage('collect')
		end
		
		l_sys.sleep(1000)
	else
		break
	end
end
