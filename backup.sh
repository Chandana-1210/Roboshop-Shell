#!/bin/bash

USERID=$(id -u)
R="\e[31m"; G="\e[32m"; Y="\e[33m"; N="\e[0m"
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # default 14 days

LOGS_FOLDER="/var/log/shell-script"
LOG_FILE="$LOGS_FOLDER/backup.log"

mkdir -p "$LOGS_FOLDER"
echo "Script started at: $(date)" | tee -a "$LOG_FILE"

if [ $USERID -ne 0 ]; then
    echo -e "${R}ERROR:: Please run this script with root privileges${N}"
    exit 1
fi

USAGE(){
    echo -e "${R}USAGE:: sudo sh backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS>[optional, default 14]${N}"
    exit 1
}

if [ $# -lt 2 ]; then USAGE; fi
if [ ! -d "$SOURCE_DIR" ]; then echo -e "${R}Source $SOURCE_DIR does not exist${N}"; exit 1; fi
if [ ! -d "$DEST_DIR" ]; then echo -e "${R}Destination $DEST_DIR does not exist${N}"; exit 1; fi

# Store files in an array safely
mapfile -t FILES < <(find "$SOURCE_DIR" -name "*.log" -type f -mtime +"$DAYS")

# Debug: list files found
echo -e "${Y}Found ${#FILES[@]} file(s) older than $DAYS days:${N}"
for f in "${FILES[@]}"; do
    echo "  $f"
done

if [ ${#FILES[@]} -gt 0 ]; then
    TIMESTAMP=$(date +%F-%H-%M)
    ZIP_FILE_NAME="$DEST_DIR/app-logs-$TIMESTAMP.zip"
    echo "Creating zip: $ZIP_FILE_NAME"

    # Archive files safely
    zip -j "$ZIP_FILE_NAME" "${FILES[@]}"

    if [ -f "$ZIP_FILE_NAME" ]; then
        echo -e "Archival ... ${G}SUCCESS${N}"

        # Delete the original files safely
        for filepath in "${FILES[@]}"; do
            echo "Deleting: $filepath"
            rm -f "$filepath"
            echo "Deleted: $filepath"
        done
    else
        echo -e "Archival ... ${R}FAILURE${N}"
        exit 1
    fi
else
    echo -e "No files to archive ... ${Y}SKIPPING${N}"
fi