#!/bin/sh

# ddmbox.sh
#
# Description:
# This script processes individual emails from an mbox file to detect and remove duplicates.
# It uses a combination of Message-ID and a custom identifier (from LibPST) to uniquely identify emails.
# Duplicates are detected using a hashing mechanism.
#
# Usage:
# This script is designed to be called by dedupe.sh for each email in the mbox file.
# It is not intended to be run standalone.
#
# Temporary files:
# The script uses the /tmp directory for temporary files to ensure efficient processing.
# All temporary files are cleaned up after processing.


TM=/tmp/tmpmail
HASHFILE=/tmp/hashes.tmp
OUTPUT_FILE="$1"

[ -f $TM ] && rm $TM

if [ -f $TM ] ; then
   echo "Error: Temporary file $TM already exists!"
   exit 1
fi
cat > $TM

# mbox format, each mail ends with a blank line
echo "" >> $TM

# Extract the Message-ID or the LibPST line as the unique identifier
msgid=$(grep -i "^Message-ID:" $TM || grep -- "--boundary-LibPST-iamunique" $TM)

# Compute a hash of the unique identifier
hashid=$(echo "$msgid" | md5sum | cut -d ' ' -f 1)

# Check if this mail is a duplicate
if [ ! -f $HASHFILE ] || ! grep -qF "$hashid" $HASHFILE; then
   # Append the hash to the hash file
   echo "$hashid" >> $HASHFILE
   # Append the mail to dedup.mbox
   cat $TM >> "$OUTPUT_FILE"
fi

rm $TM
