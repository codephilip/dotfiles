#!/bin/bash
# email_notify.sh
# This script sends an email notification with a specified subject and message.
# It uses the 'mail' command to send the email.

EMAIL="your_email@example.com" # Recipient email address
SUBJECT="Notification" # Email subject
MESSAGE="An event has occurred." # Email message

# Send the email
echo $MESSAGE | mail -s $SUBJECT $EMAIL
