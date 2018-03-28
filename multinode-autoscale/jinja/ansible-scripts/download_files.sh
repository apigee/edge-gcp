#!/bin/bash
curl -O $SCRIPT_BASEPATH/all_dirs.txt
curl -O $SCRIPT_BASEPATH/all_files.txt

dirinput="all_dirs.txt"
while IFS= read -r line
do
  if [ "$line" != "" ]; then
  		mkdir -p "$line"
  		#echo $line
  fi
done < "$dirinput"

fileinput="all_files.txt"
while IFS= read -r line
do
  if [ "$line" != "" ]; then
  		curl $SCRIPT_BASEPATH/$line -o $line
  		#echo $line
  fi
done < "$fileinput"