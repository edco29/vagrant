#!/bin/bash
set -e
Proxy=$1
Username=$2
Password=$3
ProxyServer=$4
ProxyPort=$5
Date=`date +%d-%m-%Y-%H:%M:%S`

#: <<'end_long_comment'
if [ -f /etc/os-release ]; then
    os_name="$(awk -F= '/^NAME/{ print $2 }' /etc/os-release | sed 's/"//g')"
    os_version_id="$(awk -F= '/^VERSION_ID/{ print $2}' /etc/os-release | sed 's/"//g')"
    echo "Operating-System:$os_name"
    echo "Version:$os_version_id"
fi

echo "[${Date}] ----> Start to supply Virtual Machinne <---- "
if [ "${Proxy}" == "yes" ]
then
	#Config_proxy
	touch /etc/apt/apt.conf 
	echo """Acquire::http::proxy \"http://${Username}:${Password}@${ProxyServer}:${ProxyPort}/\"; 
			Acquire::ftp::proxy \"ftp://${Username}:${Password}@${ProxyServer}:${ProxyPort}/\"; 
			Acquire::https::proxy \"https://${Username}:${Password}@${ProxyServer}:${ProxyPort}/\"; 
	"""> /etc/apt/apt.conf

	echo """http_proxy=\"http://${Username}:${Password}@${ProxyServer}:${ProxyPort}/\" 
	https_proxy=\"http://${Username}:${Password}@${ProxyServer}:${ProxyPort}/\" """ >> /etc/environment
	#Need to log out to setting config
	source /etc/environment

	#In-the-current-process
	export http_proxy="http://${Username}:${Password}@${ProxyServer}:${ProxyPort}/"
	export https_proxy="http://${Username}:${Password}@${ProxyServer}:${ProxyPort}/"
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
#Use apt-get instead apt
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
if [ "${Proxy}" == "yes" ]
then
	echo """export http_proxy=\"http://${Username}:${Password}@${ProxyServer}:${ProxyPort}/\"
	export https_proxy=\"http://${Username}:${Password}@${ProxyServer}:${ProxyPort}/\" """ >> /etc/default/docker
	service docker restart
fi	
#Test
docker pull alpine
docker images
#End-Test
#end_long_comment
echo " [${Date}] ----> Finish to supply Virtual Machinne <---- "

