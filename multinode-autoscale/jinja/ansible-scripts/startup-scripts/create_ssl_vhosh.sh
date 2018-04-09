
admin_email=$APIGEE_ADMIN_EMAIL
admin_password=$APIGEE_ADMINPW
org=$ORG_NAME

declare -a envs=("test" "prod")
ssl_port=443
temp_dir=/tmp/apigee
echo ${temp_dir}

## now loop through the above array
for env_name in "${envs[@]}"
do
   echo "$env_name"
   #cat apigee-edge.yaml | grep -w key | cut -d ':' -f2 | head -1 | sed -e s/\"//g | base64 --decode > ${temp_dir}/key_$env_name.pem
   #cat apigee-edge.yaml | grep -w crt | cut -d ':' -f2 | head -1 | sed -e s/\"//g | base64 --decode > ${temp_dir}/crt_$env_name.pem
   eval echo \${KEY_$env_name} | base64 --decode > ${temp_dir}/key_$env_name.pem 
   eval echo \${CRT_$env_name} | base64 --decode > ${temp_dir}/crt_$env_name.pem 

   #lb_ip_alias=$(gcloud compute addresses describe $1-apigee-edge-setup-address-${env_name} --global | grep address: | cut -d':' -f2 | tr -d ' ' | sed -e s/\"//g)
   if [[ "$env_name" == "test" ]]; then
   		if [[ -n "$DNS_TEST" ]]; then
   			lb_ip_alias=$DNS_TEST
   		else
   			lb_ip_alias=$LB_IP_ALIAS_TEST
   		fi
   		if [[ $topology == '2' ]];
   			ssl_port=9003
   		fi
   else if [[ "$env_name" == "prod" ]]; then
   	#statements
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
	#curl -s  -v -u $admin_email:$admin_password -H "Content-Type:application/json"  -X DELETE $mgmt_url/v1/o/$org/e/$env_name/virtualhosts/secure
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