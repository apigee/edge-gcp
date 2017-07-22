##Get all the client and call apib
#Format ./auto_scaling_testing.sh <resource> <concurrency> <duration> <apibase>
clients=($(gcloud compute instances list | grep $1-client | cut -d' ' -f1))
tLen=${#clients[@]}

for (( i=0; i<${tLen}; i++ ));
do
	 client=$(echo ${clients[$i]} | grep -oE "[^:]+$")
	 clientIP=$(gcloud compute instances describe $client | grep natIP | cut -d':' -f2 | sed -e 's/^[ \t]*//')
	 echo $clientIP
	 ssh -o StrictHostKeyChecking=no -i apigee.key apigee@$clientIP "nohup /home/apigee/apib/apib -c $2 -d $3  $4/customers > /home/apigee/result.txt 2>&1 &"
done
