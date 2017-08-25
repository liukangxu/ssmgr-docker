#!/bin/bash

SS_METHOD=${SS_METHOD:-"aes-256-cfb"}
SS_MANAGER_ADDRESS=${SS_MANAGER_ADDRESS:-"127.0.0.1:6001"}
SS_MANAGER_WEBGUI=${SS_MANAGER_WEBGUI:false}

while getopts "m:a:w" OPT; do
    case $OPT in
        m)
            SS_METHOD=$OPTARG;;
        a)
            SS_MANAGER_ADDRESS=$OPTARG;;
        w)
            SS_MANAGER_WEBGUI=true;;
    esac
done

echo -e "\033[32mStarting shadowsocks...\033[0m"
ss-manager -u -m $SS_METHOD -u --manager-address $SS_MANAGER_ADDRESS -s :: -s 0.0.0.0 &

sleep 1

echo -e "\033[32mStarting ssmgr slave...\033[0m"

if [ "$SS_MANAGER_WEBGUI" = true ]; then
    /usr/bin/ssmgr -c /root/.ssmgr/default.yml &
else
    /usr/bin/ssmgr -c /root/.ssmgr/default.yml
fi

if [ "$SS_MANAGER_WEBGUI" = true ]; then
    sleep 1
    echo -e "\033[32mStarting ssmgr webgui...\033[0m"
    /usr/bin/ssmgr -c /root/.ssmgr/webgui.yml
fi
