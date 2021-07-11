#!/bin/bash

set_status() {
	if [ -z "${1}"]; then
		${2}=false
	else
		${2}=true	
}

echo "This scripts serves to act as a single execution script to quickly and efficiently provision a basic security setup on your server, particularly a servers that are immediately exposed to the web [E.G: servers spun up on data centers]."
echo "[NOTICE] It is recommended to have already made a SSH key pair for your remote host(s) and server, that is because this script will modify openSSH configs to deny certain parameters such as root login"
echo "This script currently serves the following Linux flavors:"
echo "- Debian buster/10"


while true; do
	read -p "proceed?[y/n](default: y):" yn
	if [ "${yn}" = "y" ]; then
		break
	elif [ "${yn}" = "n" ]; then
		exit 0
	else
		echo "Invalid input, please try again"
	fi
done

set -e

CLEANUP=( )

cleanup() {
	read -p "The script did not complete, remove added packages as well?" yn
	if [ "${yn}" = "y" ]; then
		CLEANUP+=("apt-get --purge remove -y ufw, fail2ban, net-tools")
	fi
	if [ ${#CLEANUP[*]} -gt 0 ]; then
		LAST_ELEMENT=$((${CLEANUP[*]}-1))
		REVERSE_INDEXES=$(seq ${LAST_ELEMENT} -1 0)
		for i in $REVERSE_INDEXES; do
			${CLEANUP[$i]}
		done
	fi
}

trap cleanup EXIT

exit 0

sudo apt-get update


sudo apt-get install -y ufw, fail2ban, net-tools, snort

# TODO:
# - setup basic snort configs
# - further modify ufw settings
# 	- be able to parse and look for ports that are not 22
#	- any other ideas....etc
# - further modify open ssh configs
# - fine tune openssh
# - configure snort

# UFW set up
# ==========

CLEANUP+=("sudo ufw deny 22")
CLEANUP+=("sudo ufw disable")
sudo ufw allow 22
sudo ufw enable 

# sshd_config
# ===========

sshconf_dir="/etc/ssh/sshd_config"


sudo sed 's/# #PermitRootLogin yes/PermitRootLogin no/' ${sshconf_dir}
sudo sed 's/# #PasswordAuthentication yes/PasswordAuthentication no/' ${sshconf_dir}
sudo systemctl restart 


SSH_service_status="${sudo systemctl status ssh | grep "active (running)"}"

set_status SSH_service_status SSH_status
