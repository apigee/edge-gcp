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

- Setup the test client and test target server. 
Edit setup/apigee-test.yaml with the required entries. In this case you can setup test targets with as many regions. There will be a GLB that will load balance
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
./setup/setup.sh edgescale-test

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



## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.
