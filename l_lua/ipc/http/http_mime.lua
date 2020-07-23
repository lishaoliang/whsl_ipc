--[[
-- Copyright(c) 2019, 武汉舜立软件 All Rights Reserved
-- brief  http mime 对照表
-- @author 李绍良
--]]

-- mime 对照表: http://tool.oschina.net/commons
local http_mime = {
	asp = 'text/asp',
	awf = 'application/vnd.adobe.workflow',
	apk = 'application/vnd.android.package-archive',
	avi = 'video/avi',
	
	bmp = 'application/x-bmp',
	
	cml = 'text/xml',
	cmx = 'application/x-cmx',
	css = 'text/css',
	crt = 'application/x-x509-ca-cert',
	
	dcd = 'text/xml',
	doc = 'application/msword',
	drw = 'application/x-drw',
	dwg = 'application/x-dwg',
	dxf = 'application/x-dxf',
	dbf = 'application/x-dbf',
	dcx = 'application/x-dcx',
	dll = 'application/x-msdownload',
	dot = 'application/msword',
	dwf = 'application/x-dwf',
	
	emf = 'application/x-emf',	
	exe = 'application/x-msdownload',

	gif = 'image/gif',
	gl2 = 'application/x-gl2',

	html = 'text/html',
	htm = 'text/html',
	htx = 'text/html',
	hgl = 'application/x-hgl',

	icb = 'application/x-icb',
	ico = 'image/x-icon',
	img = 'application/x-img',
	iii = 'application/x-iphone',

	jpe = 'image/jpeg',	
	jpeg = 'image/jpeg',
	jpg = 'image/jpeg',
	js = 'text/javascript',	
	json = 'application/json',		-- https://tools.ietf.org/html/rfc4627
	jsp = 'text/html',
	jfif = 'image/jpeg',

	m2v = 'video/x-mpeg',
	m4e = 'video/mpeg4',
	mp1 = 'audio/mp1',
	mp2v = 'video/mpeg',
	mp4 = 'video/mpeg4',
	mpeg = 'video/mpg',
	mtx = 'text/xml',
	m1v = 'video/x-mpeg',
	mml = 'text/xml',
	mp2 = 'audio/mp2',
	mp3 = 'audio/mp3',
	mpa = 'video/x-mpg',
	mpe = 'video/x-mpeg',
	mpg = 'video/mpg',
	md = 'text/x-markdown',

	pdf = 'application/pdf',
	png = 'image/png',
	plg = 'text/html',
	ppt = 'application/x-ppt',
	
	rmvb = 'application/vnd.rn-realmedia-vbr',
	
	sdp = 'application/sdp',
	svg = 'text/xml',
	stm = 'text/html',
	
	tif = 'image/tiff',
	tiff = 'image/tiff',
	tga = 'application/x-tga',
	torrent = 'application/x-bittorrent',
	txt = 'text/plain',
	
	uls = 'text/iuls',
	
	vml = 'text/xml',
	vsd = 'application/vnd.visio',
	vxml = 'text/xml',
	
	wav = 'audio/wav',
	wasm = 'application/wasm',

	xls = 'application/x-xls',
	xml = 'text/xml',
	xsl = 'text/xml',
	xwd = 'application/x-xwd'
}

-- default = 'application/octet-stream'

return http_mime
