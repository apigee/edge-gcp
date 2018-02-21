#Code with config

property_name=$1
APP_CWC=$2
IFS=' '

mkdir -p /opt/apigee/customer
mkdir -p /opt/apigee/customer/application
echo $APP_CWC

app_cwc_ary=($APP_CWC)
c=1
for i in "${app_cwc_ary[@]}"
do
if [[ ${i} != 'empty' ]]; then
  echo ${i}
  echo "${i}" >> /opt/apigee/customer/application/${property_name}
  ((c++))
fi
done
chown apigee:apigee /opt/apigee/customer/application/${property_name}
IFS=','