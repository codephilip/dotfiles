#!/bin/bash
# push_notify.sh
# This script sends a push notification using the Pushover API.
# It requires a user key and application token for authentication.

API_URL="https://api.pushover.net/1/messages.json" # Pushover API URL
USER_KEY="your_user_key" # Pushover user key
APP_TOKEN="your_app_token" # Pushover application token
TITLE="Notification" # Notification title
MESSAGE="An event has occurred." # Notification message

# Send the push notification
curl -s \
    --form-string "token=$APP_TOKEN" \
    --form-string "user=$USER_KEY" \
    --form-string "title=$TITLE" \
    --form-string "message=$MESSAGE" \
    $API_URL
