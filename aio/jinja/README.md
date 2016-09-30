# apigee-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Before you start
- Edit the aio/jinja/apigee-vm.yaml and update the properies

    ```sh
        aio-config: aio-config.txt
        machineType: [ machine type  e.g: n1-highcpu-8]
        zone: [ zone e.g : us-central1-b]
        softwareRepo: https://software.apigee.com
        version: '4.16.09'
        ftp:
            user: [Your Apigee's FTP user]
            password: [Your Apigee's FTP password]
        license: "[your license]" #Paste the contents of license file.
    ```
- Change the silent config file entries present in aio/jinja/aio-config.txt

## Deploy AIO profile
```sh
./deploy.sh "RESOURCE_NAME" "zone"
```
e.g :
```sh
./deploy.sh apigee-edge us-central1-b
```

## Undeploy and Clean the deployment
```sh
./clean.sh "RESOURCE_NAME"
```
e.g :
```sh
./clean.sh apigee-edge
```
## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.

