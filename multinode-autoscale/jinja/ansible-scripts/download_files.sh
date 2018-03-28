#!/bin/bash
BASE_PATH="https://raw.githubusercontent.com/apigee/edge-gcp/master/multinode-autoscale/jinja/ansible-scripts"
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
  		curl $BASE_PATH/$line -o $line
  fi
done < "$fileinput"