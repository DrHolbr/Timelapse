#!/bin/sh

# Directory to save the files
SAVE_DIR="/config/saved_files"

# Create the directory if it doesn't exist
mkdir -p "$SAVE_DIR"

# Get the current date in YYYYMMDD format
DATE=$(date +%Y%m%d)

# Counter file named with the current date
COUNTER_FILE="$SAVE_DIR/counter_$DATE.txt"

# Initialize counter if it doesn't exist
if [ ! -f "$COUNTER_FILE" ]; then
    echo 1 > "$COUNTER_FILE"
fi

# Read the current counter value
COUNTER=$(cat "$COUNTER_FILE")

# Ensure COUNTER is a number
if ! echo "$COUNTER" | grep -qE '^[0-9]+$'; then
    echo "Counter file contains invalid data. Resetting counter." >> /proc/1/fd/1
    COUNTER=1
else
    # Convert COUNTER to integer and check its value
    COUNTER=$(printf "%d" "$COUNTER")
fi

# Update the counter
COUNTER=$((COUNTER + 1))
echo "$COUNTER" > "$COUNTER_FILE"

# Zero-pad the counter to 6 digits
COUNTER=$(printf "%06d" "$COUNTER")

# Construct the filename
FILENAME="${DATE}_${COUNTER}.jpg"

# Full path to the new file
FILEPATH="$SAVE_DIR/$FILENAME"

# Download the file
echo "Downloading $URL to $FILEPATH..." >> /proc/1/fd/1
curl -s "$URL" -o "$FILEPATH"


# Delete files older than 24 hours
echo "Deleting jpg files older than 24 hours..." >> /proc/1/fd/1
find "$SAVE_DIR" -type f -name '*.jpg' -mtime +"$DAYS_TO_KEEP" -exec rm {} \;

# Cleanup old counter files older than specified number of days
echo "Cleaning up old counter files..." >> /proc/1/fd/1
find "$SAVE_DIR" -type f -name 'counter_*.txt' -mtime +3 -exec rm {} \;

echo "Operation completed." >> /proc/1/fd/1
