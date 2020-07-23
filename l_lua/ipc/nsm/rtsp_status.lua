--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- Created: 2019/11/29
--
-- @file    rtsp_status.lua
-- @brief   rtsp常用状态
-- @author	李绍良
--]]


local rtsp_status = {}


rtsp_status.CONTINUE = 100
rtsp_status.OK = 200
rtsp_status.CREATED = 201
rtsp_status.LOW_ON_STORAGE_SPACE = 250
rtsp_status.MULTIPLE_CHOICES = 300
rtsp_status.MOVED_PERMANENTLY = 301
rtsp_status.MOVED_TEMPORARILY = 302
rtsp_status.SEE_OTHER = 303
rtsp_status.NOT_MODIFIED = 304
rtsp_status.USE_PROXY = 305
rtsp_status.BAD_REQUEST = 400
rtsp_status.UNAUTHORIZED = 401
rtsp_status.PAYMENT_REQUIRED = 402
rtsp_status.FORBIDDEN = 403
rtsp_status.NOT_FOUND = 404
rtsp_status.METHOD = 405
rtsp_status.NOT_ACCEPTABLE = 406
rtsp_status.PROXY_AUTH_REQUIRED = 407
rtsp_status.REQ_TIME_OUT = 408
rtsp_status.GONE = 410
rtsp_status.LENGTH_REQUIRED = 411
rtsp_status.PRECONDITION_FAILED = 412
rtsp_status.REQ_ENTITY_2LARGE = 413
rtsp_status.REQ_URI_2LARGE = 414
rtsp_status.UNSUPPORTED_MTYPE = 415
rtsp_status.PARAM_NOT_UNDERSTOOD = 451
rtsp_status.CONFERENCE_NOT_FOUND = 452
rtsp_status.BANDWIDTH = 453
rtsp_status.SESSION = 454
rtsp_status.STATE = 455
rtsp_status.INVALID_HEADER_FIELD = 456
rtsp_status.INVALID_RANGE = 457
rtsp_status.RONLY_PARAMETER = 458
rtsp_status.AGGREGATE = 459
rtsp_status.ONLY_AGGREGATE = 460
rtsp_status.TRANSPORT = 461
rtsp_status.UNREACHABLE = 462
rtsp_status.INTERNAL = 500
rtsp_status.NOT_IMPLEMENTED = 501
rtsp_status.BAD_GATEWAY = 502
rtsp_status.SERVICE = 503
rtsp_status.GATEWAY_TIME_OUT = 504
rtsp_status.VERSION = 505
rtsp_status.UNSUPPORTED_OPTION = 551

return rtsp_status
