#!/bin/bash
for number in {1..3}
do
  yum install nodejs -y
done
npm install
npm start
