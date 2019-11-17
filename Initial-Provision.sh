#!/bin/bash
set -e
PROXY=$1
USERNAME=$2
PASSWORD=$3
PROXYSERVER=$4
PROXYPORT=$5
DATE=`date +%d-%m-%Y-%H:%M:%S`
WHOAMI=`whoami`
if [ -f /etc/os-release ]; then
    os_name="$(awk -F= '/^NAME/{ print $2 }' /etc/os-release | sed 's/"//g')"
    os_version_id="$(awk -F= '/^VERSION_ID/{ print $2}' /etc/os-release | sed 's/"//g')"
    echo "Operating-System:$os_name"
    echo "Version:$os_version_id"
fi

echo "[${DATE}] ----> Start to supply Virtual Machinne <---- "
echo " ----> You are running as [${WHOAMI}]   <----"
if [ "$1" == "yes" ]
then
	#Config_proxy
	touch /etc/apt/apt.conf 
	echo """Acquire::http::proxy \"http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/\"; 
			Acquire::ftp::proxy \"ftp://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/\"; 
			Acquire::https::proxy \"https://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/\"; 
	"""> /etc/apt/apt.conf
	echo """http_proxy=\"http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/\" 
	https_proxy=\"http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/\" """ >> /etc/environment
	#Need to log out to setting config
	source /etc/environment
	#In-the-current-process
	export http_proxy="http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/"
	export https_proxy="http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/"
fi
#Remove apt/list 
rm -rf /var/lib/apt/lists/*
#name-resolution ( host -v x.com)
echo """
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 162.213.33.8
nameserver 162.213.33.9
""">>/etc/resolv.conf
#
apt-get update
#Install Ansible
apt-get install  -y software-properties-common
apt-add-repository --yes  ppa:ansible/ansible
apt-get install -y ansible
#Default java_version :1.7
apt-get install -y maven
#Installgit
apt-get install -y git
#Install-Docker
apt-get -y install docker.io
ln -sf /usr/bin/docker.io /usr/local/bin/docker
sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker
update-rc.d docker defaults
usermod -a -G docker vagrant
service docker status
#Config-Download-Docker-Images
if [ "$1" == "yes" ]
then
	echo """export http_proxy=\"http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/\"
	export https_proxy=\"http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/\" """ >> /etc/default/docker
	service docker restart
fi	
#Test
docker pull alpine
docker images
#End-Test
#
echo " Finish to supply Virtual Machinne "
