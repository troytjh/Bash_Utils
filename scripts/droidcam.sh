modprobe v4l2loopback-dc
modprobe v4l2loopback
rmmod v4l2loopback_dc
insmod /lib/modules/`uname -r`/extramodules/v4l2loopback-dc.ko.xz width=1280 height=720
modprobe snd-aloop
#pacmd load-module module-alsa-source device=hw:2,1,0
