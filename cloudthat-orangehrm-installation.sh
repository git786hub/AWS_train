sudo yum -y update
echo "Installing http server with Php"
sudo ln -s /var/www/html /mnt/ebs
## Remi Dependency on CentOS 7 and Red Hat (RHEL) 7 ##
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
## CentOS 7 and Red Hat (RHEL) 7 ##
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum --enablerepo=remi,remi-php56 install -y httpd php php-common 
sudo yum --enablerepo=remi,remi-php56 install -y  php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-mysql php-pecl-mongo php-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
sudo yum install -y vim wget
sudo yum install -y unzip
echo "Enable the httpd service at boot time"
sudo systemctl enable httpd.service
echo "Start the httpd service"
echo "Installing mysql"
sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo yum install -y mysql-community-server
sudo systemctl start mysqld
sudo mysqladmin -u root password cloudthat
sudo service httpd start
#sudo service mysqld start
sudo systemctl start mysqld.service
echo "creating temporary Directory to Downoad Orangehrm"
mkdir /tmp/download
cd /tmp/ohrm
sudo wget http://files.cloudthat.com/aws/orangehrm-3.3.1.12255.zip
echo "Orangehrm Download Completed Unziping it to /var/www/html"
sudo yum install -y unzip
sudo unzip orangehrm-3.3.1.12255.zip -d /var/www/html/
sudo wget http://files.cloudthat.com/aws/ohrmhome.zip
sudo unzip ohrmhome.zip -d /var/www/html
cd /var/www/html
sudo mv orangehrm-3* orangehrm
cd orangehrm
sudo chmod -R 755 lib/confs
sudo chmod -R 755 lib/logs
sudo chmod -R 755 symfony/config
sudo chmod -R 755 symfony/apps/orangehrm/config
sudo chmod -R 755 symfony/cache
sudo chmod -R 755 symfony/log
sudo chown -R apache.apache lib/confslib/confs
sudo chown -R apache.apache lib/confs
sudo chown -R apache.apache lib/logs
sudo chown -R apache.apache symfony/config
sudo chown -R apache.apache symfony/apps/orangehrm/config
sudo chown -R apache.apache symfony/cache
sudo chown -R apache.apache symfony/log
## Selinux security context setting
sudo chcon -R --type=httpd_user_rw_content_t /var/www/html/orangehrm
## Disabling SELINUX
sudo sed -ir /^SELINUX/s/enforcing/disabled/g /etc/selinux/config  
sudo service httpd restart
sudo service mysqld restart
#cd /var/www/html
#touch index.html
#chmod 777 index.html
sudo chown -R apache.apache /var/www/html 
echo -e "\033[1;33m The Machine will go down for reboot. If it fails 'Status Check' please reboot it once again from EC2 Console.\033[0m"
echo "After reboot visit ElasticIP/orangehrm to access the application"
sudo reboot
