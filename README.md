# Vagrant
This repo contain a Vagranfile to start a ubuntu Operating System in mode-server.
# Use ( example vagrant-box : ubuntu/trusty64 )
- Download VirtualBox for your OS (https://www.virtualbox.org/wiki/Downloads)
- Download Vagrant for your OS (https://www.vagrantup.com/downloads.html )
- Download the vagrant box of your choice -VirtualBox-(https://app.vagrantup.com/boxes/search)
- If you have a Windows 7 , install powershell V3 (https://www.microsoft.com/en-us/download/details.aspx?id=34595)
- Open cmd/sh and write the below command
```
  vagrant box add ubuntu/trusty64
```
- If you are behind proxy
```
vagrant box add --insecure -c ubuntu/trusty64 https://app.vagrantup.com/ubuntu/boxes/trusty64
```
- Download the repo in the /#path of your choice
```
cd /#path
git clone https://github.com/edco29/vagrant.git
git cd vagrant
```
# Note :Configure Proxy variables is you are behind Proxy
- Pass arguments in vagrantfile
```
provision_nodes_proxy = "no"  #Define if provisioners should run behind proxy(yes | no)
# < "yes" = You are behind proxy  , fill out proxy variables && "no" = no fill out proxy variables >
#Proxy variables
Username="xxx"
Password="xxx"
ProxyServer="xxxxx.com.pe"
ProxyPort="8080"
```
- Locate in the vagrant file and  Up & connect to Virtual Machinne
```
vagrant up
vagrant ssh node[0-N]
```
# Programs Installed
- Ansible
- Git
- Maven
- Python3(status:disable)
- Docker
- java
# Support: MultiNode Implement
- Add Nodes on demand.
# Provider
- VirtualBox
