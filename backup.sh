USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}

if [ $USER_ID -ne 0 ]; then 
    echo -e "$R ERROR :: Please run the script with root priveleges $N"
    exit 1
fi

USAGE(){
    echo -e "$R sh backup.sh <SOURCE_dir> <DEST_dir> <DAYS> $N"
    exit 1
}

if [ $# -lt 2 ]; then 
    USAGE
fi

if [ ! -d $SOURCE_DIR ]; then
    echo -e "$R $SOURCE_DIR does not exists $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]; then
    echo -e "$R $DEST_DIR does not exists $N"
    exit 1
fi

old_files=$(find $SOURCE_DIR -name "*.txt" -type f -mtime +$DAYS)

if [ ! -z "${old_files}" ]; then
    time_stamp=$(date +%F-%H-%M)
    ZIP_FILE_NAME="$DEST_DIR/applog-$time_stamp.zip"
    find "$SOURCE_DIR" -name "*.txt" -type f -mtime +$DAYS | zip -@ -j "$ZIP_FILE_NAME"

    if [ -f $ZIP_FILE_NAME ]; then 
        echo -e "$G archiving ....success....$N"
        while IFS= read -r filepath 
            do
                echo -e "$Y deleting log files successfully $N"
                rm -rf $filepath
                echo -e "$G deleted log files successfully $N"
            done <<< $old_files
    else
        echo -e "Archieval ... $R FAILURE $N"
        exit 1
    fi
else 
    echo -e "No files to archeive ... $Y SKIPPING $N"
fi