#!/bin/bash

clear

echo -e "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
echo -e "                            Powered by Kalai & Rakesh                   \n"
INT=$(ip a)

echo -e "\n\n   \U1F4F6 IP A result \U1F4F6 \n\n ${INT} \n\n"

echo -e "       \U1F310 Check ping google.com \U1F310 \n"
H_NAME=$(hostname)
echo "root@$H_NAME ping google.com"
ping google.com -c5

echo -e "\n\n  \U1F310 Check nameserver \U1F310"
NS=$(cat /etc/resolv.conf)
echo -e "\n $NS \n\n"

#SERVICE=$(systemctl --type=service)
#echo "$SERVICE"

#echo -e "\U2699"
cat << EOF
 ⚙
   IP blocking services checking, 
        Service stopping
             and Service disabling
 ⚙
EOF

IPTABLE=$(iptables -F)
echo -e "\n *** iptables flashed ***\n"
 
systemctl list-units --type=service | awk '/firewalld|ufw|iptables|docker|warp/ {print $1}' | while read service; do
    echo -e "\n  \U1F6D1  Stopping and disabling $service... \U1F6D1"
    systemctl stop $service
    systemctl disable $service
done

echo -e "\n       \U1F310 Again check ping google.com \U1F310 \n"
H_NAME=$(hostname)
echo "root@$H_NAME ping google.com"
ping google.com -c5

echo -e "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
