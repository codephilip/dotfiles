#!/bin/bash
# sms_notify.sh
# This script sends an SMS notification using the Twilio API.
# It requires a Twilio SID, authentication token, and phone numbers for sending the SMS.

TWILIO_SID="your_twilio_sid" # Twilio SID
TWILIO_AUTH_TOKEN="your_twilio_auth_token" # Twilio authentication token
FROM_PHONE="+1234567890" # Twilio phone number
TO_PHONE="+0987654321" # Recipient phone number
MESSAGE="An event has occurred." # SMS message

# Send the SMS notification
curl -s -X POST https://api.twilio.com/2010-04-01/Accounts/$TWILIO_SID/Messages.json \
    --data-urlencode "To=$TO_PHONE" \
    --data-urlencode "From=$FROM_PHONE" \
    --data-urlencode "Body=$MESSAGE" \
    -u $TWILIO_SID:$TWILIO_AUTH_TOKEN
