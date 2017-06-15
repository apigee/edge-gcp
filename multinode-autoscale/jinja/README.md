# edge-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager. This uses gcp's autoscale feature to put MP blocks in autoscale group.

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Apigee Private Cloud
Please go through http://docs.apigee.com/private-cloud/content/version-41705 to know more about Apigee Edge Private Cloud.

## Apigee Deployment on GCP

 - At this point of time, supported topologies are 2,5,7 and 9. For 5,7,9 node topologies, you can setup auto scaling. When set to auto scaling, Routers and MP's are configured in seperate nodes.
 - Additionally it also create Developer portal in a separate node for all supported toplogies. So for example if you choose to deploy 5 node topology, it will deploy developer portal on 6th node.
 
 - Supported Deployment Topologies

Edge Topology- 2 node
![Edge Topology- 2 node](/images/2node.png)

Edge Topology- 5 node
![Edge Topology- 5 node](/images/5node.png)

Edge Topology- 5 node with auto scaling
![Edge Topology- 5 node with auto scaling](/images/5node-auto-scaling.png)

Edge Topology- 7 node
![Edge Topology- 7 node](/images/7node.png)

Edge Topology- 7 node with auto scaling
![Edge Topology- 7 node with auto scaling](/images/7node-auto-scaling.png)

Edge Topology- 9 node
![Edge Topology- 9 node](/images/9node.png)

Edge Topology- 9 node with auto scaling
![Edge Topology- 9 node with auto scaling](/images/9node-auto-scaling.png)

GCP Resource Deployment Model for 7 node
![GCP Resource Deployment Model for 7 node](/images/resourceDeployment.png)

## Getting Started
- Create a ssh key pair 
    ```
    ssh-keygen -t rsa -b 4096 -C "apigee" -N "" -f apigee.key
    ```
    This generates a key pair file apigee.key and apigee.key.pub
    - Edit the apigee.key.pub file and prefix this with [USERNAME]: (apigee: in this case)  
    - so the public key file should like  
          ```
            apigee:sh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMQYOx.....2OA0jecyUx+3+Okp2dzhw== apigee
          ```

- Add missing fields repo->user, repo->password, public-key, private-key and license in apigee-edge.yaml. Change other entries as desired.

    | properties        | Description                                    |
    | ----------------- |:-----------------------------------------------| 
    | machineType       | The machine types. Refer https://cloud.google.com/compute/docs/machine-types for list of all machine types               |
    | region            | gcloud region . asia-east1,europe-west1,us-central1,us-east1,us-west1  | 
    | zone              | The availability zone in region               |
    | nodes             | This repesents the deployment topologies. Presently it comes with bundled template of 2,5,7,9 nodes. You can specify any of these values                                    |
    | cidr              | The subnet address.                            |
    | version           | The apigee private cloud release version       |
    | repo : host       | The software repo of apigee binaries           |
    | repo : protocol   | The software repo protocol  (http or https)    | 
    | repo : user       | The  user details to access Apigee software    |
    | repo : stage      | The repo stage (release, e2e)                     |
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
    | autoscale : enabled| The value can be true or false                |
    | autoscale : size  | The minimum number of rmp instances. Even if autoscale is false, you need to provide the number of rmp nodes           |
    | autoscale : maxSize| The maximum number of autoscaled instances    |
    | SCRIPT_BASEPATH   | The raw  path where script is located          |
    | license           | Paste the license  text here                   |
    | public-key        | Paste the contents of apigee.key.pub  you created earlier|
    | private-key       | Paste the contents of apigee.key you created earlier|
 
    
- An example of apigee-edge.yaml would look like this. 
    ```sh
         machineType: n1-standard-2
         region: us-central1
         zone: us-central1-b
         nodes: 5
         cidr: 10.10.7.0/24
         version: '4.17.05'
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
            enabled: true
            size: 2
            maxSize: 5
         SCRIPT_BASEPATH: "https://raw.githubusercontent.com/apigee/edge-gcp/master/multinode-autoscale/jinja"
         license: "Paste license text here"
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
    RESOURCE_NAME is the name you give to your deployments. All the GCP resources will be tagged under that RESOURCE. All the GCP resources are created with name  having prefix of "RESOURCE_NAME".
    e.g :
```sh
 ./deploy.sh edgescale
The fingerprint of the deployment is 9hoWNIgK1hZBgWMKaawwVw==
Waiting for create [operation-1497481444820-551f391938420-50c3ae86-82ae79ba]...done.
Create operation operation-1497481444820-551f391938420-50c3ae86-82ae79ba completed successfully.
NAME                                      TYPE                             STATE      ERRORS  INTENT
edgescale-apigee-ax0                      compute.v1.instance              COMPLETED  []
edgescale-apigee-ax1                      compute.v1.instance              COMPLETED  []
edgescale-apigee-dp                       compute.v1.instance              COMPLETED  []
edgescale-apigee-edge-setup-address       compute.v1.globalAddress         COMPLETED  []
edgescale-apigee-mgmt                     compute.v1.instance              COMPLETED  []
edgescale-apigee-rmp-as-bes-prod          compute.v1.backendService        COMPLETED  []
edgescale-apigee-rmp-as-bes-test          compute.v1.backendService        COMPLETED  []
edgescale-apigee-rmp-as-hc                compute.v1.httpHealthCheck       COMPLETED  []
edgescale-apigee-rmp-as-igm               compute.v1.instanceGroupManager  COMPLETED  []
edgescale-apigee-rmp-as-it                compute.v1.instanceTemplate      COMPLETED  []
edgescale-apigee-rmp-as-l7lb-prod         compute.v1.globalForwardingRule  COMPLETED  []
edgescale-apigee-rmp-as-l7lb-test         compute.v1.globalForwardingRule  COMPLETED  []
edgescale-apigee-rmp-as-lb                compute.v1.firewall              COMPLETED  []
edgescale-apigee-rmp-as-mp-as             compute.v1.autoscaler            COMPLETED  []
edgescale-apigee-rmp-as-mp-igm            compute.v1.instanceGroupManager  COMPLETED  []
edgescale-apigee-rmp-as-mp-it             compute.v1.instanceTemplate      COMPLETED  []
edgescale-apigee-rmp-as-targetproxy-prod  compute.v1.targetHttpProxy       COMPLETED  []
edgescale-apigee-rmp-as-targetproxy-test  compute.v1.targetHttpProxy       COMPLETED  []
edgescale-apigee-rmp-as-urlmap-prod       compute.v1.urlMap                COMPLETED  []
edgescale-apigee-rmp-as-urlmap-test       compute.v1.urlMap                COMPLETED  []
edgescale-network                         compute.v1.network               COMPLETED  []
edgescale-network-firewall                compute.v1.firewall              COMPLETED  []
edgescale-network-firewall-internal       compute.v1.firewall              COMPLETED  []
edgescale-network-subnet                  compute.v1.subnetwork            COMPLETED  []
Please allow upto 15 minutes for edge to be installed
Please access the Edge UI at http://35.184.252.116:9000
Management Server is at http://35.184.252.116:8080
Please access the Devportal  at http://104.198.251.5:8079
Cred to access EdgeUI/Managament Server/DevPortal is :"opdk@apigee.com"/'Secret123'
Montitoring Dashboard http://35.184.252.116:3000
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

## Troubleshootig

It uses ansible based scripts for multi node installation and there can be cases where the edge doesnt get installed even after 15 - 30 minutes. It may require additional diaganosis on what may have gone wrong in installation.

- Check if apigee-edge.yaml properties are correct. Check if private key, public key, repo user, repo password and  license files are set correctly.
- ssh to management server box which will be typically the vm with name "RESOUCE-NAME"-apigee-mgmt
- Go to /tmp/apigee/log directory and you can find two log files - ansible.log and setup-root.log. Looking into those files can provide clue to what may have gone wrong.


## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.

