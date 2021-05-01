#!/usr/bin/python3
from imap_tools import MailBox, AND
from time import sleep
import os

#sleep(10) # Checks every 10 seconds
# get list of email subjects from INBOX folder
with MailBox('imap.gmail.com').login("someone@example.com", "password", initial_folder='INBOX') as mailbox:
    body = [msg.text for msg in mailbox.fetch(AND(subject='Domain Blocked'))]
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
