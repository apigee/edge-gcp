# apigee-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager. This uses gcp's autoscale feature to put RMP blocks in autoscale group.

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Apigee Deployment on GCP

![Deployment Template](/images/deploymentTemplate.png)
Format: ![Alt Text](url)

![Resource Deployment Model](/images/resourceDeployment.png)
Format: ![Alt Text](url)

## Getting Started
- Create a ssh key pair 
    ```
    ssh-keygen -t rsa -b 4096 -C "apigee" -N "" -f apigee.key
    ```
    This generates a key pair file apigee.key and apigee.key.pub

- Edit the apigee-edge.yaml and change the entries 

    | properties        | Description                                    |
    | ----------------- |:-----------------------------------------------| 
    | machineType       | The machine types. Refer https://cloud.google.com/compute/docs/machine-types for list of all machine types               |
    | region            | gcloud region . asia-east1,europe-west1,us-central1,us-east1,us-west1  | 
    | zone              | The availability zone in region               |
    | nodes             | This repesents the deployment topologies. Presently it comes with bundled template of 5, 7 , 9  nodes. You can specify any of these values                                    |
    | cidr              | The subnet address.                            |
    | softwareRepo      | The apigee sofftware Repo.                     |
    | version           | The apigee private cloud release version       |
    | ftp : user        | The ftp user details to access Apigee software |
    | ftp : password    | The ftp password to access the software        |
    | APIGEE_ADMIN_EMAIL| Edge system admin user                         |
    | APIGEE_ADMINPW    | Edge System admin Password                     |
    | APIGEE_LDAPPW     | Edge LDAP password                             |
    | ORG_NAME          | Edge Org name                                  |
    | SKIP_SMTP         | If you want to skip Smtp it is y               |
    | SMTPHOST          | SMTP Host                                      |
    | SMTPUSER          | SMTP user. 0 if no user                        |
    | SMTPPASSWORD      | SMTP Password. 0 if no password                |
    | SMTPSSL           | Is SMTP on SSL                                 |
    | SMTPPORT          | SMTP port (25)                                 |
    | autoscale : size  | The target size of autoscale instances         |
    | autoscale : maxSize| The maximum number of autoscaled instances     |
    | SCRIPT_BASEPATH   | The raw  path where script is located          |
    | license           | Paste the licese file here                     |
    | public-key        | Paste the contents of apigee.key.pub  you created earlier|
    | private-key       | Paste the contents of apigee.key you created earlier|
 
    
- An example of apigee-edge.yaml would look like this. 
    ```sh
         machineType: n1-standard-2
         region: us-central1
         zone: us-central1-b
         nodes: 7
         cidr: 192.168.2.0/24
         softwareRepo: https://software.apigee.com
         version: '4.16.09'
         ftp:
           user: apigee
           password: mypasswordToAccessRepo
         APIGEE_ADMIN_EMAIL: "opdk@apigee.com"
         APIGEE_ADMINPW: 'Secret123'
         APIGEE_LDAPPW: 'Secret123'
         ORG_NAME: ASG
         SKIP_SMTP: 'y'
         SMTPHOST: test.smtp.com
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
         license: "This is license file"
         public-key: "sh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMQYOxjW0NaKon2OA0jecyM5Iw6bE4MW3AgYuXG7I+glrrfltiK/5JUx+3+Okp2dzhw== apigee"
         private-key: "-----BEGIN RSA PRIVATE KEY-----
MIIJKQIBAAKCAgEAzEGDsY1tDWiqJ9jgNI3nMjOSMOmxODFtwIGLlxuyPoJa635b
Yiv+SVMft/jpPAiZ2rLU/utn7ZBNs/hEoIEeHNITIocAy6jAknjvbBUT78KnaCq2Omi708NOpTUTHHH+nqfLlXAmYGhrMLDFwT7lqTOzHGw6vKszN8TfMsxGghVeDdB5
WtR7iP9W+2D0Z7Jikes+M6Md4V1eA+jKN7mLtFQkR3CTEaxyBiOBKGWo6La6
-----END RSA PRIVATE KEY-----"
    ```
- Deploy to GCP

    ```
    ./deploy.sh "RESOURCE_NAME"
    ```
    e.g :
```sh
./deploy.sh edgescale
Waiting for create operation-1475126000809-53d9e8946f428-6d386c0b-d2f84caa...done.
Create operation operation-1475126000809-53d9e8946f428-6d386c0b-d2f84caa completed successfully.
NAME                                      TYPE                             STATE      ERRORS
edgescale-apigee-ax0                      compute.v1.instance              COMPLETED  []
edgescale-apigee-ax1                      compute.v1.instance              COMPLETED  []
edgescale-apigee-ds1                      compute.v1.instance              COMPLETED  []
edgescale-apigee-ds2                      compute.v1.instance              COMPLETED  []
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
Please access the management UI at http://104.198.167.243:9000
Management Server is at http://104.198.167.243:8080
Montitoring Dashboard http://104.198.167.243:3000
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

