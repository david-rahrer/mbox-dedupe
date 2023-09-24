#!/bin/bash

# Mbox Deduplication Script
# 
# Purpose:
# This script is designed to deduplicate messages in an mbox file based on the
# Message-ID header or a fallback unique identifier (LibPST). It works by splitting the 
# mbox into individual messages, deduplicating them, and then reassembling them 
# into a new mbox file.
#
# Usage:
# ./dedupe.sh <path_to_mbox_file>
# 
# Output:
# The script will produce a file with the same name as the input but appended 
# with "-dd.mbox". This file will contain the deduplicated messages.
# 
# Dependency:
# - This script relies on "ddmbox.sh" to process individual messages. Ensure that 
#   "ddmbox.sh" is located in the same directory as this script and is executable.
# - The script requires the 'reformail' package to be installed. This package is 
#   part of the 'procmail' suite and can be installed via your system's package manager.
#
# Notes:
# - Ensure you have enough disk space in the directory where the script is run.
# - Always backup your original mbox file before running the script.
# - The script uses a temporary directory named "temp_dedupe_dir" for its 
#   operations, which is created in the temp directory and is removed at the end.
# - If you have used LibPST (included in readpst package in Linux) to convert an
#   MS Outlook PST file to mbox format, it can leave some messages minus the message ID.
#   In this case, the script will fall back on the LibPST unique identifier.
# 
# Author: David Rahrer
# Date: 09-23-2023
# Version: 1.1

# Spinner function
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Extract the base name from the input mbox file
BASENAME=$(basename "$1" .mbox)

# Create the output filename by appending "-dd.mbox" to the base name
OUTPUT_FILE="$(echo "${BASENAME}-dd.mbox" | tr '[:upper:]' '[:lower:]')"

# Check for existing output file
if [ -f "$OUTPUT_FILE" ]; then
    echo "Warning: $OUTPUT_FILE already exists!"
    read -p "Do you want to delete it and continue? (y/n) " choice
    case "$choice" in
        y|Y) rm "$OUTPUT_FILE";;
        n|N) echo "Exiting script."; exit 1;;
        *) echo "Invalid choice. Exiting script."; exit 1;;
    esac
fi

# Process the mbox file with spinner
echo "Processing mbox file..."
cat "$1" | reformail -s ./ddmbox.sh "$OUTPUT_FILE" &
spinner $!

ORIGINAL_COUNT=$(grep -c "^From " "$1")
DEDUPED_COUNT=$(grep -c "^From " "$OUTPUT_FILE")
REMOVED_COUNT=$((ORIGINAL_COUNT - DEDUPED_COUNT))

# Display the summary
echo "-----------------------------------"
echo "Deduplication Summary:"
echo "Total messages in original mbox: $ORIGINAL_COUNT"
echo "Messages remaining after deduplication: $DEDUPED_COUNT"
echo "Total messages removed (duplicates): $REMOVED_COUNT"
echo "-----------------------------------"

# Clean up the hash file
rm /tmp/hashes.tmp
