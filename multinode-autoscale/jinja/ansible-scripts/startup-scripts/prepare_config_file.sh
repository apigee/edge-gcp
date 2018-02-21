topology=$1
HOST_NAMES=$2
APIGEE_ADMIN_EMAIL=$3
APIGEE_ADMINPW=$4
ORG_NAME=$5
LB_IP_ALIAS=$6
SKIP_SMTP=$7
SMTPHOST=$8
SMTPMAILFROM=$9
SMTPSSL=${10}
SMTPUSER=${11}
SMTPPASSWORD=${12}

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

if [[ -z ${LB_IP_ALIAS} ]]; then
  LB_IP_ALIAS=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")
fi

echo "topology ${topology}"

if [[ $topology = '2' ]]; then
 LB_IP_ALIAS=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")
 echo "LB_IP_ALIAS ${LB_IP_ALIAS}"
 sed -i.bak s/VHOST_BASEURL=.*//g setup-org-prod.txt
 sed -i.bak s/VHOST_BASEURL=.*//g setup-org-test.txt
fi
echo "LB_IP_ALIAS ${LB_IP_ALIAS}"


sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g config.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-prod.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-test.txt