#!/bin/bash -xe

########### DEFAULT ################
sudo yum update -y
sudo yum install -y unzip
yum install python36 python36-virtualenv python36-pip -y
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
pip install --upgrade pip
pip3 install ansible --user

########### DEPENDENCIES ###########
sudo yum install -y java-1.8.0
sudo /usr/sbin/alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
sudo /usr/sbin/alternatives --set javac /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/javac

########### HOSTNAME ###########
hostname ${tag_name}
sudo grep -v HOSTNAME /etc/sysconfig/network > /tmp/sysconfig_network
sudo echo HOSTNAME=`hostname` >> /tmp/sysconfig_network
sudo cp /tmp/sysconfig_network /etc/sysconfig/network
sudo echo `hostname` > /etc/hostname
sudo echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
sudo sed -i -e '/127.0.0.1/ s/\(localhost\)/'$(hostname)' \1/' /etc/hosts


