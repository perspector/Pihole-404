#!/bin/bash
read -p "This will uninstall all code from the Pihole-404 repository and will reverse any changes made. Are you sure you want to continue? (y/n) " confirmation
if [ "$confirmation" = "y" ];then
  echo "Starting uninstall process"
  sudo pip3 uninstall imap-tools
  sudo rm /var/www/html/pihole/CustomBlockPage.php
  sudo rm /var/www/html/pihole/foreground.png
  sudo rm /var/www/html/pihole/background.jpg
  sudo sed -i -e 's?CustomBlockPage.php?index.php?g' /etc/lighttpd/lighttpd.conf
  sudo service lighttpd restart
  
  FILE=/etc/pihole/pihole-FTL.conf
  if [ -f "$FILE" ]; then
    # File exists
    if grep -q "BLOCKINGMODE" $FILE
    then
      # If BLOCKINGMODE line is present
      if grep -q "=IP" $FILE
      then
        # If BLOCKINGMODE is set to IP
        sudo sed -i 's/.*BLOCKINGMODE.*/BLOCKINGMODE=NULL/' $FILE
      else
        # IF BLOCKINGMODE is present but not set to IP
        continue
      fi
    else
      # If BLOCKINGMODE line is not present
      echo "BLOCKINGMODE=NULL" | sudo tee -a $FILE
    fi
  else 
    # File does not exist
    sudo touch $FILE
    echo "BLOCKINGMODE=NULL" | sudo tee -a $FILE
  fi
  
  sudo service pihole-FTL restart
  # and finally delete the Pihole-404 files :(
  sudo rm -r /home/pi/Pihole-404/
  echo 'Everything from Pihole-404 has been deleted and all changes have been restored to their origional configeration.'
  echo 'You will still be in the Pihole-404 folder, to exit, just type cd. The folder will not be there.'
fi
if [ "$confirmation" != "y" ];then
  echo "Abort"
fi
