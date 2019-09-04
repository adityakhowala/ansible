#!/bin/bash

NAGIOS_SERVER_IP="172.32.0.9"

sudo useradd nagios
sudo apt-get update
sudo apt-get install build-essential libgd2-xpm-dev openssl libssl-dev unzip -y

cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar
tar zxf nagios-plugins-*.tar.gz
cd nagios-plugins-*

## Setting up the enviroment variables for nagios plugins
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
sudo make install

cd ~
curl -L -O https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar zxf nrpe-*.tar.gz
cd nrpe-*

## Setting up enviroment variables for nrpe installation
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios

make all
sudo make install
sudo make install-config
sudo make install-init

## Updating nrpe configuration file 
## Putting Nagios Server Ip in the nrpe configuration file

sed -i "s/allowed_hosts*.*/&,$NAGIOS_SERVER_IP/" /usr/local/nagios/etc/nrpe.cfg

