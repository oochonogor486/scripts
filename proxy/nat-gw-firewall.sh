#! /usr/bin/bash

# src:"https://blog.redbranch.net/2015/07/30/centos-7-as-nat-gateway-for-private-network/"

# Configure the kernel to forward IP packets
# /etc/sysctl.conf

# Enables IP packet forwarding
# net.ipv4.ip_forward = 1

# Implement change dynamically to avoid rebooting
# sysctl -w net.ipv4.ip_forward=1

# Check if Firewall is installed
systemctl status firewalld
if [ $? -eq 0 ]
then
    sudo yum update
    sudo yum install iptables-services
    sudo sysctl -w net.ipv4.ip_forward=1
    sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    sudo service iptables save
    sudo yum install firewalld
fi

# Requires at least 2 network interfaces
firewall-cmd --zone=external --add-interface=eth0 --permanent
firewall-cmd --zone=internal --add-interface=eth1 --permanent

# Ensure edits are applied into running configuration
firewall-cmd --complete-reload

# Check internal and external zones for edits
firewall-cmd --list-all-zones

# Removes eth0 interface from internal zone
firewall-cmd --zone=internal --remove-interface=eth0

firewall-cmd --zone=external --add-masquerade --permanent

# firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I POSTROUTING -o eth0 -j MASQUERADE -s 10.89.0.0/16

firewall-cmd --permanent --zone=internal --add-service=dhcp
firewall-cmd --permanent --zone=internal --add-service=tftp
firewall-cmd --permanent --zone=internal --add-service=dns
firewall-cmd --permanent --zone=internal --add-service=http
firewall-cmd --permanent --zone=internal --add-service=https
firewall-cmd --permanent --zone=internal --add-service=nfs
firewall-cmd --permanent --zone=internal --add-service=ssh

# Reload then show all allowed services and zones 
firewall-cmd --complete-reload
firewall-cmd --permanent --zone=internal --list-services
firewall-cmd --list-all-zones
