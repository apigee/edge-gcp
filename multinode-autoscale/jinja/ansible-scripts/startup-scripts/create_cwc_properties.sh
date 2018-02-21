#Code with config

IFS=' '
property_name=$1
RMP_CWC=$2

mkdir -p /opt/apigee/customer
mkdir -p /opt/apigee/customer/application
echo $RMP_CWC
rmp_cwc_ary=($RMP_CWC)
c=1
for i in "${rmp_cwc_ary[@]}"
do
if [[ ${i} != 'empty' ]]; then
  echo ${i}
  echo "${i}" >> /opt/apigee/customer/application/${property_name}
  ((c++))
fi
done
chown apigee:apigee /opt/apigee/customer/application/${property_name}
IFS=','