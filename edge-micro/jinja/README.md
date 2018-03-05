# edge-micro
This project allows you to install edge microgatewayy in Google Cloud Platform using GCP's deployment manager. 

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Edge Micro

Please refer here for more details: https://docs.apigee.com/microgateway/content/edge-microgateway-home


## Edge Micro Deployment on GCP

This project deploys edge micro on a GCE along with a sample microservice. This also creates a sample proxy in edge along with a api product, app developer and api developers.
 

## Getting Started


- Add missing fields edge->org, edge->env, edge->admin_email , edge->admin_password. In case its private cloud, specify edge->private->mgmt_url and edge->private->api_endpoint. Modify other paraneters as desired.

    | properties                             | Description                                    |
    | -------------------------------------- |:-----------------------------------------------|
    |  machineType                           |  GCP Machine Type.                             |
    |  diskSizeGb                            |  Disk Size                                     |
    |  sourceImage                           |  Source Image                                  |
    |  region                                |  Region                                        |
    |  zone                                  |  Zone                                          |
    |  install_mg_script                     |  Micro gateway Install scripts.                |
    |  edge:org                              |  Edge Organization                             |
    |  edge:env                              |  Edge Environment                              |
    |  edge:admin_email                      |  Edge Org Admin User.                          |
    |  edge:admin_password                   |  Edge Org Admin Password                       |
    |  edge:vhost                            |  Edge Virtualhost                              |
    |  edge:private:mgmt_url                 |  Required for Private Cloud, specify Magament URL.   |
    |  edge:private:api_endpoint             |  Required for Private Cloud, this specifies the api base url|
    |  edge_micro_custom:port                |  Edge Micro gateway Port                       |
    |  edge_micro_custom:policies            |  Edge Micro policy definition.                 |
    |  edge_micro_custom:policies.oauth.verify_api_key_url|  Change this to api endpoint url for private cloud.     |
    |  edge_micro_custom:sequence            |  Edge Micro Policy execution sequence          |
    |  test_setup:microservice:git_base_path |  Microservice git base path.                    |
    |  test_setup:microservice:app_base_path |  Microservice app base path. At this point you can only specify a node.js app. The node.js app will be colocated along with Edge Micro and started with npm start.|
    |  test_setup:microservice:port          | Port on which microservice app is started      |
 
    
- An example of apigee-edge.yaml would look like this. 
    ```sh
          machineType: n1-standard-2
          diskSizeGb: 20
          sourceImage: https://www.googleapis.com/compute/v1/projects/centos-cloud/global/images/family/centos-7
          region: us-east1
          zone: us-east1-b
          install_mg_script: https://storage.googleapis.com/microgateway/install_mg7.sh?ignoreCache=1
          edge:
              org: gaccelerate5
              env: test
              admin_email: rajeshmishra@apigee.com
              admin_password: mypassword
              vhost: "default"
              private:
                mgmt_url:
                api_endpoint:
          edge_micro_custom:
              port: 8000
              policies:
              - oauth:
                  allowNoAuthorization: false
                  allowInvalidAuthorization: false
                  verify_api_key_url: https://gaccelerate5-test.apigee.net/edgemicro-auth/verifyApiKey
              - spikearrest:
                  allow: 10
                  timeUnit: minute
              sequence:
              - oauth
              - spikearrest
          test_setup:
            microservice:
              git_base_path: https://github.com/rajeshm7910/samples
              app_base_path: ./samples/hello_app
              port: 8081
    ```
- Deploy to GCP

    ```
    ./deploy.sh "RESOURCE_NAME"
    ```
    RESOURCE_NAME is the name you give to your deployments. All the GCP resources will be tagged under that RESOURCE. All the GCP resources are created with name  having prefix of "RESOURCE_NAME".
    e.g :
```sh
  ./deploy.sh sample
The fingerprint of the deployment is IRsguCa3_IDk5Hu2aKsN6g==
Waiting for create [operation-1520187498936-5669a3bddb6c1-3ba6a36a-45d2167b]...done.
Create operation operation-1520187498936-5669a3bddb6c1-3ba6a36a-45d2167b completed successfully.
NAME                        TYPE                 STATE      ERRORS  INTENT
sample-network-firewall     compute.v1.firewall  COMPLETED  []
sample-us-east1-us-east1-b  compute.v1.instance  COMPLETED  []
Please allow upto 2 minutes for edge micro to be installed
Please access edge micro api at curl http://35.196.198.2:8000/sample;echo
```


## Undeploy and Clean the deployment
```sh
./clean.sh "RESOURCE_NAME"
```
e.g :
```sh
./clean.sh sample
```

## Troubleshootig

Please ssh to the edge micro box and check /var/log/messages

- Check if apigee-edge-micro.yaml properties are correct. 


## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.

