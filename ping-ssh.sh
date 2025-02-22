#!/bin/bash

clear

echo -e "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
echo -e "                        Powered by Kalaiyarasan              \n"
echo -e "*** This script will check ping and ssh ***\n"

read -p "Enter IP: " IP

echo -e "\n *** Script will run now. Please wait few seconds ***\n"

p_output=$(ping $IP -c5)

echo "root@terminal:~# ping $IP" 
echo -e "$p_output\n"

echo "root@terminal:~# ssh $IP"
ssh $IP
#s_output=$(ssh $IP)

#echo "root@terminal:~# ssh $IP" 
#echo "$s_output"

echo -e "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
