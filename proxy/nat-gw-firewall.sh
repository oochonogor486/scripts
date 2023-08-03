#! /usr/bin/bash
#! /bin/bash

# src:"https://blog.redbranch.net/2015/07/30/centos-7-as-nat-gateway-for-private-network/"

# Configure the kernel to forward IP packets
# /etc/sysctl.conf

# Enables IP packet forwarding
# net.ipv4.ip_forward = 1

# Implement change dynamically to avoid rebooting
# sysctl -w net.ipv4.ip_forward=1

# Check if IPTables and Firewalld is installed
systemctl status firewalld
sudo yum update
sudo yum install iptables-services
sudo sysctl -w net.ipv4.ip_forward=1
sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo service iptables save
sudo yum install firewalld

# Requires at least 2 network interfaces
sudo firewall-cmd --zone=external --add-interface=eth0 --permanent
sudo firewall-cmd --zone=internal --add-interface=eth1 --permanent

# Ensure edits are applied into running configuration
sudo firewall-cmd --complete-reload

# Check internal and external zones for edits
sudo firewall-cmd --list-all-zones

# Removes eth0 interface from internal zone
sudo firewall-cmd --zone=internal --remove-interface=eth0

sudo firewall-cmd --zone=external --add-masquerade --permanent

# sudo firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o eth0 -j MASQUERADE -s 10.89.0.0/16

sudo firewall-cmd --permanent --zone=internal --add-service=dhcp
sudo firewall-cmd --permanent --zone=internal --add-service=dns
sudo firewall-cmd --permanent --zone=internal --add-service=http
sudo firewall-cmd --permanent --zone=internal --add-service=https
# sudo firewall-cmd --permanent --zone=internal --add-service=tftp
# sudo firewall-cmd --permanent --zone=internal --add-service=nfs
# sudo firewall-cmd --permanent --zone=internal --add-service=ssh

# Reload then show all allowed services and zones 
sudo firewall-cmd --complete-reload
sudo firewall-cmd --permanent --zone=internal --list-services
sudo firewall-cmd --list-all-zones
