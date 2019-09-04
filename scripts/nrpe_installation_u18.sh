#!/bin/bash

NAGIOS_SERVER_IP="172.32.0.9"

sudo useradd nagios
sudo apt-get update
sudo apt install autoconf gcc libmcrypt-dev make libssl-dev wget dc build-essential gettext -y

cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar
tar zxf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1

## Setting up the enviroment variables for nagios plugins
./configure 
make
sudo make install

cd ~
curl -L -O https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar zxf nrpe-3.2.1.tar.gz
cd nrpe-3.2.1

## Setting up enviroment variables for nrpe installation
./configure

make nrpe
sudo make install-daemon
sudo make install-config
sudo make install-init

## Updating nrpe configuration file 
## Putting Nagios Server Ip in the nrpe configuration file

sed -i "s/allowed_hosts*.*/&,$NAGIOS_SERVER_IP/" /usr/local/nagios/etc/nrpe.cfg

