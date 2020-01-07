--[[
-- Copyright(c) 2019, All Rights Reserved
-- Created: 2019/04/12
--
-- @file    l_broadcast_cli.lua
-- @brief   ��չ��"l_broadcast_cli", �㲥�ͻ���
--  \n ���к������� l_discover.init, l_discover.start ֮��ſ��Ե���
-- @version 0.1
-- @author  ������
-- @history �޸���ʷ
--  \n 2019/04/12 �����ļ�
-- @warning û�о���
--]]

local l_broadcast_cli = {}


-- @brief �򿪹㲥
-- @param [in]  	id[number]	id��
-- @param [in]		idx[number]	idx���
-- @param [in]		ip[string]	�㲥ip��ַ: ����'255.255.255.255', '192.168.255.255'
-- @param [in]		port[number] �㲥�˿�
-- @return [boolean] true, false
l_broadcast_cli.open = function (id, idx, ip, port)
	return true
end


-- @brief �رչ㲥
-- @param [in]  	id[number]	id��
-- @param [in]		idx[number]	idx���
-- @return [boolean] true, false
l_broadcast_cli.close = function (id, idx)
	return true
end


-- @brief �ر�����ͬһid�Ĺ㲥
-- @param [in]  	id[number]	id��
-- @return [boolean] true, false
l_broadcast_cli.close_all = function (id)
	return true
end


-- @brief ����һ��'discover'�������ݰ�
-- @param [in]  	id[number]	id��
-- @return [boolean] true, false
l_broadcast_cli.discover = function (id)
	return true
end


-- @brief ��ȡ�㲥����
-- @return  ret[boolean]	true.��ȡ������; false.û������
--	\n	code[number]		0.��ȡ�㲥��Ϣ; ��0.��ȡ��������
--	\n	body[string]		�㲥��Ϣ
--	\n	protocol[number]	Э��
--	\n	id[number]			id��
--	\n	ip[string]			���͹㲥��IP
--	\n	port[number]		�˿�
-- @note ע������,�μ�xxx
l_broadcast_cli.recv = function ()
	return true, 0, '{}', 22, 900, '192.168.1.247', 25354
end


-- @brief ���͹㲥����[string.len(body) <= 1340]
-- @param [in]  	id[number]		id��
-- @param [in]		body[string]	�����͵ĵ�����
-- @return [boolean] true, false
l_broadcast_cli.send = function (id, body)
	return true
end


return l_broadcast_cli