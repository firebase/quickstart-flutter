#!/bin/sh
for file in **/*.idx.*
do
    mv "$file" "${file%.idx}"
done
