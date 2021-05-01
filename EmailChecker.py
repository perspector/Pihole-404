#!/usr/bin/python3

# imports necessary libraries
from imap_tools import MailBox, AND
from time import sleep
import os

# gets list of email subjects from INBOX folder
with MailBox('imap.gmail.com').login("someone@example.com", "PASSWORD", initial_folder='INBOX') as mailbox:
    body = [msg.text for msg in mailbox.fetch(AND(subject='Domain Blocked'))]
    
    # Checkes if the folder PiHoleWhitelist exists
    folder_exists = mailbox.folder.exists('PiHoleWhitelist')
    # if it does not exist, create it
    if folder_exists == False:
        mailbox.folder.create('PiHoleWhitelist')
    # Moves email to PiHoleWhitelist folder to avoid a cluttered Inbox
    mailbox.move(mailbox.fetch(AND(subject='Domain Blocked')), 'PiHoleWhitelist')
    try:
        body = body[0]
        body = body.replace("\r\n", "")
        body = body.replace("https://", "")
        body = body.replace("http://", "")
        if body[-1] == "/":
            body = body[:-1]
        os.system("pihole -w " + body)
    except IndexError:
         sleep(0.5)
