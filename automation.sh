#!/bin/sh
s3_bucket=upgrad-manjari
timestamp=$(date '+%d%m%Y-%H%M%S')
name=manjari
sudo apt-get update
sudo apt-get install awscli
sudo apt install apache2
if [ $(/etc/init.d/apache2 status | grep -v grep | grep 'Apache2 is running' | wc -l) > 0 ]
then
 echo "Apache is running."
else
  echo "Apache is not running."
  sudo systemctl start apache2
  sudo systemctl enable apache2
fi

tar cvf /tmp/${name}-httpd-logs-${timestamp}.tar /var/log/apache2
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
