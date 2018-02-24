#Code with config
property_name=$1
APP_CWC=$2
IFS=','
mkdir -p /opt/apigee/customer
mkdir -p /opt/apigee/customer/application
touch /opt/apigee/customer/application/${property_name}

app_cwc_ary=($APP_CWC)
for item in ${app_cwc_ary[*]}
do
    cwc_item=$item
    if [["$cwc_item" != "None" ]];then
      cwc_item=${cwc_item/[/}
      cwc_item=${cwc_item/]/}
      cwc_item=${cwc_item/\'/}
      cwc_item=${cwc_item/\'/}
      cwc_item="$(echo -e "${cwc_item}" | tr -d '[:space:]')"
      echo $cwc_item >> /opt/apigee/customer/application/${property_name}
    fi
done
chown apigee:apigee /opt/apigee/customer/application/${property_name}