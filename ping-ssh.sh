#!/bin/bash

clear

echo -e "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
echo -e "                        Powered by Kalaiyarasan              \n"
echo -e "*** This script will check ping and ssh ***\n"

read -p "Enter IP: " IP
read -p "If you have SSH port, enter here or leave it empty: " PORT
echo -e "\n *** Script will run now. Please wait few seconds ***\n"

p_output=$(ping $IP -c5)

TERMINAL=$(hostname)

echo -e "root@${TERMINAL}:~# ping $IP" 
echo -e "$p_output\n"

if [[ -n "$PORT" ]]; then
	echo "root@${TERMINAL}:~# ssh $IP -p $PORT"
	ssh $IP -p $PORT
else
	echo "root@${TERMINAL}:~# ssh $IP"
	ssh $IP
fi

#s_output=$(ssh $IP)

#echo "root@terminal:~# ssh $IP" 
#echo "$s_output"

echo -e "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
