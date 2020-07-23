--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- Created: 2018/12/21
--
-- @file  b_list.lua
-- @brief 双向链表
-- @author 李绍良
--]]

local b_list  = {}


b_list.push_back = function (l, value)
	local node = {
		prev = nil,
		pnext = nil,
		
		value = value
	}

	if nil ~= l.back then
		node.prev = l.back
		l.back.pnext = node
	end	
	
	if nil == l.front then
		l.front = node
	end
	
	l.back = node	
	l.size = l.size + 1
end


b_list.push_front = function (l, value)
	local node = {
		prev = nil,
		pnext = nil,
		
		value = value
	}

	if nil ~= l.front then
		node.pnext = l.front
		l.front.prev = node
	end
	
	if nil == l.back then
		l.back = node
	end
	
	l.front = node	
	l.size = l.size + 1
end


b_list.pop_back = function (l)
	if 0 < l.size then
		local v = l.back
		l.back = v.prev
		l.size = l.size - 1	
		
		if l.size <= 0 then
			l.front = nil
			l.back = nil
		end
		
		return v.value
	end

	return nil
end


b_list.pop_front = function (l)
	if 0 < l.size then
		local v = l.front
		l.front = v.pnext				
		l.size = l.size - 1
		
		if l.size <= 0 then
			l.front = nil
			l.back = nil
		end
		
		return v.value
	end
	
	return nil
end


b_list.size = function (l)
	return l.size
end


b_list.create = function ()
	local l = {
		size = 0,
		
		front = nil,
		back = nil
	}	
	
	return l
end


b_list.begin = function (l)
	return l.front
end


b_list.iter_add = function (iter)
	if nil ~= iter then
		return iter.pnext
	end
	
	return nil
end

b_list.iter_value = function (iter)
	if nil ~= iter then
		return iter.value
	end
	
	return nil
end


b_list.remove = function (l, iter)	
	if nil ~= iter and 0 < l.size then
		local prev = iter.prev
		local pnext = iter.pnext
		
		if nil ~= prev then
			prev.pnext = pnext
		else
			l.front = pnext
		end
		
		if nil ~= pnext then
			pnext.prev = prev
		else
			l.back = prev
		end
		
		l.size = l.size - 1	
		if l.size <= 0 then
			l.front = nil
			l.back = nil
		end
		
		return iter.value
	end
	
	return nil
end

return b_list


--[[ 迭代示例
local iter = b_list.begin(l)
while nil ~= iter do	
	local pnext = b_list.iter_add(iter)
	
	b_list.remove(iter)
	iter = pnext
end
--]]
