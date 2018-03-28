#!/bin/bash
dirinput="all_dirs.txt"
while IFS= read -r line
do
  if [ "$line" != "" ]; then
  		mkdir -p "$line"
  fi
done < "$dirinput"

fileinput="all_files.txt"
while IFS= read -r line
do
  if [ "$line" != "" ]; then
  		curl $SCRIPT_BASEPATH/$line -o $line
  fi
done < "$fileinput"