local l_sys = require("l_sys")
local sh = l_sys.sh

local hi_3516a_driver = {}

-- 加载驱动
hi_3516a_driver.load = function()

	print('hi_3516a load driver start...')
	
--[[	
	sh('mkdir /dev/misc')

	sh('/komod/pinmux_hi3516a.sh > /dev/null')	
	sh('/komod/clkcfg_hi3516a.sh > /dev/null')
	sh('/komod/sysctl_hi3516a.sh 0 > /dev/null')
	sh('insmod /komod/mmz.ko mmz=anonymous,0,0x88000000,378M anony=1 || report_error')
	sh('insmod /komod/hi_media.ko')
	sh('insmod /komod/hi3516a_base.ko')
	sh('insmod /komod/hi3516a_sys.ko vi_vpss_online=0 sensor=imx290')
	
	sh('insmod /komod/hi3516a_tde.ko')
	sh('insmod /komod/hi3516a_region.ko')
	sh('insmod /komod/hi3516a_vgs.ko')
	
	sh('insmod /komod/hi3516a_isp.ko')
	sh('insmod /komod/hi3516a_viu.ko detect_err_frame=10')
	sh('insmod /komod/hi3516a_vpss.ko')
	sh('insmod /komod/hi3516a_vou.ko')
	sh("insmod /komod/hifb.ko video=\"hifb:vram0_size:32400\"")
	sh('insmod /komod/hi3516a_rc.ko')
	sh('insmod /komod/hi3516a_venc.ko')
	sh('insmod /komod/hi3516a_chnl.ko')
	sh('insmod /komod/hi3516a_h264e.ko')
	sh('insmod /komod/hi3516a_h265e.ko')
	sh('insmod /komod/hi3516a_jpege.ko')
	sh('insmod /komod/hi3516a_vda.ko')
	sh('insmod /komod/hi3516a_ive.ko')
	
	sh('insmod /komod/hi_rtc.ko')
	sh('insmod /komod/extdrv/sensor_i2c.ko')
	sh('insmod /komod/extdrv/pwm.ko')
	sh('insmod /komod/io_c202.ko')
	
	sh('insmod /komod/extdrv/wdt.ko')
	
	sh('ln /dev/hi_rtc /dev/misc/hi_rtc -s')
	sh('ln /dev/io_dev /dev/misc/io_dev -s')
	sh('ln /dev/watchdog /dev/misc/watchdog -s')
	sh('ln /dev/pwm /dev/misc/pwm -s')
	
	sh('himm 0x200f0050 0x1')
	sh('himm 0x200f0054 0x1')
	sh('himm 0x200f0058 0x1')
	sh('himm 0x200f005c 0x1')
	sh('himm 0x2003002c 0x90007')
	sh('insmod /komod/extdrv/sensor_spi.ko')
	
	sh('insmod /komod/hi_mipi.ko')
	sh('insmod /komod/9022.ko')
--]]	
	
	print('hi_3516a load driver end.')
end

-- 卸载驱动
hi_3516a_driver.unload = function()

	print('hi_3516a unload driver start...')
	

--[[	
	sh('rmmod hi_i2c_new &> /dev/null')
	sh('rmmod ssp &> /dev/null')
	sh('rmmod ssp_sony &> /dev/null')
	sh('rmmod ssp_pana &> /dev/null')
	
	sh('rmmod 9022.ko')
	sh('rmmod sil9034 &> /dev/null')
	sh('rmmod pwm')
	sh('rmmod hi3516a_ive')
	sh('rmmod hi3516a_vda')
	sh('rmmod hi3516a_rc')
	sh('rmmod hi3516a_jpege')
	sh('rmmod hi3516a_h264e')
	sh('rmmod hi3516a_h265e')
	sh('rmmod hi3516a_chnl')
	sh('rmmod hi3516a_venc')
	sh('rmmod hifb')
	sh('rmmod hi3516a_vou')
	sh('rmmod hi3516a_vpss')
	sh('rmmod hi3516a_viu')
	sh('rmmod hi_mipi')
	sh('rmmod ssp_ad9020')
	sh('rmmod hi3516a_vgs')
	sh('rmmod hi3516a_region')
	sh('rmmod hi3516a_tde')
	sh('rmmod hi_i2c_new.ko &> /dev/null')
	sh('rmmod hi3516a_isp')
	sh('rmmod hi3516a_sys')
	sh('rmmod hi3516a_base')
	sh('rmmod hi_media')
	sh('rmmod mmz')
	sh('rmmod io_c202.ko')
--]]	
	
	print('hi_3516a unload driver end.')
end

return hi_3516a_driver
