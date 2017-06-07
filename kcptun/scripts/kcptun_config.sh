#!/bin/sh

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export kcptun_`

start_kcptun(){
    arg="-l :$kcptun_lport -r $kcptun_serverip:$kcptun_serverport -key $kcptun_key -mtu $kcptun_mtu -sndwnd $kcptun_sndwnd -rcvwnd $kcptun_rcvwnd -mode $kcptun_mode --conn $kcptun_conn"
    if [ $kcptun_nocomp == "true" ];then
        arg="$arg --nocomp"
    fi
    $KSROOT/bin/kcptun  $arg >/dev/null 2>&1 &
    version=`$KSROOT/bin/kcptun --version|cut -d' ' -f3`
    if [ -n "`ps|grep $KSROOT/bin/kcptun|grep -v grep`" ];then
        ln -sf $KSROOT/scripts/kcptun_config.sh $KSROOT/init.d/S95kcptun.sh
        dbus set kcptun_last_act="<font color=green>服务已开启</font>  [kcptun版本:$version]"
    else
        dbus set kcptun_enable=0
    fi
}

stop_kcptun(){
    version=`$KSROOT/bin/kcptun --version|cut -d' ' -f3`
    PID=`ps | grep "$KSROOT/bin/kcptun" | grep -v grep | awk '{print $1}'`
    if [[ "" !=  "$PID" ]]; then
        kill -9 $PID
    fi
    if [ -L "$KSROOT/init.d/S95kcptun.sh" ]; then 
		    rm -rf $KSROOT/init.d/S95kcptun.sh
	fi
    dbus set kcptun_last_act="<font color=red>服务未开启</font>  [kcptun版本:$version]"
}

case $ACTION in
start)
	if [ "$kcptun_enable" = "1" ]; then
        #stop_kcptun
        start_kcptun
        if [ ! -L "$KSROOT/init.d/S95kcptun.sh" ]; then 
		    ln -sf $KSROOT/scripts/kcptun_config.sh $KSROOT/init.d/S95kcptun.sh
	    fi
        logger "[软件中心]: 启动kcptun！"
    else
        logger "[软件中心]: kcptun未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_kcptun
    logger "[软件中心]: 关闭kcptun！"
	;;
*)
	if [ "$kcptun_enable" = "1" ]; then
        stop_kcptun
        
        start_kcptun
        
        logger "[软件中心]: 启动kcptun！"
    else
    
    stop_kcptun
    
    logger "[软件中心]: 关闭kcptun！"
    fi
    http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
