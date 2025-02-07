#!/bin/sh
for file in `find . -name "*.idx.*" -type f`
do
    [ -e "$file" ] || continue
    echo $file
    filename=${file%.idx*}
    extension="${file#*.idx}"
    mv "$file" "${filename}${extension}"
done
