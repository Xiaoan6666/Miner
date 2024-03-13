#!/bin/bash

CORES=$(cat /proc/cpuinfo | grep "processor" | wc -l)
ARCH=$(lscpu | grep Architecture | awk '{print $2}')

if [ "$ARCH" = "x86_64" ]; then
    echo "CPU架构为X86"
    ./xmrig -a ghostrider --url ghostrider.asia.mine.zergpool.com:5354 -x 120.46.167.34:15733 --user ydq2iBgJ8GQEshVS8J1U4V7VazVFHe7M68.X86 -p c=YERB,mc=YERB,m=solo,ID=X86 -t $CORES -B
elif [ "$ARCH" = "aarch64" ]; then
    echo "CPU架构为ARM"
    ./xmrigDaemon -a ghostrider -o stratum+tcp://ghostrider.asia.mine.zergpool.com:5354 -x 120.46.167.34:15733 -u ydq2iBgJ8GQEshVS8J1U4V7VazVFHe7M68 -p c=YERB,mc=YERB,m=solo,ID=ARM -t $CORES -B
else
    echo "无法确定CPU架构"
fi

if pgrep xmrigMiner >/dev/null; then
    echo "xmrigMiner进程正在运行"
elif pgrep xmrig >/dev/null; then
    echo "xmrig进程正在运行"
else
    echo "xmrigMiner和xmrig进程均未运行"
fi

while true
do
    echo "当前CPU使用率："
    top -bn 1 | grep '%Cpu' | awk '{print "用户态：" $2 ", 系统态：" $4 ", 空闲：" $8}'
    sleep 3
done
