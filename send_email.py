#!/usr/bin/env python3

# Usage: python send_email.py your_message

import sys
import smtplib
from email.message import EmailMessage

# your Gmail account
# Create an app password from
# https://myaccount.google.com/apppasswords
sender = 'username@gmail.com'
password = 'app_password'
receiver = 'username@gmail.com'
subject = 'Subject'

with smtplib.SMTP_SSL('smtp.gmail.com', port=465) as server:
    server.login(sender, password)
    msg = EmailMessage()
    msg['To'] = receiver
    msg['From'] = sender
    msg['Subject'] = subject
    msg.set_content(sys.argv[1])
    server.send_message(msg)
