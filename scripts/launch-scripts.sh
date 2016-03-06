#!/bin/bash
set -e
set -x


MARIADBPASSWORD=$VALUE
echo $VALUE


#install the mariadb-server (client not needed) DEBCONF is how to proceed with an install without it asking for a password
# Configure and Install rsyslog and provide mariadb for logging
# http://dba.stackexchange.com/questions/35866/install-mariadb-without-password-prompt-in-ubuntu?newreg=426e4e37d5a2474795c8b1c911f0fb9f
# From <http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423> 
echo "mariadb-server-5.5 mysql-server/root_password password $MARIADBPASSWORD" | sudo  debconf-set-selections
echo "mariadb-server-5.5 mysql-server/root_password_again password $MARIADBPASSWORD" | sudo debconf-set-selections

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server
sudo apt-get install -y git curl wget rsync vim

#inject the username and password for autologin later in a ~/.my.cnf file
# http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423#103423

echo -e "[client] \n user = root \n password = $MARIADBPASSWORD" > ~/.my.cnf
echo -e "\n port = 3306 \n socket          = /var/run/mysqld/mysqld.sock" >> ~/.my.cnf


