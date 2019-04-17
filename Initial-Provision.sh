#!/bin/bash
set -e
PROXY=$1
USERNAME=$2
PASSWORD=$3
PROXYSERVER=$4
PROXYPORT=$5
DATE=`date +%d-%m-%Y-%H:%M:%S`
if [ -f /etc/os-release ]; then
    os_name="$(awk -F= '/^NAME/{ print $2 }' /etc/os-release | sed 's/"//g')"
    os_version_id="$(awk -F= '/^VERSION_ID/{ print $2}' /etc/os-release | sed 's/"//g')"
    echo "Operating-System:$os_name"
    echo "Version:$os_version_id"
fi

echo "[${DATE}] ----> Start to supply Virtual Machinne <----"

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
apt-get update

#Install-python3
#cd /home/vagrant/ && wget --no-check-certificate https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz
#tar -xvzf *tgz  && rm -rf *tgz && cd Py* && ./configure --enable-optimizations && make && make altinstall 
#Install-pip
apt install -y python3-pip
#Install-Las-Version-Ansible (REMENBER-CONFIG-HOST)
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
if [ "$1" == "yes" ]
then
	apt-key adv  --keyserver-options http-proxy=http://${USERNAME}:${PASSWORD}@${PROXYSERVER}:${PROXYPORT}/ --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
else
	apt-key adv  --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
fi
apt-get update
apt-get install -y ansible
#Install-Java1.7-Maven-------<CHANGE-M2-LOCAL-REPOSITORY> --->If-use-Spring-Framework-Upgrade-JAVA
apt install -y maven
#Installgit
apt-get install -y git
#Install-Docker
apt-get -y install docker.io
ln -sf /usr/bin/docker.io /usr/local/bin/docker
sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker
update-rc.d docker defaults
sudo usermod -a -G docker vagrant
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
#End
echo " Finish to supply Virtual Machinne "
