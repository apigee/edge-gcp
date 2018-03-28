#!/bin/bash
for number in {1..3}
do
  yum install nodejs -y
done
cd /tmp/apigee/ansible-scripts/startup-scripts/vaults
npm install
#Lets replace the  values
sed -i.bak s/user_ftp/"${REPO_USER}"/g server.js
sed -i.bak s/pass_ftp/"${REPO_PASSWORD}"/g server.js
sed -i.bak s/user_apigee/"${APIGEE_ADMIN_EMAIL}"/g server.js
sed -i.bak s/password_apigee/"${APIGEE_ADMINPW}"/g server.js
sed -i.bak s/pwd_ldap/"${APIGEE_LDAPPW}"/g server.js
sed -i.bak s/password_smtp/"${SMTPPASSWORD}"/g server.js
rm -fr server.js.bak
node server.js
