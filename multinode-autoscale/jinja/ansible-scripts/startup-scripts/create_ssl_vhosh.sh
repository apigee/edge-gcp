
admin_email=$APIGEE_ADMIN_EMAIL
admin_password=$APIGEE_ADMINPW
org=$ORG_NAME
mgmt_url=http://localhost:8080
declare -a envs=("test" "prod")
ssl_port=443
temp_dir=/tmp/apigee
echo ${temp_dir}
## now loop through the above array
for env_name in "${envs[@]}"
do
   echo "$env_name"
   eval echo \${KEY_$env_name} | base64 -di > ${temp_dir}/key_$env_name.pem 
   eval echo \${CRT_$env_name} | base64 -di > ${temp_dir}/crt_$env_name.pem 
   if [[ "$env_name" == "test" ]]; then
                if [[ -n "$DNS_TEST" ]]; then
                        lb_ip_alias=$DNS_TEST
                else
                        lb_ip_alias=$LB_IP_ALIAS_TEST
                fi
                if [[ $topology == '2' ]];then
                        ssl_port=9003
                fi
   elif [[ "$env_name" == "prod" ]]; then
                if [[ -n "$DNS_PROD" ]]; then
                        lb_ip_alias=$DNS_PROD
                else
                        lb_ip_alias=$LB_IP_ALIAS
                fi
   fi
   echo $lb_ip_alias
   ##Delete the existing virtual host and keystore
   curl -s  -u $admin_email:$admin_password  -X DELETE $mgmt_url/v1/o/$org/e/$env_name/virtualhosts/secure
   curl -s  -u $admin_email:$admin_password  -X DELETE $mgmt_url/v1/o/$org/e/$env_name/keystores/trial
   #Get the private key and cert file and write it to file
   curl -s  -u $admin_email:$admin_password  -X POST $mgmt_url/v1/o/$org/e/$env_name/keystores  -H "Content-Type: application/json" -d "{\"name\" : \"trial\"}"
   curl -s  -u $admin_email:$admin_password  -X POST -H "Content-Type: multipart/form-data" -F keyFile="@${temp_dir}/key_${env_name}.pem" -F certFile="@${temp_dir}/crt_${env_name}.pem" \
                $mgmt_url/v1/o/$org/e/$env_name/keystores/trial/aliases?alias=trial\&format=keycertfile
        #Now creare a virtualhost
        curl -s -v -u $admin_email:$admin_password -H "Content-Type:application/json"  -X POST $mgmt_url/v1/o/$org/e/$env_name/virtualhosts \
                  -d "{
                        \"hostAliases\": [\"$lb_ip_alias\"],
            \"interfaces\": [],
                  \"listenOptions\": [],
                  \"name\": \"secure\",
                  \"port\": \"$ssl_port\",
            \"sSLInfo\": {
                \"ciphers\": [],
                      \"clientAuthEnabled\": \"false\",
                      \"enabled\": \"true\",
                      \"ignoreValidationErrors\": false,
                \"keyAlias\": \"trial\",
                \"keyStore\": \"trial\",
                \"protocols\": []
                   }
                }"
done