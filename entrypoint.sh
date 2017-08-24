#!/bin/bash

SS_METHOD=${SS_METHOD:-"aes-128-cfb"}
SS_MANAGER_ADDRESS=${SS_MANAGER_ADDRESS:-"127.0.0.1:6001"}

while getopts "m:a:" OPT; do
    case $OPT in
        m)
            SS_METHOD=$OPTARG;;
        a)
            SS_MANAGER_ADDRESS=$OPTARG;;
    esac
done

echo -e "\033[32mStarting shadowsocks...\033[0m"
ss-manager -u -m $SS_METHOD -u --manager-address $SS_MANAGER_ADDRESS &

echo -e "\033[32mStarting ssmgr slave...\033[0m"
/usr/bin/ssmgr -c /root/.ssmgr/default.yml
