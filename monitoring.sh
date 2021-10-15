#!/bin/bash

#Architecture de la machine & Kernel version
echo -n "Architecture : "
uname -a

#Nombre de proc physique
echo -n "CPU physical : "
grep "physical id" /proc/cpuinfo | sort -u | wc -l

#Nombre de proc logique
echo -n "vCPU : "
grep -c "processor" /proc/cpuinfo

#Memoire use
TOTAL_MEM=$(free --total -m | grep "Total" | tr -s " " | cut -d ' ' -f 2);
USED_MEM=$(free --total -m | grep "Total" | tr -s " " | cut -d ' ' -f 3);
CALCUL=$((100 * $USED_MEM / $TOTAL_MEM));

echo "Memory Usage :" $USED_MEM/$TOTAL_MEM Mo \($CALCUL\%\)

#Disque utilise
TOTAL_DISK=$(df --total -m | grep "total" | tr -s " " | cut -d ' ' -f 2);
USED_DISK=$(df --total -m | grep "total" | tr -s " " | cut -d ' ' -f 3);
PCENT_DISK=$(df --total -h | grep "total" | tr -s " " | cut -d ' ' -f 5);

echo "Disk Usage :" $USED_DISK/$TOTAL_DISK \($PCENT_DISK\)

#% proc utilise
uptime | awk '{printf("CPU Load : %.2f%%\n", $9) }'
echo -n "or : "
top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}'
#Last reboot
echo -n "Last reboot : "
who -b | cut -c23-

#Etat de LVM
USE_LVM=$(cat /etc/fstab | grep /dev/mapper | wc -l);

if [[ $USE_LVM -eq 0 ]]
then
	echo "LVM is OFF"
else
	echo "LVM is ON"
fi

#Nombre de connection
echo -n "Connexions TCP : "
lsof -ni:4242 -sTCP:ESTABLISHED | grep TCP | wc -l

#Connexions en cour
echo -n "User log : "
who | wc -l

#IPV4 + MAC
echo -n "IVP4 : "
hostname --all-ip-addresses
echo -n "MAC : "
ip a | grep ether | tr -s " " | cut -d ' ' -f 3

#Nombre de command sudo
echo -n "Sudo command : "
cat /var/log/sudo/sudo.log | grep "COMMAND=" | wc -l

#ctrl + c signal

