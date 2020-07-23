--[[
-- Copyright(c) 2018-2025, All Rights Reserved
-- Created: 2018/12/21
--
-- @file    l_on_exit.lua
-- @brief   内置公共函数"l_on_exit", 只被内置在 llua主线程中
-- @version 0.1
-- @author  李绍良
-- @history 修改历史
--  \n 2018/12/21 0.1 创建文件
-- @warning 没有警告
--]]


-- @brief 当系统在任何情况下的退出回调函数
-- @param [in] cb[function] 回调函数
-- @note cb函数原型 
--  \n cb = function () return 0 end
--  \n return 0 结束
--  \n win退出含义: 正常退出
--  \n linux退出含义: 正常退出, 信号SIGINT, SIGTERM, SIGKILL, SIGTSTP
local l_on_exit = function (cb)

end

return l_on_exit
