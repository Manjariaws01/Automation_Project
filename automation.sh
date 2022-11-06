#!/bin/sh
s3_bucket="upgrad-manjari"
filename="/var/www/html/inventory.html"
timestamp=$(date '+%d%m%Y-%H%M%S')
name="manjari"
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
size=$(sudo du -sh /tmp/manjari-httpd-logs-${timestamp}.tar | awk '{print $1}')
if [ -e "${filename}" ]
then
    echo "file found."
        echo "<br>httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; ${size}" >> ${filename}
else
    echo "file not found."
    echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp; Size</b><br>" > ${filename}
    echo "<br>httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; ${size}" >> ${filename}
fi
if  [ ! -f  /etc/cron.d/automation ]
then
        echo  "* * * * * /root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi
