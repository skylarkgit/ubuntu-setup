#!/bin/bash
# WARN: This sceript is not working as expected.
# CAUTION

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root." 1>&2
    exit 1
fi

# Capture the output of apt-get update
output=$(apt-get update 2>&1)

# Extract repository URLs causing the error
repos=$(echo "$output" | grep -Po "(?<=from )[^ ]+(?= can't be done securely)")

# Process each problematic repository URL
for repo in $repos; do
    echo "Processing repository: $repo"
    
    # Try to fetch and import the GPG key
    key_url=$(curl -sL "$repo" | grep -Po "(?<=href=\")[^ ]+\.gpg(?=\")" | head -n 1)
    if [ -z "$key_url" ]; then
        echo "Failed to find GPG key for repository: $repo"
        continue
    fi
    
    full_key_url="$repo/$key_url"
    echo "Importing GPG key: $full_key_url"
    curl -sL "$full_key_url" | apt-key add -
done

# Update package lists
apt-get update
