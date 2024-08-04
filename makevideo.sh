#!/bin/sh

# Directory containing JPEG files
SAVE_DIR="/config/saved_files"

# Output MP4 filename
OUTPUT_FILE="/config/video/timelapse.mp4"


# Ensure ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg could not be found. Please install it to proceed." >> /proc/1/fd/1
    exit 1
fi

# Check if there are JPEG files in the directory
if ls "$SAVE_DIR"/*.jpg 1> /dev/null 2>&1; then
    # Convert JPEG images to MP4
    echo "Converting JPEG images in $SAVE_DIR to $OUTPUT_FILE..."
    ffmpeg -y -hide_banner -stats -loglevel error -framerate 15 -pattern_type glob -i "$SAVE_DIR/*.jpg" -s:v 1920x1080 -c:v libx264 -crf 17 -pix_fmt yuv420p -threads 8 "$OUTPUT_FILE"
    echo "Conversion completed: $OUTPUT_FILE" >> /proc/1/fd/1
else
    echo "No JPEG files found in $SAVE_DIR." >> /proc/1/fd/1
    exit 1
fi
