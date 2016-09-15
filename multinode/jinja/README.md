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
         region: us-central1
	     zone: us-central1-b
	     nodes: 5
	     cidr: 192.168.3.0/24
	     softwareRepo: https://software.apigee.com
         version: '4.16.05'
	     ftp:
	       user: 
	       password: 
	     APIGEE_ADMIN_EMAIL: "opdk@apigee.com"
         APIGEE_ADMINPW: 'Secret123'
         APIGEE_LDAPPW: 'Secret123'
         ORG_NAME: myorg
         SKIP_SMTP: 'y'
         SMTPHOST: test.smtp.com
         SMTPUSER: test@example.com
         # 0 for no username
         SMTPPASSWORD: testpassword
         # 0 for no password
         SMTPSSL: 'y'
         SMTPPORT: 465
	     SCRIPT_BASEPATH: "https://raw.githubusercontent.com/rajeshm7910/apigee-gcp/master/multinode/jinja"
	     license: "JakHrOe9fdsf436545==="
	     public-key: "apigee:ssh-rsa AAAAB3 apigee"
	     private-key: "-----BEGIN RSA PRIVATE KEY-----
	MIIEpQIBAAKCAQEAryMtKdAnGzd2f+R2EbZpiATHj8SF0paVnuf2moJQzyMNRDHA
	-----END RSA PRIVATE KEY-----"
    ```
-   Details about Properties


| properties        | Description                                                             | 
| ----------------- |:------------------------------------------------------------------------| 
| machineType       | The machine type to choose. Minimum try to provide 8 GM RAM             | 
| region            | gcloud region                                                           | 
| zone              | gcloud zone                                                             |
| nodes             | can take value of 1 for aio, 5 for 5-node and 9 for 9-node cluster setup respectively                                                                                  |
| cidr              | subnet you want to create                                               |
| softwareRepo      | It is the apigee hosted repo.                                           |
| version           | 4.16.05 is the latest version. Possible value - 4.16.09                 |
| ftp               | Apigee ftp creds                                                        |
| APIGEE_ADMIN_EMAIL| System admin user                                                       |
| APIGEE_ADMINPW    | System admin password                                                   |
| APIGEE_LDAPPW     | LDAP password                                                           |
| ORG_NAME          | Your Org Name                                                           |
| SKIP_SMTP         |  If you want to skip these settings please put 'y' otherwise 'n'        |
| SMTPHOST          | SMTP Server                                                             |
| SMTPUSER          | SMTP user # 0 for no username                                           |
| SMTPPASSWORD      | SMTP password  # 0 for no password                                      |
| SMTPSSL           | If its on SSL, 'y' otherwise 'n'                                        |
| SMTPPORT          | specify port                                                            |
| SCRIPT_BASEPATH   | Path of ansible scripts. This doesnt changes                            |
| license           | Paste your license file                                                 |
| public-key        | Generate a key pair using ssh-keygen tool for apigee user (ssh-keygen -t rsa -b 4096 -C "apigee" ) and paste the public-key here. Please keep passphrase as empty.     |
| private-key       | Paste your private key from the above generated pair.                   |



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

