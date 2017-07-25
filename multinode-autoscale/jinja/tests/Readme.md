# edge-gcp-test
This section provides the test cases to test resilience, HA and Scalibility.

## Support
This is an open-source project of the Apigee Corporation. It is not covered by Apigee support contracts. However, we will support you as best we can. For help, please open an issue in this GitHub project. You are also always welcome to submit a pull request.


## Prerequisite

### gcloud 
Install gcloud sdk from https://cloud.google.com/sdk/downloads
Initialize your account

## Getting Started
- Please copy the generated key pair file apigee.key and apigee.key.pub in this directory.

- Setup  test client and test target server. 
Edit setup/apigee-test.yaml with the required entries. In this case you can setup test targets with as many regions/zone as desired. There will be a GLB that will load balance
between all test targets.
In the public-key properties, paste the public key generated earlier.
```sh
imports:
- path: apigee-test-target-template.jinja
- path: apigee-test-client-template.jinja
resources:
- name: apigee-test-target-setup
  type: apigee-test-target-template.jinja
  properties:
    regions:
    - name: us-east1
      zone: us-east1-b
      autoscale:
        size: 1
        max: 5
    - name: us-west1
      zone: us-west1-b
      autoscale:
       size: 1
       max: 5
- name: apigee-test-client-setup
  type: apigee-test-client-template.jinja
  properties:
    regions:
    - name: us-east1
      zones: 
      - us-east1-b
    - name: us-west1
      zones: 
      - us-west1-b
    public-key: "apigee:ssh-rsa AAAAB3NzaC+u0AiCmFFDrbz6iBkGgS4Zw== apigee"
    edge:
        mgmt: http://104.198.61.121:8080
        org: ASG
        enviornment: prod
        user: opdk@apigee.com
```
Then you can run the setup as shown below
./setup/setup.sh <<TEST_RESOURCE_NAME>>
for ex:
```sh
./setup/setup.sh edgescale-test
The fingerprint of the deployment is tuI64RooS6Bww5yLgEtTKg==
Waiting for create [operation-1500688097248-554de2cf48301-66a536c1-bf679b2b]...done.
Create operation operation-1500688097248-554de2cf48301-66a536c1-bf679b2b completed successfully.
NAME                                               TYPE                             STATE      ERRORS  INTENT
edgescale-test-apigee-test-target-setup-address       compute.v1.globalAddress         COMPLETED  []
edgescale-test-apigee-test-target-setup-bes           compute.v1.backendService        COMPLETED  []
edgescale-test-apigee-test-target-setup-hc            compute.v1.httpHealthCheck       COMPLETED  []
edgescale-test-apigee-test-target-setup-it            compute.v1.instanceTemplate      COMPLETED  []
edgescale-test-apigee-test-target-setup-l7lb          compute.v1.globalForwardingRule  COMPLETED  []
edgescale-test-apigee-test-target-setup-targetproxy   compute.v1.targetHttpProxy       COMPLETED  []
edgescale-test-apigee-test-target-setup-urlmap        compute.v1.urlMap                COMPLETED  []
edgescale-test-apigee-test-target-setup-us-east1-as   compute.v1.autoscaler            COMPLETED  []
edgescale-test-apigee-test-target-setup-us-east1-igm  compute.v1.instanceGroupManager  COMPLETED  []
edgescale-test-apigee-test-target-setup-us-west1-as   compute.v1.autoscaler            COMPLETED  []
edgescale-test-apigee-test-target-setup-us-west1-igm  compute.v1.instanceGroupManager  COMPLETED  []
edgescale-test-client-us-east1-us-east1-b             compute.v1.instance              COMPLETED  []
edgescale-test-client-us-west1-us-west1-b             compute.v1.instance              COMPLETED  []
The target url to test:  http://35.186.239.160/customers.json
Deploying Pass through API Proxy with target Url
s/<URL><\/URL>/<URL>http:\/\/35.186.239.160\/customers.json<\/URL>/g
http://104.198.61.121:8080
Password: *********
"customers" Revision 1
  deployed
  environment = prod
  base path = /
  URI = http://35.186.244.153:9001/customers
s/<URL>http:\/\/35.186.239.160\/customers.json<\/URL>/<URL><\/URL>/g

```

This creates 2 target servers(Based on Autoscale size) on us-east1 and us-west1 region respectively and adds a GLB to load balance them. The two target servers runs nginx and hosts customers.json. 

It also creates two test clients on us-east1 and us-west1 region and installs apib(API benchmark tool) on /home/apigee/apib directory. You can run load testing from these nodes.

It also installs a customer proxy with base path of /customers with the target just created on the edge server provided in the yaml file.


- For reslience testing please run following command 
```sh
./resilience_testing.sh "RESOURCE_NAME"
```
e.g :
```sh
./resilience_testing.sh edgescale
```
- For HA testing please run following command 
```sh
./ha.sh "RESOURCE_NAME"
```
e.g :
```sh
./ha.sh edgescale
```

- For Autoscaling testing please run following command 
```sh
./auto_scaling_testing.sh "TEST_RESOURCE_NAME" <<ConCURRENCY>> <<DURATION>>  <<API_BASE_URL>>
```
e.g :
```sh
./auto_scaling_testing.sh edgescale-test 100 600 http://35.186.244.153
```

- Clean
 ```sh
 ./setup/clean.sh <<TEST_RESOURCE_NAME>>
 ```


## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.
