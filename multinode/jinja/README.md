# apigee-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/docs
- Initialize your account

## Before you start
- Edit the jinja/apigee-vm.yaml and update the properies

    ```sh
         machineType: n1-standard-2
	     zone: us-central1-b
	     region: us-central1
	     nodes: 5
	     cidr: 192.168.3.0/24
	     ftp:
	       user: 
	       password: 
	     APIGEE_ADMIN_EMAIL: "opdk@apigee.com"
	     APIGEE_ADMINPW: 'Secret123'
	     ORG_NAME: 'myorg'
	     SCRIPT_BASEPATH: "https://raw.githubusercontent.com/rajeshm7910/apigee-gcp/master/multinode"
	     license: "JakHrOe9fdsf436545==="
	     public-key: "apigee:ssh-rsa AAAAB3 apigee"
	     private-key: "-----BEGIN RSA PRIVATE KEY-----
	MIIEpQIBAAKCAQEAryMtKdAnGzd2f+R2EbZpiATHj8SF0paVnuf2moJQzyMNRDHA
	-----END RSA PRIVATE KEY-----"
    ```
- Generate a key pair using ssh-keygen tool for apigee user (ssh-keygen -t rsa -b 4096 -C "apigee" ) and paste the key pair in public-key and private-key section  

- nodes can take value of 5 for 5-node and 9 for 9-node cluster setup respectively.

## Deploy any profile
```sh
./deploy.sh "RESOURCE_NAME"
```
e.g :
```sh
./deploy.sh apigee5node
```

## Undeploy and Clean the deployment
```sh
./clean.sh "RESOURCE_NAME"
```
e.g :
```sh
./clean.sh apigee5node
```
## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.

