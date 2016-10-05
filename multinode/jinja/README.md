# apigee-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Getting Started
- Create a ssh key pair 
    ```
    ssh-keygen -t rsa -b 4096 -C "apigee" -N "" -f apigee.key
    ```
    This generates a key pair file apigee.key and apigee.key.pub
    - Edit the apigee.key.pub file and add the user apigee in begining 
    - so it will look like  [USERNAME]:ssh-rsa [KEY_VALUE] [USERNAME]
    - In this case USERNAME is apigee


- Edit the apigee-edge.yaml and change the entries 

| properties        | Description                                                             | 
| ----------------- |:------------------------------------------------------------------| 
| machineType       | The machine type to choose. Minimum try to provide 8 GM RAM       |
| region            | gcloud region asia-east1,europe-west1,us-central1,us-east1,us-west1                                   | 
| zone              | gcloud avaialbility zone of region                                |
| nodes             | This can take value of 1 for aio, 5 for 5-node and 9 for 9-node cluster setup respectively                                                                      |
| cidr              | subnet you want to create                                         |
| softwareRepo      | It is the apigee hosted repo.                                     |
| version           |   4.16.09                 |
| ftp : user        | The ftp user details to access Apigee software                    |
| ftp : password    | The ftp password to access the software                           |
| APIGEE_ADMIN_EMAIL| Edge System admin user                                            |
| APIGEE_ADMINPW    | Edge System admin password                                        |
| APIGEE_LDAPPW     | Edge LDAP password                                                |
| ORG_NAME          | Edge Org Name                                                     |
| SKIP_SMTP         | If you want to skip these settings please put 'y' otherwise 'n'   |
| SMTPHOST          | SMTP Server                                                       |
| SMTPUSER          | SMTP user # 0 for no username                                     |
| SMTPPASSWORD      | SMTP password  # 0 for no password                                |
| SMTPSSL           | If its on SSL, 'y' otherwise 'n'                                  |
| SMTPPORT          | specify port                                                      |
| SCRIPT_BASEPATH   | Path of ansible scripts. This doesnt changes                      |
| license           | Paste your license file                                           |
| public-key        | Paste the contents of apigee.key.pub generated above              |
| private-key       | Paste the contents of apigee.key generated above                  |

- An example of apigee-edge.yaml would look like this. 

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
MIIJKQIBAAKCAgEAzEGDsY1tDWiqJ9jgNI3nMjOSMOmxODFtwIGLlxuyPoJa635b
Yiv+SVMft/jpPAiZ2rLU/utn7ZBNs/hEoIEeHNITIocAy6jAknjvbBUT78KnaCq2Omi708NOpTUTHHH+nqfLlXAmYGhrMLDFwT7lqTOzHGw6vKszN8TfMsxGghVeDdB5
WtR7iP9W+2D0Z7Jikes+M6Md4V1eA+jKN7mLtFQkR3CTEaxyBiOBKGWo6La6
-----END RSA PRIVATE KEY-----"
    ```

## Deploy any profile
```sh
./deploy.sh "RESOURCE_NAME" "zone"
```
e.g :
```sh
./deploy.sh apigee5node us-central1-b
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

