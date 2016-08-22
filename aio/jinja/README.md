# apigee-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager

## Prerequisite

### gcloud 
Install gcloud sdk from https://cloud.google.com/sdk/docs
Initialize your account

## Before you start
1. Edit the aio/jinja/apigee-vm.yaml and update the properies
 properties:
     aio-config: aio-config.txt
     machineType: [ machine type  e.g: n1-highcpu-8]
     zone: [ zone e.g : us-central1-b]
     ftp:
       user: [Your Apigee's FTP user]
       password: [Your Apigee's FTP password]
     license: "[your license]"

#### license should be pasted in a string, remove any carriage return characters in license file. 

2. Change the silent config file entries present in aio/jinja/aio-config.txt


## Deploy the profile
./aio/jinja/deploy.sh "RESOURCE_NAME"

e.g :
./aio/jinja/deploy.sh apigee-edge


## Undeploy and Clean the deployment
./aio/jinja/clean.sh "RESOURCE_NAME"

e.g :
./aio/jinja/clean.sh apigee-edge
## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.
