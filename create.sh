#!/bin/sh

DAY="$1"

if [ "$DAY" == "" ]; then
    >&2 echo "Please provide the day"
    exit 1
fi

mkdir "$DAY"
if [ "$?" != "0" ]; then
    exit 1
fi

cat << EOF > "$DAY/main.nim"
import ../helper

let lines = readLinesFromStdin()

echo lines
EOF

git add "$DAY/main.nim"
