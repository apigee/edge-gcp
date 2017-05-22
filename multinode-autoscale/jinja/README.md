# edge-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager. This uses gcp's autoscale feature to put RMP blocks in autoscale group.

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Apigee Deployment on GCP

Edge Topology- 7 node
![Deployment Template](/images/deploymentTemplate.png)

GCP Resource Deployment Model
![Resource Deployment Model](/images/resourceDeployment.png)

## Getting Started
- Create a ssh key pair 
    ```
    ssh-keygen -t rsa -b 4096 -C "apigee" -N "" -f apigee.key
    ```
    This generates a key pair file apigee.key and apigee.key.pub
    - Edit the apigee.key.pub file and prefix this with [USERNAME]: (apigee: in this case)  
    - so the public key file should like  [USERNAME]:ssh-rsa [KEY_VALUE] [USERNAME]
    - In this case USERNAME is apigee

- Edit the apigee-edge.yaml and change the entries 

    | properties        | Description                                    |
    | ----------------- |:-----------------------------------------------| 
    | machineType       | The machine types. Refer https://cloud.google.com/compute/docs/machine-types for list of all machine types               |
    | region            | gcloud region . asia-east1,europe-west1,us-central1,us-east1,us-west1  | 
    | zone              | The availability zone in region               |
    | nodes             | This repesents the deployment topologies. Presently it comes with bundled template of 5, 7 , 9  nodes. You can specify any of these values                                    |
    | cidr              | The subnet address.                            |
    | version           | The apigee private cloud release version       |
    | repo : host       | The software repo of apigee binaries           |
    | repo : protocol   | The software repo protocol  (http or https)    | 
    | repo : user       | The  user details to access Apigee software    |
    | repo : stage      | The repo stage (prod, e2e)                     |
    | repo : password   | The  password to access the software           |
    | APIGEE_ADMIN_EMAIL| Edge system admin user                         |
    | APIGEE_ADMINPW    | Edge System admin Password                     |
    | APIGEE_LDAPPW     | Edge LDAP password                             |
    | ORG_NAME          | Edge Org name                                  |
    | SKIP_SMTP         | If you want to skip Smtp it is y               |
    | SMTPHOST          | SMTP Host                                      |
    | SMTPMAILFROM      | SMTP MAIL FROM                                 |
    | SMTPUSER          | SMTP user. 0 if no user                        |
    | SMTPPASSWORD      | SMTP Password. 0 if no password                |
    | SMTPSSL           | Is SMTP on SSL                                 |
    | SMTPPORT          | SMTP port (25)                                 |
    | autoscale : size  | The target size of autoscale instances         |
    | autoscale : maxSize| The maximum number of autoscaled instances     |
    | SCRIPT_BASEPATH   | The raw  path where script is located          |
    | license           | Paste the license  text here                   |
    | public-key        | Paste the contents of apigee.key.pub  you created earlier|
    | private-key       | Paste the contents of apigee.key you created earlier|
 
    
- An example of apigee-edge.yaml would look like this. 
    ```sh
         machineType: n1-standard-2
         region: us-central1
         zone: us-central1-b
         nodes: 7
         cidr: 10.10.7.0/24
         version: '4.17.01'
         repo:
           host: software.apigee.com
           protocol: https
           user: apigee
           password: mypasswordToAccessRepo
           stage: release
         APIGEE_ADMIN_EMAIL: "opdk@apigee.com"
         APIGEE_ADMINPW: 'Secret123'
         APIGEE_LDAPPW: 'Secret123'
         ORG_NAME: ASG
         SKIP_SMTP: 'y'
         SMTPHOST: test.smtp.com
         SMTPMAILFROM: apiadmin@apigee.com
         SMTPUSER: test@example.com
         # 0 for no username
         SMTPPASSWORD: testpassword
         # 0 for no password
         SMTPSSL: 'y'
         SMTPPORT: 465
         autoscale:
            size: 2
            maxSize: 5
         SCRIPT_BASEPATH: "https://raw.githubusercontent.com/rajeshm7910/apigee-gcp/master/autoscale/jinja"
         license: "This is license text here"
         public-key: "apigee:sh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMQYOxjW0NaKon2OA0jecyM5Iw6bE4MW3AgYuXG7I+glrrfltiK/5JUx+3+Okp2dzhw== apigee"
         private-key: "-----BEGIN RSA PRIVATE KEY-----
         MIIJKQIBAAKCAgEAudAtZkWpC/1iYPI5tpKQp2YMHfOezaqdYFw890lnvYwdntbs
         ECeWSQiuREsnUbq/J3vJpFn21IDgFQBOifOuKoieBwtV6d0jOKoQ6cqonp2WAWFU
         msi3/vzfelCJxdF2YBuSd1vfbpxzqHgShCI2fXGjJ+aZLwp9NCshy12a1S+U1cd5
         c5X//bZe0L8Q2i+S/MzDyj0HC/92I3WBJb1iJZkoOm7NK1lQ9KwhPDHChhiC1fAr
         -----END RSA PRIVATE KEY-----"
    ```
- Deploy to GCP

    ```
    ./deploy.sh "RESOURCE_NAME"
    ```
    e.g :
```sh
./deploy.sh edgescale
The fingerprint of the deployment is 6wbe_dWiZbd4KTskWGiBeg==
Waiting for create [operation-1495082230045-54fc4f53b5949-227d2cc1-c844ee98]...done.
Create operation operation-1495082230045-54fc4f53b5949-227d2cc1-c844ee98 completed successfully.
NAME                                      TYPE                             STATE      ERRORS  INTENT
edgescale-apigee-ax0                      compute.v1.instance              COMPLETED  []
edgescale-apigee-ax1                      compute.v1.instance              COMPLETED  []
edgescale-apigee-dp                       compute.v1.instance              COMPLETED  []
edgescale-apigee-edge-setup-address       compute.v1.globalAddress         COMPLETED  []
edgescale-apigee-mgmt                     compute.v1.instance              COMPLETED  []
edgescale-apigee-rmp-as-as                compute.v1.autoscaler            COMPLETED  []
edgescale-apigee-rmp-as-bes-prod          compute.v1.backendService        COMPLETED  []
edgescale-apigee-rmp-as-bes-test          compute.v1.backendService        COMPLETED  []
edgescale-apigee-rmp-as-hc                compute.v1.httpHealthCheck       COMPLETED  []
edgescale-apigee-rmp-as-igm               compute.v1.instanceGroupManager  COMPLETED  []
edgescale-apigee-rmp-as-it                compute.v1.instanceTemplate      COMPLETED  []
edgescale-apigee-rmp-as-l7lb-prod         compute.v1.globalForwardingRule  COMPLETED  []
edgescale-apigee-rmp-as-l7lb-test         compute.v1.globalForwardingRule  COMPLETED  []
edgescale-apigee-rmp-as-lb                compute.v1.firewall              COMPLETED  []
edgescale-apigee-rmp-as-targetproxy-prod  compute.v1.targetHttpProxy       COMPLETED  []
edgescale-apigee-rmp-as-targetproxy-test  compute.v1.targetHttpProxy       COMPLETED  []
edgescale-apigee-rmp-as-urlmap-prod       compute.v1.urlMap                COMPLETED  []
edgescale-apigee-rmp-as-urlmap-test       compute.v1.urlMap                COMPLETED  []
edgescale-network                         compute.v1.network               COMPLETED  []
edgescale-network-firewall                compute.v1.firewall              COMPLETED  []
edgescale-network-firewall-internal       compute.v1.firewall              COMPLETED  []
edgescale-network-subnet                  compute.v1.subnetwork            COMPLETED  []
Please allow 15 minutes for edge to be installed
Please access the Edge UI at http://104.197.57.76:9000
Management Server is at http://104.197.57.76:8080
Please access the Devportal  at http://35.188.148.136:8079
Cred to access EdgeUI/Managament Server/DevPortal is :"opdk@apigee.com"/'Secret123'
Montitoring Dashboard http://104.197.57.76:3000
Creds for Monitoring Dashboard admin/admin
```


## Undeploy and Clean the deployment
```sh
./clean.sh "RESOURCE_NAME"
```
e.g :
```sh
./clean.sh edgescale
```
## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.

