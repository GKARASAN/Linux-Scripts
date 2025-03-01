#!/bin/bash

clear

echo -e "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
echo -e "                        Powered by Kalai, Rajesh & Rakesh                   \n"

INT=$(ip a)

echo -e "\n\n   \U1F4F6 IP A result \U1F4F6 \n\n ${INT} \n\n"

STATE=$(ip a | grep -E '^[0-9]+:|state' | grep -oP '^[0-9]+: \K\w+|state \K\w+' | sed -n '4p')
INT_NAME=$(ip a | grep -oP '^\d+: \K\w+' | sed -n '2p')

if [ "$STATE" == "UP" ]; then
   echo "Interface is UP, running next command..."
else
   echo "Interface is DOWN, bringing it UP..."
   UP=$(ip link set $INT_NAME up)
fi

OS_NAME=$(grep -oP '^NAME="\K[^"]+' /etc/os-release)

# Check the OS and restart the appropriate network service
if [[ "$OS_NAME" == "Ubuntu" || "$OS_NAME" == "Debian" ]]; then
  echo "$OS_NAME detected. Restarting network service..."
  systemctl restart networking

elif [[ "$OS_NAME" == "CentOS" || "$OS_NAME" == "Red Hat" || "$OS_NAME" == "Fedora" ]]; then
  echo "$OS_NAME detected. Restarting network service..."
  systemctl restart network

elif [[ "$OS_NAME" == "AlmaLinux" ]]; then
  echo "$OS_NAME detected. Restarting network service..."
  systemctl restart NetworkManager
fi

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
