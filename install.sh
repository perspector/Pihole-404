#!/bin/bash

# THIS SCRIPT MUST BE RUN WITH SUPERUSER PERMISSIONS! USE sudo !

# cool 404 text
apt-get install figlet lolcat cowsay
figlet "Pihole-404" | cowsay -f tux -n | lolcat -p 0.5 

# Installs dependency for the Python script
pip3 install imap-tools
echo "[✓] Installed dependency"

### Updates the email information in the automatic checker program
emailfile="EmailChecker.py"
phpfile="CustomBlockPage.php"
# Take the email string
read -p "Please enter your email for the script: " email
# Take the password string
read -p "Please enter your email password: " password
# Take the email provider
read -p "What email provider do you use? (gmail/outlook/aol/yahoo) " provider
if [[ $provider == "gmail" ]];then
  provider="imap.gmail.com"
fi
if [[ $provider == "outlook" ]];then
  provider="imap-outlook.com"
fi
if [[ $provider == "aol" ]];then
  provider="imap.aol.com"
fi
if [[ $provider == "yahoo" ]];then
  provider="imap.yahoo.com"
fi

# Updates Email info in files
if [[ $email != "" && $password != "" ]]; then
sed -i "s/someone@example.com/$email/gi" $emailfile
sed -i "s/PASSWORD/$password/gi" $emailfile
sed -i "s/imap.example.com/$provider/gi" $emailfile
sed -i "s/someone@example.com/$email/gi" $phpfile
fi
echo "[✓] Changed email credentials"

### Copy webpage PHP file to correct location
cp CustomBlockPage.php /var/www/html/pihole/CustomBlockPage.php
chmod +x /var/www/html/pihole/CustomBlockPage.php
cp Astronaut1.png /var/www/html/pihole/Astronaut1.png
cp background.jpg /var/www/html/pihole/background.jpg
echo "[✓] Webpage PHP file is located at /var/www/html/pihole/CustomBlockPage.php  Feel free to edit!"

### Changes the default 404 page to the custom page found in /var/www/html/pihole/
sed -i 's:server.error-handler-404    = "/pihole/index.php/":server.error-handler-404    = "/pihole/CustomBlockPage.php":gi' /etc/lighttpd/lighttpd.conf
echo "[✓] Changed configuration file for lighttpd located at /etc/lighttpd/lighttpd.conf"
sudo service lighttpd restart

#### Checks if /etc/pihole/pihole-FTL.conf exists. If it does, changes the blocking mode to IP instead of default NULL in config file at /etc/pihole/pihole-FTL.conf
#FILE=/etc/pihole/pihole-FTL.conf
#if [ -f "$FILE" ]; then
#    # File exists
#    sed -i 's/NULL/IP/gi' /etc/pihole/pihole-FTL.conf
#else 
#    # File does not exist
#    sudo echo "BLOCKINGMODE=IP" >> /etc/pihole/pihole-FTL.conf
#fi
# Changes blocking mode of pihole to IP by adding is line to the file
echo "BLOCKINGMODE=IP" | sudo tee -a /etc/pihole/pihole-FTL.conf

sudo service pihole-FTL restart

### Start Email Checker program in background, make it check email every 10 seconds
watch -n 10 python3 EmailChecker.py &
