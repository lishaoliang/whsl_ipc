--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_sys.lua
-- @brief   内置库require("l_sys"), 常用函数
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]

local l_sys = {}


-- @name   l_sys.chip
-- @export 芯片类型
-- \n hisi: 'hi_3516a','hi_3519'
-- \n win,linux:  'x86', 'x86_64'
l_sys.chip = 'hi_3516a'


-- @name   l_sys.platform
-- @export 系统平台: 'hisi_linux','win', 'linux'
l_sys.platform = 'hisi_linux'


-- @name   l_sys.version
-- @export 版本类型: 'debug','release'
l_sys.version = 'debug'


-- @brief 获取基础数据类型大小
-- @return [number] 大小
-- @note 
--  \n 'void*', 'bool8', 'int8', 'bool16', 'uint16'
--  \n 'int32', 'uint32', 'bool32', 'int64', 'uint64'
--  \n 'bool_t', 'int_t', 'uint_t', 'long_t', 'ulong_t'
l_sys.type_size = function (t_name)
	return 0
end


-- @brief 释放l_obj对象
-- @param [in] l_obj[LUA_TLIGHTUSERDATA] l_obj对象
l_sys.free = function (l_obj)
	return
end


-- @brief 获取系统滴答数
-- @return [number] 滴答数
-- @note 如果为32位, 操作int32最大值之后, 再从0开始计数
--  \n 系统滴答采用线程更新方式, 线程被阻塞或休眠, 系统滴答将不会被更新!
l_sys.tc = function ()
	return 123456
end


-- @brief 休眠[毫秒]
-- @param [in] ms[number] 休眠毫秒, 最小1ms
-- @return 无
-- @note 谨慎使用休眠场景
l_sys.sleep = function (ms)

end


-- @brief 伪随机数种子
-- @param [in] S[number] 设置伪随机数种子[可省略]
l_sys.srand = function (s)
	return
end


-- @brief 伪随机数[1,N]
-- @param [in] N[number] 随机最大值N=[1,0x7FFFFFFF]
-- @return [number] 随机值
l_sys.rand = function (N)
	return 1
end


-- @brief 伪随机字符串:[a-zA-Z0-9]
-- @param [in] N[number] 随机最大值N=[1,256]
-- @return [string] 随机字符串
-- @note 默认8个
--  \n N范围错误则为默认8
l_sys.rand_char = function (N)
	return 'abc'
end


-- @brief 伪随机数字字符串:[0-9]
-- @param [in] N[number] 随机最大值N=[1,256]
-- @return [string] 随机字符串
-- @note 默认8个,以非0开头
--  \n N范围错误则为默认8
l_sys.rand_num = function (N)
	return '123'
end


-- @brief 添加定时器
-- @param [in] id[number] 定时器id
-- @param [in] interval[number] 定时回调时间间隔
-- @param [in] cb[function] 回调函数
-- @return [boolean] 是否成功; 不成功的原因: id重复
-- @note cb函数原型 
--  \n cb = function (id, count, interval, tc, last_tc) return 0 end
--  \n [in] id[number] 定时器id
--  \n [in] count[number] 第几次回调(从1开始计数,超过int型之后回到1)
--  \n [in] interval[number] 定时调用的时间间隔
--  \n [in] tc[number] 当前时间
--  \n [in] last_tc[number] 上一次回调的时间
--  \n return 0.表示继续定时器; 非0.删除定时器
l_sys.add_timer = function (id, interval, cb)
	return true
end


-- @brief 修改定时器时间间隔
-- @param [in] id[number] 定时器id
-- @param [in] interval[number] 定时回调时间间隔
-- @return [boolean] 是否成功
l_sys.modify_timer = function (id, interval)
	return true
end


-- @brief 移除定时器
-- @param [in] id[number] 定时器id
-- @return [boolean] 是否成功
-- @note 在 add_timer 的回调函数 cb 中不能使用此函数
--  \n 通过回调函数cb返回非0, 来让C部分自动删除定时器
l_sys.remove_timer = function (id)
	return true
end


-- @brief 执行shell命令
-- @param [in] cmd[string] 需要执行的命令
-- @return [number] 0.成功; 非0.失败
--			[string]命令执行得到的结果字符串 
-- @note 函数会等待进程退出
l_sys.sh = function (cmd)
	return 0, '123456'
end


return l_sys
