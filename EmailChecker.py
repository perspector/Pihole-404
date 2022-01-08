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
