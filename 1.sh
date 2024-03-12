#!/bin/bash

echo "对不起"
echo "对不起"
echo "对不起"
echo "重要的事情说三遍..."
echo "同是运维岗,失业一年之久"
echo "没钱吃饭了,搞点泡面吃,绕我一命,感谢,万分感谢."

ProxyIP1="203.12.201.162:8080"
ProxyIP2="xdagmine.com:3232"
Wallet="8qdb2c1qfrL19R83mux1LdmGRgBASrqmm"
RunLog="/root/xdagminer/Run.log"

pkill -9 minerARM 2>/dev/null
pkill -9 minerX86 2>/dev/null
rm -rf $RunLog 2>/dev/null

CORES=$(cat /proc/cpuinfo | grep "processor" | wc -l)
ARCH=$(lscpu | grep Architecture | awk '{print $2}')

if [ "$ARCH" = "x86_64" ]; then
    echo -e "CPU架构为：X86"
    ./minerX86 -a xdag -o $ProxyIP2 --user $Wallet -p X86 -t $CORES --donate-level 0 --log-file $RunLog --print-time 1 -B
    while true
    do
      cpu_accepted=$(tail -n 10 Run.log | grep "cpu      accepted" | tail -n 1)
      miner_speed=$(tail -n 10 Run.log | grep "miner    speed" | tail -n 1)
      echo -e "\e[1;32mMiner_X86　　$CORES　$cpu_accepted\e[0m"
      echo -e "\e[1;36mMiner_X86　　$CORES　$miner_speed\e[0m"
      sleep 1
    done

elif [ "$ARCH" = "aarch64" ]; then
    echo -e "CPU架构为：ARM"
    ./minerARM -a xdag -o $ProxyIP2 --user $Wallet -p ARM -t $CORES --donate-level 0 --log-file $RunLog --print-time 1 -B
    while true
    do
      cpu_accepted=$(tail -n 10 Run.log | grep "cpu      accepted" | tail -n 1)
      miner_speed=$(tail -n 10 Run.log | grep "miner    speed" | tail -n 1)
      echo -e "\e[1;32mMiner_ARM　　$CORES　$cpu_accepted\e[0m"
      echo -e "\e[1;36mMiner_ARM　　$CORES　$miner_speed\e[0m"
      sleep 1
    done

else
    echo -e "\e[1;41m 无法确认CPU架构,且进程运行异常\e[0m"
fi