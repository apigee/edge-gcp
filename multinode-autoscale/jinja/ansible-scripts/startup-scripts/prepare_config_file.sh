HOST_NAMES=$1
APIGEE_ADMIN_EMAIL=$2
APIGEE_ADMINPW=$3
ORG_NAME=$4
LB_IP_ALIAS=$5
SKIP_SMTP=$6
SMTPHOST=$7
SMTPMAILFROM=$8
SMTPSSL=$9
SMTPUSER=${10}
SMTPPASSWORD=${11}

IFS=':'
hosts_ary=($HOST_NAMES)
c=1
for i in "${hosts_ary[@]}"
do
 if [[ ${i} != 'empty' ]]; then
   key='HOST'$c'_INTERNALIP'
   export ${key}=${i}
   sed -i.bak s/${key}/${i}/g /tmp/apigee/ansible-scripts/inventory/hosts
   sed -i.bak s/${key}/${i}/g /tmp/apigee/ansible-scripts/config/config.txt
   sed -i.bak s/${key}/${i}/g /tmp/apigee/ansible-scripts/config/grafana.txt
   sed -i.bak s/${key}/${i}/g /tmp/apigee/ansible-scripts/config/setup-org-prod.txt
   sed -i.bak s/${key}/${i}/g /tmp/apigee/ansible-scripts/config/setup-org-test.txt
   ((c++))
 fi
done
MYHOST=$(hostname -i)
cd /tmp/apigee/ansible-scripts/inventory
sed -i.bak s/HOST_RMP/${MYHOST}/g hosts

cd /tmp/apigee/ansible-scripts/config
sed -i.bak s/ADMIN_EMAIL=/ADMIN_EMAIL="${APIGEE_ADMIN_EMAIL}"/g config.txt
sed -i.bak s/ADMIN_EMAIL=/ADMIN_EMAIL="${APIGEE_ADMIN_EMAIL}"/g setup-org-prod.txt
sed -i.bak s/ADMIN_EMAIL=/ADMIN_EMAIL="${APIGEE_ADMIN_EMAIL}"/g setup-org-test.txt

sed -i.bak s/APIGEE_ADMINPW=/APIGEE_ADMINPW="${APIGEE_ADMINPW}"/g config.txt
sed -i.bak s/APIGEE_ADMINPW=/APIGEE_ADMINPW="${APIGEE_ADMINPW}"/g setup-org-prod.txt
sed -i.bak s/APIGEE_ADMINPW=/APIGEE_ADMINPW="${APIGEE_ADMINPW}"/g setup-org-test.txt

sed -i.bak s/APIGEE_LDAPPW=/APIGEE_LDAPPW="${APIGEE_LDAPPW}"/g config.txt

sed -i.bak s/ORG_NAME=/ORG_NAME="${ORG_NAME}"/g setup-org-prod.txt
sed -i.bak s/ORG_NAME=/ORG_NAME="${ORG_NAME}"/g setup-org-test.txt

sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g config.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-prod.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-test.txt

sed -i.bak s/SKIP_SMTP=.*/SKIP_SMTP=${SKIP_SMTP}/g config.txt
sed -i.bak s/SMTPHOST=.*/SMTPHOST=${SMTPHOST}/g config.txt
sed -i.bak s/SMTPMAILFROM=.*/SMTPMAILFROM=${SMTPMAILFROM}/g config.txt
sed -i.bak s/SMTPUSER=.*/SMTPUSER=${SMTPUSER}/g config.txt
sed -i.bak s/SMTPPASSWORD=.*/SMTPPASSWORD=${SMTPPASSWORD}/g config.txt
sed -i.bak s/SMTPSSL=.*/SMTPSSL=${SMTPSSL}/g config.txt
sed -i.bak s/SMTPPORT=.*/SMTPPORT="${SMTPPORT}"/g config.txt

sed -i.bak s/MGMTIP/$(hostname -i)/g dp-config.txt
sed -i.bak s/DEVADMIN_USER=/DEVADMIN_USER="${APIGEE_ADMIN_EMAIL}"/g dp-config.txt
sed -i.bak s/DEVADMIN_PWD=/DEVADMIN_PWD="${APIGEE_ADMINPW}"/g dp-config.txt
sed -i.bak s/EDGE_ORG=/EDGE_ORG="${ORG_NAME}"/g dp-config.txt
sed -i.bak s/DEVPORTAL_ADMIN_USERNAME=/DEVPORTAL_ADMIN_USERNAME="${APIGEE_ADMIN_EMAIL}"/g dp-config.txt
sed -i.bak s/DEVPORTAL_ADMIN_PWD=/DEVPORTAL_ADMIN_PWD="${APIGEE_ADMINPW}"/g dp-config.txt
sed -i.bak s/DEVPORTAL_ADMIN_EMAIL=/DEVPORTAL_ADMIN_EMAIL="${APIGEE_ADMIN_EMAIL}"/g dp-config.txt

echo "LB_IP_ALIAS ${LB_IP_ALIAS}"
if [[ -z ${LB_IP_ALIAS} ]]; then
  LB_IP_ALIAS=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")
fi
if [[ $topology == '2' ]]; then
 LB_IP_ALIAS=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")
 sed -i.bak s/VHOST_BASEURL=.*//g setup-org-prod.txt
 sed -i.bak s/VHOST_BASEURL=.*//g setup-org-test.txt
fi

sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g config.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-prod.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-test.txt