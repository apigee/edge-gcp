HOST_NAMES=$1
APIGEE_ADMIN_EMAIL=$2
APIGEE_ADMINPW=$3
ORG_NAME=$4
LB_IP_ALIAS=$5

IFS=':'
hosts_ary=($HOST_NAMES)
c=1
for i in "${hosts_ary[@]}"
do
 if [[ ${i} != 'empty' ]]; then
   key='HOST'$c'_INTERNALIP'
   export ${key}=${i}
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

sed -i.bak s/ORG_NAME=/ORG_NAME="${ORG_NAME}"/g setup-org-prod.txt
sed -i.bak s/ORG_NAME=/ORG_NAME="${ORG_NAME}"/g setup-org-test.txt

sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g config.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-prod.txt
sed -i.bak s/LBDNS/"${LB_IP_ALIAS}"/g setup-org-test.txt