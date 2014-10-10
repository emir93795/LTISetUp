#!/bin/bash
sudo su 
#Updating
yum update -y

#InstallingBasicPackages
#yum groupinstall -y "Web Server" "MySQL Database" 
sudo yum install -y php55.x86_64 mysql55-server.x86_64 php55-mysqlnd.x86_64 unzip

#ApacheHttpAndMySQLServicesStart
service httpd start
chkconfig httpd on
service mysqld start
chkconfig mysqld on

#EditingUserPermissionAndGroups
groupadd www
usermod -a -G www ec2-user
chown -R root:www /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} +
find /var/www -type f -exec chmod 0664 {} +

#CreatingBasicPhpInfoWeb
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

#InstallingGIT
yum install -y git

#InstallingLTI(Moodle)
cd /var/www/html/
wget  --no-check-certificate https://github.com/moodle/moodle/archive/MOODLE_27_STABLE.zip 
unzip MOODLE_27_STABLE.zip 
chown -R ec2-user .
#git clone git://git.moodle.org/moodle.git
#cd moodle
#git branch -a
#git branch --track MOODLE_27_STABLE origin/MOODLE_27_STABLE
#git checkout MOODLE_27_STABLE

