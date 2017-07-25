#!/bin/bash
# iptables configuration script

# Flush all current rules from iptables
 iptables -F

# Allow SSH connections on tcp port 22
 iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Set default policies for INPUT, FORWARD and OUTPUT chains
 iptables -P INPUT DROP
 iptables -P FORWARD DROP
 iptables -P OUTPUT ACCEPT

# Set access for localhost
 iptables -A INPUT -i lo -j ACCEPT

# Accept packets belonging to established and related connections
 iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Accept httpd/https requests
 iptables -A INPUT -p tcp --dport 80 -j ACCEPT
 iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Accept FTP requests & data (data is on port 20)
# iptables -A INPUT -p tcp --sport 1024: --dport 21 -m state --state NEW,ESTABLISHED -j ACCEPT

# Save settings
 /sbin/service iptables save

# List rules
 iptables -S
