# mbox-dedupe
A bash script to remove duplicate messages from an mbox email file. I didn't
have good luck with plugins for Thunderbird for instance so I created this. 
I have tested it and found it to be accurate and relatively error free. Do
what you want with it, no promises or guarantees.

Mbox Deduplication Script

Purpose:
This script is designed to deduplicate messages in an mbox file based on the
Message-ID header or a fallback unique identifier (LibPST). It works by splitting the 
mbox into individual messages, deduplicating them, and then reassembling them 
into a new mbox file.

Usage:
./dedupe.sh <path_to_mbox_file>

Output:
The script will produce a file with the same name as the input but appended 
with "-dd.mbox". This file will contain the deduplicated messages.

Dependency:
This script relies on "ddmbox.sh" to process individual messages. Ensure that 
"ddmbox.sh" is located in the same directory as this script and is executable.

Mbox Deduplication Script

Purpose:
This script is designed to deduplicate messages in an mbox file based on the
Message-ID header or a fallback unique identifier (LibPST). It works by splitting the 
mbox into individual messages, deduplicating them, and then reassembling them 
into a new mbox file.

Usage:
./dedupe.sh <path_to_mbox_file>

Output:
The script will produce a file with the same name as the input but appended 
with "-dd.mbox". This file will contain the deduplicated messages.

Dependency:
This script relies on "ddmbox.sh" to process individual messages. Ensure that 
"ddmbox.sh" is located in the same directory as this script and is executable.

Notes:
- Ensure you have enough disk space in the directory where the script is run.
- Always backup your original mbox file before running the script.
- The script uses a temporary directory named "temp_dedupe_dir" for its 
  operations, which is created in the temp directory and is removed at the end.
- If you have used LibPST (included in readpst package in Linux) to convert an
  MS Outlook PST file to mbox format, it can leave some messages minus the message ID.
  In this case, the script will fall back on the LibPST unique identifier.
