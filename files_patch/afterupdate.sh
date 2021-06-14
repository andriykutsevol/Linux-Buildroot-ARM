#!/bin/sh
#Set permition.
crontab cronbak
chmod a+x usr/bin/place
chmod a+x usr/bin/sputnik
chmod a+x usr/bin/nmea
chmod a+x usr/bin/Demetro/Demetro
chmod a+x usr/bin/mparam/mparam
chmod a+x usr/bin/M50Update.sh
chmod a+x usr/bin/mconfig
chmod a+x usr/bin/mserial
chmod a+x usr/bin/mversion
chmod a+x usr/bin/mtest
chmod a+x usr/bin/t_mconfig
chmod a+x usr/bin/minfo
chmod 666 usr/bin/Demetro/boot.cfg
chmod a+x etc/profile
chmod 777 srv/www/cgi-bin/web.cgi
chmod 777 srv/www/cgi-bin/set_ethernet_sh.cgi
chmod 777 srv/www/cgi-bin/set_ntp_sh.cgi
chmod 777 srv/www/cgi-bin/set_dns_sh.cgi
chmod 777 srv/www/cgi-bin/set_config_sh.cgi
chmod 777 srv/www/cgi-bin/onload_cfg_sh.cgi
chmod 777 srv/www/cgi-bin/onload_net_sh.cgi
chmod 666 srv/www/js/pjueAjaxForm.js
chmod 666 srv/www/pages/ethernet.html
chmod 666 srv/www/pages/config.html
#cp /var/volatile/tmp/patch/manifest /usr/bin/Demetro/
