#!/bin/bash

# curl https://raw.githubusercontent.com/snooops/setup-pimox/main/setup-pimox.sh | bash

cat > /etc/hosts <<EOF
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

192.168.1.210   sif
192.168.1.211   odin
192.168.1.212   thor
192.168.1.213   loki
EOF

echo 'deb [arch=arm64] https://de.mirrors.apqa.cn/proxmox/debian/pve bookworm port'>/etc/apt/sources.list.d/pveport.list

curl -L https://mirrors.apqa.cn/proxmox/debian/pveport.gpg -o /etc/apt/trusted.gpg.d/pveport.gpg 

apt update && apt full-upgrade -y

apt install ifupdown2 vim -y

apt install proxmox-ve postfix open-iscsi -y

ipaddress=$(ip a |grep eth0 |grep inet |awk '{print $2}')

cat > /etc/network/interfaces <<EOF
# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d


auto eth0
iface eth0 inet manual


auto vmbr0
iface vmbr0 inet static
        address ${ipaddress}
        gateway 192.168.1.1
        dns-nameservers 192.168.1.1
        bridge-ports eth0
        bridge-stp off
        bridge-fd 0
EOF

#pveceph install
#apt install ceph-volume -y && reboot
#ceph-volume lvm zap /dev/sda --destroy
#pveceph osd create /dev/sda
