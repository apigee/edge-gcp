# edge-gcp
This project allows you to install edge in Google Cloud Platform using GCP's deployment manager. This uses gcp's autoscale feature to put MP blocks in autoscale group.

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Apigee Private Cloud
Please go through https://docs.apigee.com/private-cloud/latest/overview to know more about Apigee Edge Private Cloud.


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

- Add missing fields repo->apigee->user, repo->apigee->password, setup->public_key, setup->private_key and setup->license in apigee-edge.yaml. Change other entries as desired.

    | properties                             | Description                                    |
    | -------------------------------------- |:-----------------------------------------------|
    | repo                                   | This section covers all repository related information| 
    | repo:apigee:host                       | The software repo of apigee binaries           |
    | repo:apigee:protocol                   | The software repo protocol  (http or https)    | 
    | repo:apigee:user                       | The  user id to access Apigee software         |
    | repo:apigee:password                   | The  user password to access Apigee software   |
    | repo:apigee:stage                      | The repo stage (release, e2e)                  |
    | repo:apigee:version                    | The apigee private cloud release version       |
    | repo:thirdparty                        | All the third party libraries are listed here. They will all be installed in all the vms. Please don't remove any entries here. You may add extra libraies if you are modify templates and use some custom libraries.                                           |
    | infra:                                 | All infrastructure related information goes here|     
    | infra: topology                        | This repesents the deployment topologies. Presently   it comes with bundled template of 2,5,7,9 nodes. You can specify any of these values               |
    | infra:datacenters:primary:name          | Name of primary datacenter name.              |
    | infra:datacenters:primary:region        | Datacenter region                             |
    | infra:datacenters:primary:zone          | The primary zone of datacenter                |
    | infra:datacenters:primary:vpc:cidr      | The subnet cidr                               |
    | infra:datacenters:ms:machineType        | The machine type for management server.       |
    | infra:datacenters:ms:diskSizeGb         | The disk size associated with management server    |
    | infra:datacenters:ds:machineType        | The machine type for datastore(Cassandra/Zookeeper) server.                                                                                        |
    | infra:datacenters:ds:diskSizeGb         | The disk size associated with for datastore(Cassandra/Zookeeper) server                                                                                |
    | infra:datacenters:rmp:machineType       | The machine type for router/MP server.               |
    | infra:datacenters:rmp:diskSizeGb        | The disk size associated with router/MP server       |
    | infra:datacenters:rmp:autoscale.enabled | The value can be true or false                       |
    | infra:datacenters:rmp:autoscale.size    | The minimum number of mp instances. This is mandatory|
    | infra:datacenters:rmp:autoscale.maxSize | he maximum number of autoscaled instances            |
    | infra:datacenters:ax:machineType        | The machine type for Analytics(PG & QPID) server.    |
    | infra:datacenters:ax:diskSizeGb         | The disk size associated with Analytics(PG & QPID)   |
    | infra:datacenters:portal:machineType    | The machine type for Portal server.                  |
    | infra:datacenters:portal:diskSizeGb     | The disk size associated with portal server          |
    | setup:                                  | This section covers the setup related information.   |
    | setup:apigee_admin_email                | Edge system admin user                               |
    | setup:apigee_admin_password             | Edge System admin Password                           |
    | setup:apigee_ldappw                     | Edge LDAP password                                   |
    | setup:org_name                          | Org Name                                             |
    | setup:skip_smtp                         | 'y' or 'n'                                           |
    | setup:smtp_host                         | smtp Host                                            |
    | setup:smtp_mail_from                    | smtp Mail From                                       |
    | setup:smtp_user                         | smtp user. 0 for no user                             |
    | setup:smtp_password                     | smtp password. 0 fro no password                     |
    | setup:smtp_ssl.                         | 'y' or 'n'                                           |
    | setup:smtp_port| 465                    | smtp port. default 25. For ssl its 465               |
    | setup:script_base_path                  | 'https://raw.githubusercontent.com/apigee/edge-gcp/master/multinode-autoscale/jinja/ansible-scripts'. Please don't change this unless required                                                         |
    | setup:config:code_with_config           | This section deals with all code with config settings. |
    | setup:config:code_with_config.ds        | Cassandra and Zookeeper related code with config.      |
    | setup:config:code_with_config.ms        | Management server code with config.                    |
    | setup:config:code_with_config.router    | Router related code with config. Please look at the example below of how you can set code with config                                                          |
    | setup:config:code_with_config.mp        | Message processor related code with config. Please look at the example below of how you can set code with config                                                   |
    | setup:config:code_with_config.ax        | Analytics(qpid/PG) related code with config.            |
    | setup:config:code_with_config.portal    | Portal related code with config.                        |      
    | setup:license                           | Paste the license  text here                             |
    | setup:public_key                        | Paste the contents of apigee.key.pub  you created earlier|
    | setup:private_key                       | Paste the contents of apigee.key you created earlier.    |
 
    
- An example of apigee-edge.yaml would look like this. 
    ```sh
         repo:
          apigee:
            host: software.apigee.com
            protocol: https
            user: apigeesoftwareuser
            password: x2334t23455
            stage: release
            version: 4.18.01
          thirdparty:
          - https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
          - http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/j/jq-1.5-1.el7.x86_64.rpm
          - http://mirror.centos.org/centos/7/extras/x86_64/Packages/ansible-2.3.1.0-3.el7.noarch.rpm
        infra:
          topology: 5
          datacenters:
            primary:
              name: dc-1
              region: us-central1
              zone: us-central1-b
              vpc:
               create: true
               cidr: 10.10.2.0/24
          ms:
            machineType: n1-standard-2
            diskSizeGb: 20
          ds:
            machineType: n1-standard-2
            diskSizeGb: 20
          rmp:
            machineType: n1-standard-2
            diskSizeGb: 20
            autoscale:
              enabled: false
              size: 2
              maxSize: 5
          ax:
            machineType: n1-standard-2
            diskSizeGb: 20
          portal:
            machineType: n1-standard-2
            diskSizeGb: 20
        setup:
          apigee_admin_email: "opdk@apigee.com"
          apigee_admin_password: 'Secret123'
          apigee_ldappw: 'Secret123'
          org_name: trial
          skip_smtp: 'y'
          smtp_host: test.smtp.com
          smtp_mail_from: apiadmin@apigee.com
          smtp_user: test@example.com
          smtp_password: testpassword
          smtp_ssl: 'y'
          smtp_port: 465
          script_base_path: 'https://raw.githubusercontent.com/apigee/edge-gcp/master/multinode-autoscale/jinja/ansible-scripts'
          config:
            code_with_config:
              ds:
              ms:
              router:
              - conf_load_balancing_load.balancing.driver.nginx.limit_conn=25000
              - bin_setenv_min_mem=1024m
              - bin_setenv_max_mem=3072m
              - bin_setenv_max_permsize=256m
              mp:
              - bin_setenv_min_mem=1024m
              - bin_setenv_max_mem=3072m
              - bin_setenv_max_permsize=256m
              - conf_system_jsse.enableSNIExtension=true
              - conf_threadpool_maximum.pool.size=150
              - conf_http_HTTPTransport.max.client.count=20000
              ax:
              portal:
          license: "JakHrOe9fuHhHyuJYF8NtiKkIvW01Oa6PZcuaWZql8U
    V6KicnWnZJZzdLhTZskwz+DqcwNf0R1+UaFaPg=="
          public_key: "apigee:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpI7cH+5dBvsiNrVOwd6kvZ2r7aXAHofCpZzVpm8w== apigee"
          private_key: "-----BEGIN RSA PRIVATE KEY-----
    MIIJKAIBAAKCAgEAqSPpE8rZAnDpJaAfVjZ+MsWJThQJgi3dL4DlLnURt7ErWeKo
    VsMR3pz/wbIX7fAMr+eMGtmm1gMna5gzMaZy9nON/hE/vJ89J7KsfaEIA8c=
    -----END RSA PRIVATE KEY-----"
    ```
- Deploy to GCP

    ```
    ./deploy.sh "RESOURCE_NAME"
    ```
    RESOURCE_NAME is the name you give to your deployments. All the GCP resources will be tagged under that RESOURCE. All the GCP resources are created with name  having prefix of "RESOURCE_NAME".
    e.g :
```sh
  ./deploy.sh edgetest
The fingerprint of the deployment is kY-5qna7-zBpeFh5-LxFEQ==
Waiting for create [operation-1519496035049-565f93d681e28-0d7ff0e0-f76e967c]...done.
Create operation operation-1519496035049-565f93d681e28-0d7ff0e0-f76e967c completed successfully.
NAME                                          TYPE                             STATE      ERRORS  INTENT
edgetest-apigee-edge-setup-address            compute.v1.globalAddress         COMPLETED  []
edgetest-dc-1-apigee-ax0                      compute.v1.instance              COMPLETED  []
edgetest-dc-1-apigee-ax1                      compute.v1.instance              COMPLETED  []
edgetest-dc-1-apigee-dp                       compute.v1.instance              COMPLETED  []
edgetest-dc-1-apigee-mgmt                     compute.v1.instance              COMPLETED  []
edgetest-dc-1-apigee-rmp-as-bes-prod          compute.v1.backendService        COMPLETED  []
edgetest-dc-1-apigee-rmp-as-bes-test          compute.v1.backendService        COMPLETED  []
edgetest-dc-1-apigee-rmp-as-hc                compute.v1.httpHealthCheck       COMPLETED  []
edgetest-dc-1-apigee-rmp-as-igm               compute.v1.instanceGroupManager  COMPLETED  []
edgetest-dc-1-apigee-rmp-as-it                compute.v1.instanceTemplate      COMPLETED  []
edgetest-dc-1-apigee-rmp-as-l7lb-prod         compute.v1.globalForwardingRule  COMPLETED  []
edgetest-dc-1-apigee-rmp-as-l7lb-test         compute.v1.globalForwardingRule  COMPLETED  []
edgetest-dc-1-apigee-rmp-as-lb                compute.v1.firewall              COMPLETED  []
edgetest-dc-1-apigee-rmp-as-targetproxy-prod  compute.v1.targetHttpProxy       COMPLETED  []
edgetest-dc-1-apigee-rmp-as-targetproxy-test  compute.v1.targetHttpProxy       COMPLETED  []
edgetest-dc-1-apigee-rmp-as-urlmap-prod       compute.v1.urlMap                COMPLETED  []
edgetest-dc-1-apigee-rmp-as-urlmap-test       compute.v1.urlMap                COMPLETED  []
edgetest-dc-1-network                         compute.v1.network               COMPLETED  []
edgetest-dc-1-network-firewall                compute.v1.firewall              COMPLETED  []
edgetest-dc-1-network-firewall-internal       compute.v1.firewall              COMPLETED  []
edgetest-dc-1-network-subnet                  compute.v1.subnetwork            COMPLETED  []
Please allow upto 15 minutes for edge to be installed
Please access the Edge UI at http://104.197.144.238:9000
Management Server is at http://104.197.144.238:8080
Please access the Devportal  at http://35.192.96.108:8079
Cred to access EdgeUI/Managament Server/DevPortal is :"opdk@apigee.com"/'Secret123'
Montitoring Dashboard http://104.197.144.238:3000
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

## Apigee Deployment Topologies on GCP

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


## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.

