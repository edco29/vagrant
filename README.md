# Vagrant
This repo contain a Vagranfile to start a ubuntu Operating System in mode-server.
# Use ( example vagrant-box : ubuntu/trusty64 )
- Download the repo 
```
git clone https://github.com/edco29/vagrant.git
git cd #file
```
- Download Vagrant for your OS ( https://www.vagrantup.com/downloads.html )
- Download the vagrant box of your choice -VirtualBoxsupport-(https://app.vagrantup.com/boxes/search)
```
  vagrant box add ubuntu/trusty64
```
- If you are behind proxy
```
vagrant box add --insecure -c ubuntu/trusty64 https://app.vagrantup.com/ubuntu/boxes/trusty64
```
# Deploy with Shell Scripting
It's launched from Windows Operating System
# Configure Proxy
- Pass arguments in vagrantfile
# Programs Installed
- Ansible
- Git
- Maven
- Python3(status:disable)
- Docker
- java
# Support:MultiNode Implement
- Add Nodes on demand.
# Provider
- VirtualBox
