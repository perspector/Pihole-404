#!/bin/bash

clear
# Cool splash text
echo '
______   _ _           _               ___ _____    ___
| ___ \ (_) |         | |             /   |  _  |  /   |
| |_/ / | | |__   ___ | | ___ ______ / /| | | | | / /| |
|  __/  | |  _ \ / _ \| |/ _ \______/ /_| | |/| |/ /_| |
| |     | | | | | (_) | |  __/      \___  | |_/ |\___  |
\_|     |_|_| |_|\___/|_|\___|          |_/\____/    |_/

By BennyThePythonCoder
Repo can be found at (https://github.com/BennyThePythonCoder/Pihole-404)
Thanks to pi-hole (pi-hole.net) (https://github.com/pi-hole/pi-hole)
Other credits can be found at (https://github.com/BennyThePythonCoder/Pihole-404#credits)
'
sleep 5
clear

echo '
This program is licensed under the MIT License.

MIT License

Copyright (c) 2021 BennyThePythonCoder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'
sleep 5
clear

# Installs dependency for the Python script
sudo pip3 install imap-tools
echo "[✓] Installed Python3 program dependency imap-tools (for automatically checking email to whitelist domain)"

### Updates the email information in the automatic checker program
phpfile="CustomBlockPage.php"
emailfile="EmailChecker.py"
# Take the email string
read -p "Please enter your email for the script: " email
# Take the password string
read -p "Please enter your email password: " password
# Take the email provider
read -p "What email provider do you use? (gmail/outlook/aol/yahoo) " provider
if [ "$provider" = "gmail" ];then
  provider="imap.gmail.com"
fi
if [ "$provider" = "outlook" ];then
  provider="imap-outlook.com"
fi
if [ "$provider" = "aol" ];then
  provider="imap.aol.com"
fi
if [ "$provider" = "yahoo" ];then
  provider="imap.yahoo.com"
fi
### To add custom/other, just uncomment following lines
#if [ "$provider" = "PROVIDERNAME" ];then
#  provider="your provider's IMAP address here" # see https://www.systoolsgroup.com/imap/
#fi

echo "Your provider's IMAP address is: $provider"

### Updates Email info in files
if [ "$email" != "" ] && [ "$password" != "" ]; then
sed -i '9s/.*/with MailBox("$provider").login("$email", "$password", initial_folder="INBOX") as mailbox:/' $emailfile
sed -i '20s#.*#      <a href="mailto:$email?subject=Domain%20Blocked&body=[sub]" onclick="this.href =this.href.replace("[sub]",window.location)" target="_blank" rel=noopener noreferrer><button style="background-color:white; border-color:white">here</button></a>.<br>#' $phpfile
echo "[✓] Changed email credentials"
else
echo You did not enter an email or password, stopping program
exit
fi


### Copy webpage PHP file to correct location
sudo cp CustomBlockPage.php /var/www/html/pihole/CustomBlockPage.php
sudo chmod +x /var/www/html/pihole/CustomBlockPage.php
sudo cp Astronaut1.png /var/www/html/pihole/Astronaut1.png
sudo cp background.jpg /var/www/html/pihole/background.jpg
echo "[✓] Webpage PHP file is located at /var/www/html/pihole/CustomBlockPage.php  Feel free to edit!"

### Changes the default 404 page to the custom page found in /var/www/html/pihole/
sudo sed -i 's:server.error-handler-404    = "/pihole/index.php":server.error-handler-404    = "/pihole/CustomBlockPage.php":gi' /etc/lighttpd/lighttpd.conf
echo "[✓] Changed configuration file for lighttpd located at /etc/lighttpd/lighttpd.conf"
sudo service lighttpd restart

### Changes blocking mode to IP in /etc/pihole/pihole-FTL.conf . This will make the custom 404 page display.
# More details can be found at https://docs.pi-hole.net/ftldns/blockingmode/
echo " The next part of the installer script will set the Pihole blocking mode to IP. More details can be found at:\n https://docs.pi-hole.net/ftldns/blockingmode/ \n If you do not want to change this, press CTRL + C (you have 10 seconds)"
sleep 10
FILE=/etc/pihole/pihole-FTL.conf

if [ -f "$FILE" ]; then
    # File exists
    if grep -q "BLOCKINGMODE" $FILE
    then
      # If BLOCKINGMODE line is present
      if grep -q "=IP" $FILE
      then
        # If BLOCKINGMODE is set to IP
        continue
      else
        # IF BLOCKINGMODE is present but not set to IP
        sudo sed -i 's/.*BLOCKINGMODE.*/BLOCKINGMODE=IP/' $FILE
      fi
    else
      # If BLOCKINGMODE line is not present
      echo "BLOCKINGMODE=IP" | sudo tee -a $FILE
    fi
else 
    # File does not exist
    sudo touch $FILE
    echo "BLOCKINGMODE=IP" | sudo tee -a $FILE
fi

sudo service pihole-FTL restart

### Start Email Checker program in background, make it check email every 10 seconds
while true; do python3 EmailChecker.py ; sleep 10; done &
echo "[✓] Email checker program is running! Everything is setup and ready to go! \nTry going to http://doubleclick.net to test it out! \nIf you like this, please star my repository! \nThanks :]"
