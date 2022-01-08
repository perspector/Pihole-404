#!/usr/bin/python3

# imports necessary libraries
from imap_tools import MailBox, AND
from time import sleep
import os

# gets list of email subjects from INBOX folder
with MailBox('imap.example.com').login("someone@example.com", "PASSWORD", initial_folder='INBOX') as mailbox:
    body = [msg.text for msg in mailbox.fetch(AND(subject='Domain Blocked'))]
    print(body)
    # Checkes if the folder PiHoleWhitelist exists
    folder_exists = mailbox.folder.exists('PiHoleWhitelist')
    # if it does not exist, create it
    if folder_exists == False:
        mailbox.folder.create('PiHoleWhitelist')
    # Moves email to PiHoleWhitelist folder to avoid a cluttered Inbox
    mailbox.move(mailbox.uids(AND(subject='Domain Blocked')), 'PiHoleWhitelist')
    
    # tries to format email correctly
    try:
        body = body[0] # First line of body only, removes email signature such as "Sent using Mail from Windows", etc.
        # For security, if it contains ' or " or && or | replace the text afterwords with whitespace
        head, sep, tail = body.partition("'") # Removes everything after '
        body = head
        head, sep, tail = body.partision('"') # Removes everything after "
        forbiddenChars = ['"', "'", "&", "|"] # Emails with characters " ' & or | could potentially execute another command causing a security risk
        for char in forbiddenChars:
            if char in body:
                return void = True # Security risk
            else:
                return void = False # Not a security risk
        if void == True: # If it is a security risk, do nothing with the email so that the admin can see it and who it was sent by, do not handle the email
            pass
        elif void == False: # 
            body = body.replace("\r\n", "")
            body = body.replace("https://", "")
            body = body.replace("http://", "")
            if body[-1] == "/":
                body = body[:-1]
            # executes command to whitelist domain
            os.system("pihole -w " + body)
    # Error will be thrown if no email is available, this just passes it silently
    except IndexError:
         sleep(0.5)
