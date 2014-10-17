#!/bin/bash
#Updating
sudo yum update -y

#InstallingBasicPackages
#yum groupinstall -y "Web Server" "MySQL Database" 
sudo yum install -y php55.x86_64 mysql55-server.x86_64 php55-mysqlnd.x86_64 php55-mysqlnd.x86_64 unzip  php55-gd.x86_64 

#ApacheHttpAndMySQLServicesStart
sudo service httpd start
sudo chkconfig httpd on
sudo service mysqld start
sudo chkconfig mysqld on

#EditingUserPermissionAndGroups
sudo groupadd www
sudo usermod -a -G www ec2-user
sudo chown -R root:www /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} +
sudo find /var/www -type f -exec chmod 0664 {} +

#CreatingBasicPhpInfoWeb
sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

#InstallingGIT
#yum install -y git

#InstallingLTI(Moodle)
cd /var/www/html/
sudo wget  --no-check-certificate https://github.com/moodle/moodle/archive/MOODLE_27_STABLE.zip 
sudo unzip MOODLE_27_STABLE.zip
sudo mv moodle-MOODLE_27_STABLE moodle
sudo rm -f MOODLE_27_STABLE.zip
sudo chown -R ec2-user .

#CreatingMoodleDataFolderAndGivingPermissions
cd /var/www/
sudo mkdir moodledata
sudo chown -R apache /var/www/moodledata
sudo chown -R apache /var/www/html/moodle

#CreatingMoodleDataBase
cd html/moodle
sudo wget  --no-check-certificate https://github.com/emir93795/LTISetUp/archive/master.zip
sudo unzip master.zip
sudo rm -f master.zip
cd LTISetUp-master
sudo mysql < MoodleDatabaseCreation.sql

#Getting instance public IP
publicIp=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

#InstallingMoodle
cd /var/www/html/moodle
sudo -u apache /usr/bin/php admin/cli/install.php --non-interactive --agree-license --wwwroot=http://$publicIp/moodle/ --dataroot=/var/www/moodledata --dbtype=mysqli --dbuser=moodle --dbpass=secretpassword --fullname=Moodle --shortname=Mood --adminpass=secretpassword


#git clone git://git.moodle.org/moodle.git
#cd moodle
#git branch -a
#git branch --track MOODLE_27_STABLE origin/MOODLE_27_STABLE
#git checkout MOODLE_27_STABLE

