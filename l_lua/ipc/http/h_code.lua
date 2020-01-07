--[[
-- Copyright(c) 2018-2025, 武汉舜立软件 All Rights Reserved
-- @brief 注意: 服务端回复数据必须填写'Content-Length'头域, 以提高浏览器响应速度
-- @author 李绍良
--]]

local h_code = {}

h_code.HTTP_SERVER = 'L-Lua-5.3'

-- 200 正常
h_code.HTTP_200 = 200


-- 302 重定向; 新的URL会在response中的Location中返回, 浏览器将会自动使用新的URL发出新的Request
h_code.HTTP_302 = 302


-- 客户端请求与语法错误
h_code.HTTP_400 = 400
h_code.HTTP_400_HEAD = 'HTTP/1.1 400 Bad Request\r\nServer: L-Lua-5.3\r\nContent-Length: 0\r\n\r\n'

-- 无授权
h_code.HTTP_401 = 401
h_code.HTTP_401_HEAD = 'HTTP/1.1 401 Unauthorized\r\nServer: L-Lua-5.3\r\nContent-Length: 0\r\n\r\n'

-- 服务端拒绝提供服务
h_code.HTTP_403 = 403
h_code.HTTP_403_HEAD = 'HTTP/1.1 403 Forbidden\r\nServer: L-Lua-5.3\r\nContent-Length: 0\r\n\r\n'

-- 未找到页面
h_code.HTTP_404 = 404
h_code.HTTP_404_HEAD = 'HTTP/1.1 404 Not Found\r\nServer: L-Lua-5.3\r\nContent-Length: 32\r\n\r\n'
h_code.HTTP_404_BODY = '<h1>Not Found</h1>\r\n<h2>404</h2>'

return h_code
