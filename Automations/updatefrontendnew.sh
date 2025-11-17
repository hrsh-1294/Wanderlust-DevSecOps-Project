#!/bin/bash

INSTANCE_ID="i-0f75c195300285cd2"

ipv4_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

file_to_find="../frontend/.env.docker"

# If file does NOT exist, create it
if [ ! -f "$file_to_find" ]; then
    echo 'VITE_API_PATH=""' > $file_to_find
fi

# Extract only the VITE_API_PATH line
current_url=$(grep "^VITE_API_PATH" $file_to_find)

new_url="VITE_API_PATH=\"http://${ipv4_address}:31100\""

# Update only if IP changed
if [[ "$current_url" != "$new_url" ]]; then
    sed -i -E "s|^VITE_API_PATH=.*|$new_url|g" $file_to_find
    echo "Updated .env.docker → $new_url"
else
    echo "No update needed"
fi
