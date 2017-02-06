# edge-gcp
This project allows you to install Apigee Edge in Google Cloud Platform using GCP's deployment manager. Please refer to http://docs.apigee.com/private-cloud/latest/overview for more details on Apigee Edge Private Cloud.


## Prerequisite

### gcloud 
Install gcloud sdk from https://cloud.google.com/sdk/downloads
Initialize your account

## Apigee Edge Profiles
### aio (All in One)
This profile helps to create a AIO profile in Google cloud platform. The details are present 
[here](../../tree/master/aio/jinja)

### autoscale (Edge Autoscale deployment with Http Load Balancer)
This profile helps to create a 5,7,9 node cluster deployment in Google cloud platform. 

The details are present [here](../../tree/master/autoscale/jinja)

## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.
