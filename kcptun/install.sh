#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

cp -r /tmp/kcptun/* $KSROOT/
chmod a+x $KSROOT/scripts/kcptun_*
chmod a+x $KSROOT/bin/kcptun

# add icon into softerware center
dbus set softcenter_module_kcptun_install=1
dbus set softcenter_module_kcptun_version=0.1
dbus set softcenter_module_kcptun_description="kcptun加速"
rm -rf $KSROOT/install.sh