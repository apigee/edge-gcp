##Get all the client and call apib
clients=($(gcloud compute instances list | grep $1-client | cut -d' ' -f1))
tLen=${#clients[@]}

for (( i=0; i<${tLen}; i++ ));
do
	 client=$(echo ${clients[$i]} | grep -oE "[^:]+$")
	 clientIP=$(gcloud compute instances describe $client | grep natIP | cut -d':' -f2 | sed -e 's/^[ \t]*//')
	 echo $clientIP
	 ssh -o StrictHostKeyChecking=no -i ../apigee.key apigee@$clientIP "nohup /home/apigee/apib/apib -c 10 -d 10  http://imedusa-test.apigee.net/customers > result.txt 2>&1 &"
done
