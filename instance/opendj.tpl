#!/bin/bash -xe

########### DEFAULT ################
sudo yum update -y
sudo yum install -y unzip

########### DEPENDENCIES ###########
sudo yum install -y java-1.8.0
sudo /usr/sbin/alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
sudo /usr/sbin/alternatives --set javac /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/javac

########### HOSTNAME ###########
hostname ${tag_name}
grep -v HOSTNAME /etc/sysconfig/network > /tmp/sysconfig_network
echo HOSTNAME=`hostname` >> /tmp/sysconfig_network
cp /tmp/sysconfig_network /etc/sysconfig/network
echo `hostname` > /etc/hostname
echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
sudo sed -i -e '/127.0.0.1/ s/\(localhost\)/'$(hostname)' \1/' /etc/hosts

########### OPENDJ ###########
sudo rm -rf /opt/opendj
aws s3 cp s3://anilens-assets/DS-eval-6.5.0.zip .
unzip DS-eval-6.5.0.zip
HOST_NAME=`hostname`
sudo mv opendj /opt/
sudo mkdir -p /opt/opendj/instance
sudo chown -R ec2-user:ec2-user /opt/opendj

/opt/opendj/setup directory-server \
          --instancePath /opt/opendj/instance \
          --rootUserDn cn=root \
          --rootUserPassword ${rootUserPassword} \
          --monitorUserDn uid=Monitor \
          --monitorUserPassword ${monitorUserPassword} \
          --hostname $HOST_NAME \
          --adminConnectorPort 4444 \
          --ldapPort 1389 \
          --ldapsPort 1636 \
          --baseDn dc=audi,dc=io \
          --sampleData 100
          --acceptLicense